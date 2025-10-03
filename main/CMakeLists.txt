idf_component_register()

ExternalProject_Add(adademo_build
    PREFIX ${COMPONENT_DIR}
    SOURCE_DIR ${COMPONENT_DIR}
    BUILD_IN_SOURCE 1
    BUILD_ALWAYS 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND  alr build
    INSTALL_COMMAND ""
    BUILD_BYPRODUCTS ${COMPONENT_DIR}/.libs/liblight_esp32_demo.a
)

add_library(liblight_esp32_demo STATIC IMPORTED GLOBAL)
add_dependencies(liblight_esp32_demo adademo_build)

set_target_properties(liblight_esp32_demo PROPERTIES IMPORTED_LOCATION
     ${COMPONENT_DIR}/.libs/liblight_esp32_demo.a)

target_link_libraries(
    ${COMPONENT_LIB} INTERFACE liblight_esp32_demo
     "-lgnat" "-L${COMPONENT_DIR}/runtime/lib")

set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES
     "${COMPONENT_DIR}/.libs/liblight_esp32_demo.a")
