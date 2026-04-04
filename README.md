# Template of Ada project for ESP32S3

## Setup (2026-03-03)

1. Install [Alire](https://alire.ada.dev/)
2. Install [ESP-IDF tools](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html) in your favorite way (for example, from the VS Code ESP-IDF extension)
3. Clone template repository with submodules
    ```
    git clone --recurse-submodules https://github.com/godunko/esp32s3_template.git my_project
    ```
4. Build native tools (unfortunately, it can't be done automatically yet)
    ```
    alr -C my_project/crates/a0b-tools/ build
    alr -C my_project/crates/xtensa-dynconfig/ build
    ```
5. (optional) Remote GIT metainformation to be able to initialize own repository
    ```
    rm -rf my_project/.git
    ```
6. Configure target, build and flash example application with `idf.py`
    ```
    cd my_project
    idf.py set-target esp32s3
    idf.py build
    idf.py flash
    ```
7. Connect to serial port and reset board

## IDE

`ESP-IDF` and `Ada & SPARK` extensions for VS Code creates useful development environment.
