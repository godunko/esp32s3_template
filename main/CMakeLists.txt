idf_component_register(
    REQUIRES espidf_gnat_runtime)

ExternalProject_Add(adaapplication_build
    PREFIX ${COMPONENT_DIR}
    SOURCE_DIR ${COMPONENT_DIR}
    BUILD_IN_SOURCE 1
    BUILD_ALWAYS 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND alr build
    INSTALL_COMMAND ""
    BUILD_BYPRODUCTS ${COMPONENT_DIR}/../.libs/libadaapplication.a
)

add_prebuilt_library(libadaapplication "${COMPONENT_LIB}"
    REQUIRES espidf_gnat_runtime)
add_dependencies(libadaapplication adaapplication_build)
add_dependencies(adaapplication_build espidf_gnat_runtime)

set_target_properties(libadaapplication PROPERTIES IMPORTED_LOCATION
    ${COMPONENT_DIR}/../.libs/libadaapplication.a)

target_link_libraries(
    ${COMPONENT_LIB} INTERFACE libadaapplication)
