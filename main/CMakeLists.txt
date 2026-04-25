idf_component_register(
    REQUIRES espidf_gnat_runtime)

ExternalProject_Add(app_main_build
    PREFIX ${COMPONENT_DIR}
    SOURCE_DIR ${COMPONENT_DIR}
    BUILD_IN_SOURCE 1
    BUILD_ALWAYS 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND alr build -- -cargs:c
        "-D$<JOIN:$<TARGET_PROPERTY:app_main,INTERFACE_COMPILE_DEFINITIONS>,$<SEMICOLON>-D>"
        "-I$<JOIN:$<TARGET_PROPERTY:app_main,INTERFACE_INCLUDE_DIRECTORIES>,$<SEMICOLON>-I>"
    COMMAND_EXPAND_LISTS
    INSTALL_COMMAND ""
    BUILD_BYPRODUCTS ${COMPONENT_DIR}/../.objs/app_main.o
)

add_prebuilt_library(app_main "${COMPONENT_LIB}"
    REQUIRES espidf_gnat_runtime)
add_dependencies(app_main_build espidf_gnat_runtime)

target_link_libraries(
    ${COMPONENT_LIB} INTERFACE ${COMPONENT_DIR}/../.objs/app_main.o)
