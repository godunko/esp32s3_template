# ESP32-S3 Ada Project Template

[![Build](https://github.com/godunko/esp32s3_template/actions/workflows/main.yaml/badge.svg)](https://github.com/godunko/esp32s3_template/actions/workflows/main.yaml)

A starter Ada application for ESP32-S3 using ESP-IDF and the embedded GNAT
runtime. The template uses ESP-IDF 6.1, GNAT 16 and `bb-runtimes` branch
`gnat-fsf-16`.

ESP-IDF builds the firmware and the runtime's C bridge. Alire generates the Ada
runtime and builds the application into `.objs/app_main.o`, which ESP-IDF links
into the firmware.

## Build and run

Install ESP-IDF 6.1, Alire, a host C compiler and Make. Alire supplies the Ada
compiler and GPRbuild.

```bash
git clone --recurse-submodules https://github.com/godunko/esp32s3_template.git my_esp32s3_project
cd my_esp32s3_project

alr -n -C crates/a0b-tools build
alr -n -C crates/xtensa-dynconfig build

# Use the path to your ESP-IDF installation.
. "$HOME/esp/esp-idf/export.sh"

idf.py build
idf.py flash monitor
```

For an existing clone, initialize missing dependencies with
`git submodule update --init --recursive` before building the tools.

Use `idf.py build` to build the complete application. The firmware outputs are
`build/esp32s3_application.elf` and `build/esp32s3_application.bin`.

The example prints `Hello, Ada world!` and restarts after one second. With the
ESP-IDF QEMU tools installed, run it without a board:

```bash
idf.py qemu --qemu-extra-args --no-reboot
```

## Project files

- `source/`: application Ada sources; start with `main.adb`.
- `esp32s3_application.gpr`: Ada compiler, binder and linker settings.
- `alire.toml`: Ada dependencies and runtime generation.
- `main/CMakeLists.txt`: connects the Ada build to ESP-IDF.
- `components/espidf_gnat_runtime/`: shared runtime checkout for ESP-IDF and Alire.
- `crates/`: runtime generator, `bb-runtimes` sources and Xtensa configuration tools.

## Configuration

`sdkconfig.defaults` selects ESP32-S3, C++ exceptions for Ada unwinding, Newlib
and two FreeRTOS TLS slots. The Ada ATCB uses slot 1 by default, selected by
`CONFIG_GNAT_RUNTIME_ATCB_TLS_SLOT`; slot 0 belongs to pthread. If another
component needs slot 1, select an unused Ada slot and make
`CONFIG_FREERTOS_THREAD_LOCAL_STORAGE_POINTERS` greater than that index.
Other settings use SDK defaults. Existing values in `sdkconfig` take precedence;
use `idf.py menuconfig` to review them.

Secondary stacks are statically allocated. The binder switch `-D4k` fixes their
size at 4 KiB. `-Q3` is the minimum for ESP32-S3: one secondary stack for the
environment task and one for interrupt handlers on each CPU. Add one for each
foreign thread needing a secondary stack over the application lifetime; those
stacks are not recycled. Ordinary Ada tasks are counted separately by the binder.

When enabling `-fstack-check`, size each primary stack executing instrumented
code for its application workload plus 12 KiB for the compiler's checking
allowance. This includes task and ISR stacks as applicable.

See the [runtime documentation](https://github.com/godunko/espidf_gnat_runtime/blob/main/README.md) for
supported features, interrupt and callback constraints, and ABI requirements.

## Related projects

- [ESP-IDF/Ada bindings](https://github.com/godunko/espidfada)
- [Project scaffolding skill](https://github.com/godunko/ada_espidf_skills/tree/main/ada-espidf-skeleton)
