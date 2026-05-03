# ESP32-S3 Ada Project Template (ESP-IDF Integrated)

[![Build](https://github.com/godunko/esp32s3_template/actions/workflows/main.yaml/badge.svg)](https://github.com/godunko/esp32s3_template/actions/workflows/main.yaml)

This repository provides a template for integrating Ada source code into the ESP-IDF (C-based) build system.
It allows you to leverage the robust drivers and RTOS capabilities of the ESP-IDF while writing your application logic in Ada.

The example application demonstrates GPIO input with a falling-edge interrupt handler,
written entirely in Ada using the Jorvik real-time profile.

## Project Architecture

Instead of a standalone Ada executable, this project compiles Ada source into a encapsulated static library that is linked into the final ESP-IDF project.

 * Ada Side: Managed by Alire (`alr`).
 * System Side: Managed by IDF (`CMake`/`ninja`).

## Prerequisites

 * ESP-IDF SDK: Version 6.x is recommended. Ensure `idf.py` is in your PATH.
 * Alire (Ada Libre Resources): The Ada package manager.

## Build Instructions

Since the Ada build is integrated, you only need to use the standard ESP-IDF commands.

1. Setup Environment

Source the ESP-IDF tools:

```bash
# Linux/macOS
. $HOME/esp/esp-idf/export.sh

# Windows (PowerShell)
. .\export.ps1
```
2. Clone and Build tools

```bash
git clone --recurse-submodules https://github.com/godunko/esp32s3_template.git my_esp32s3_project
cd my_esp32s3_project
alr -C crates/a0b-tools/ build
alr -C crates/xtensa-dynconfig/ build
```
3. Build, Flash, and Monitor via ESP-IDF

The following command compiles both the Ada and C sources, links the binary, flashes the hardware, and opens the serial monitor:

```bash
# Configure the target (first time only)
idf.py set-target esp32s3

# Build the full project (compiles and links Ada library + ESP-IDF components)
idf.py build

# Flash and monitor
idf.py flash monitor
```

You should see now

```
Hello, Ada world!

GPIO0 is configured as INPUT_PULLUP with falling-edge interrupt
Pull GPIO0 low to trigger the Ada interrupt procedure

GPIO0 interrupt count: 1
GPIO0 interrupt count: 2
...
```

## GPIO Abstraction Packages

The project introduces a two-level Ada package hierarchy for GPIO that separates the portable API from chip-specific details.

### `ESP32.GPIO` — portable API

`source/esp32-gpio.ads` / `esp32-gpio.adb` define the generic GPIO interface used by all ESP32 variants:

* `GPIO_Pin` — an unconstrained non-negative integer type accepted by the IDF.
* Direction, pull-up/pull-down, interrupt-type enumerations with IDF representation clauses.
* Thin Ada wrappers around the IDF C functions (`gpio_reset_pin`, `gpio_set_direction`, etc.).
* `GPIO_Error` exception raised on any IDF error return.

### `ESP32.S3.GPIO` — ESP32-S3 specifics

`source/esp32-s3-gpio.ads` narrows the portable types to the concrete ESP32-S3 silicon:

* `GPIO_Min_Pin = 0`, `GPIO_Max_Pin = 48` — the full S3 range.
* `Safe_GPIO_Pin` — a subtype with both a range constraint *and* a `Static_Predicate` that
  excludes the two reserved regions:
  * GPIO 26–32 — internal SPI flash (SPI0 / SPI1)
  * GPIO 33–37 — Octal PSRAM (on modules such as ESP32-S3-WROOM-1-N8R8)

  Assigning a reserved pin number to `Safe_GPIO_Pin` is caught at **compile time** when the
  value is a static literal or named constant.

* `Core_0_Interrupt_Source` and `Core_1_Interrupt_Source` — the ESP32-S3 GPIO interrupt
  matrix source IDs used when registering interrupt handlers.

## Interrupt Handling with the Jorvik Profile

The project uses `pragma Profile (Jorvik)`, which implies `No_Dynamic_Attachment`.
Dynamic calls such as `Ada.Interrupts.Attach_Handler` at run time raise `Program_Error`
under this profile.  Static attachment via `pragma Attach_Handler` inside a protected type
declaration is fully supported and is the idiomatic Jorvik approach.

A protected object with `pragma Interrupt_Priority` and `pragma Attach_Handler` maps
directly onto the ESP-IDF interrupt-matrix mechanism.  The runtime allocates a CPU interrupt
slot at elaboration time via `__gnat_esp_intr_alloc` and registers the handler — no dynamic
binding and no calls to `esp_intr_alloc` from user code.

```ada
protected GPIO0_Handler is
   pragma Interrupt_Priority (System.Interrupt_Priority'Last);
   procedure On_Low;
   pragma Attach_Handler (On_Low, GPIO_Intr_Source);  --  static, Jorvik-safe
   function Trigger_Count return Interfaces.Unsigned_32;
private
   Press_Count : Interfaces.Unsigned_32 := 0;
end GPIO0_Handler;
```

`GPIO_Intr_Source` is a static constant (`ESP32.S3.GPIO.Core_0_Interrupt_Source = 16`), so
the attachment is resolved entirely at compile/elaboration time.

## Example: GPIO0 Falling-Edge Interrupt Counter

`source/gpio0_interrupt.ads` / `.adb` demonstrate the full pattern:

1. **Pin configuration** — `Initialize` calls the `ESP32.GPIO` API to configure GPIO0 as
   an input with pull-up enabled and a falling-edge interrupt:

   ```ada
   ESP32.GPIO.Reset_Pin        (GPIO0);
   ESP32.GPIO.Set_Direction    (GPIO0, ESP32.GPIO.Mode_Input);
   ESP32.GPIO.Pullup_Enable    (GPIO0);
   ESP32.GPIO.Pulldown_Disable (GPIO0);
   ESP32.GPIO.Set_Intr_Type    (GPIO0, ESP32.GPIO.Intr_Negative_Edge);
   ESP32.GPIO.Intr_Enable      (GPIO0);
   ```

   `GPIO0` is declared as `Safe_GPIO_Pin := 0`, so a typo that produces a reserved pin
   number would be rejected at compile time.

2. **Interrupt handler** — the protected procedure `On_Low` increments a counter using the
   Ada 2022 target-name shorthand:

   ```ada
   procedure On_Low is
   begin
      Press_Count := @ + 1;
   end On_Low;
   ```

3. **Main loop** — `source/main.adb` polls `GPIO0_Interrupt.Trigger_Count` every 50 ms and
   prints a line each time the count changes:

   ```ada
   loop
      declare
         Count : constant Interfaces.Unsigned_32 := GPIO0_Interrupt.Trigger_Count;
      begin
         if Count /= Last_Count then
            Last_Count := Count;
            Ada.Text_IO.Put_Line ("GPIO0 interrupt count:" & Interfaces.Unsigned_32'Image (Count));
         end if;
      end;
      delay 0.05;
   end loop;
   ```

Pull GPIO0 to GND (e.g. with a button or a wire) to trigger the interrupt and watch the
counter increment on the serial monitor.

`ESP-IDF` and `Ada & SPARK` extensions for VS Code creates useful development environment.

## VS Code Integration

To get the most out of this template, it is recommend installing the following extensions:

 * ESP-IDF Extension: Manages flashing, monitoring, and the SDK configuration (menuconfig).
 * Ada & SPARK Extension: Provides syntax highlighting, IntelliSense, and code navigation for Ada.

# Related repositories

 * [ESP-IDF GNAT Runtime](https://github.com/godunko/espidf_gnat_runtime)
 * [Ada/ESP-IDF Binding](https://github.com/godunko/espidf)
