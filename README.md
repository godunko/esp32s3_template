# ESP32-S3 Ada Project Template (ESP-IDF Integrated)

[![Build](https://github.com/godunko/esp32s3_template/actions/workflows/main.yaml/badge.svg)](https://github.com/godunko/esp32s3_template/actions/workflows/main.yaml)

This repository provides a template for integrating Ada source code into the ESP-IDF (C-based) build system.
It allows you to leverage the robust drivers and RTOS capabilities of the ESP-IDF while writing your application logic in Ada.

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

This application tests few features of the Ada runtime
Feel free to replace it by your application!
```
`ESP-IDF` and `Ada & SPARK` extensions for VS Code creates useful development environment.

## VS Code Integration

To get the most out of this template, it is recommend installing the following extensions:

 * ESP-IDF Extension: Manages flashing, monitoring, and the SDK configuration (menuconfig).
 * Ada & SPARK Extension: Provides syntax highlighting, IntelliSense, and code navigation for Ada.

# Related repositories

 * [ESP-IDF GNAT Runtime](https://github.com/godunko/espidf_gnat_runtime)
 * [Ada/ESP-IDF Binding](https://github.com/godunko/espidf)
