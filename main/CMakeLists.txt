idf_component_register(REQUIRES espidf_gnat_runtime)

idf_component_get_property(runtime_dir espidf_gnat_runtime COMPONENT_DIR)
include("${runtime_dir}/cmake/ada-application.cmake")

espidf_add_ada_application(
    TARGET "${COMPONENT_LIB}"
    PROJECT_DIR "${PROJECT_DIR}"
    OBJECT ".objs/app_main.o")
