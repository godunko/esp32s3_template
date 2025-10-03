# Template of Ada project for ESP32S3

## Setup (2025-10-03)

1. Install [Alire](https://alire.ada.dev/)
2. Install [ESP-IDF tools](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html) in your favorite way (for example, from the VS Code ESP-IDF extension)
3. Download and build plugin for GCC toolchain
   ```
    git clone https://github.com/godunko/xtensa-dynconfig.git
    alr -C xtensa-dynconfig build
   ```
4. Download and build `a0b-tools` runtime generator
   ```
    git clone https://github.com/godunko/a0b-tools.git
    alr -C a0b-tools build
   ```
5. Download `bb-runtimes-15` package
   ```
    git clone git@github.com:alire-project/bb-runtimes.git bb-runtimes-15 --branch gnat-fsf-15
   ```
6. Download Ada project template and remote GIT metainformation
   ```
    git clone https://github.com/godunko/esp32s3_template.git my_project
    rm -rf my_project/.git
   ```

Done!

## Build

To build/flash/debug regular ESP-IDF tools should be used.
