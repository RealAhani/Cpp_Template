# ## Android
macro(AndroidSetup target_link)
    if(CMAKE_BUILD_TYPE MATCHES Release)
        set(ANDROID_APK_DEBUGGABLE "false")
    else()
        set(ANDROID_APK_DEBUGGABLE "true")
    endif(CMAKE_BUILD_TYPE MATCHES Release)

    # # Add native_app_glue lib
    add_library(
        native_app_glue STATIC
        "${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c")

    # # include native_app_glue to project
    target_include_directories(${target_link} PRIVATE "${ANDROID_NDK}/sources/android/native_app_glue")

    # # cmake linker flag for finding entry point
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -u
      ANativeActivity_onCreate")

    # set_property(
    # TARGET ${target_link} PROPERTY LIBRARY_OUTPUT_DIRECTORY
    # ${ANDROID_OUTPUT}/lib/${ANDROID_ABI})
    target_compile_definitions(
        ${target_link} PUBLIC RESOURCE_PATH="${CMAKE_SOURCE_DIR}/resources/assets"
        "ANDROID")

    # generate .xml
    file(
        GLOB_RECURSE RES_FILES
        RELATIVE "${CMAKE_SOURCE_DIR}/resources/android"
        "${CMAKE_SOURCE_DIR}/resources/android/res/**.xml" "${CMAKE_SOURCE_DIR}/resources/android/*.xml")

    foreach(FILE IN LISTS RES_FILES)
        configure_file(${CMAKE_SOURCE_DIR}/resources/android/${FILE}
            ${ANDROID_OUTPUT}/config_bak/${FILE})
    endforeach()

    # configure NativeLoader.java
    configure_file(
        "${CMAKE_SOURCE_DIR}/resources/android/NativeLoader.java"
        "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.java"
    )

    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        add_custom_command(
            TARGET ${target_link}
            PRE_BUILD

            # prepare directory
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}/key
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${ANDROID_OUTPUT}/bin
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${ANDROID_OUTPUT}/lib
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${ANDROID_OUTPUT}/res
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${ANDROID_OUTPUT}/assets
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}/bin
            COMMAND ${CMAKE_COMMAND} -E make_directory
            ${ANDROID_OUTPUT}/lib/arm64-v8a
            COMMAND ${CMAKE_COMMAND} -E make_directory
            ${ANDROID_OUTPUT}/lib/armeabi-v7a
            COMMAND ${CMAKE_COMMAND} -E make_directory
            ${ANDROID_OUTPUT}/lib/x86_64
            COMMAND ${CMAKE_COMMAND} -E make_directory
            ${ANDROID_OUTPUT}/lib/x86
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}/res
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}/obj)
    else()
        add_custom_command(
            TARGET ${target_link}
            PRE_BUILD

            # prepare directory
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}/key
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${ANDROID_OUTPUT}/bin
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${ANDROID_OUTPUT}/lib
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${ANDROID_OUTPUT}/res
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${ANDROID_OUTPUT}/assets
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}/bin
            COMMAND ${CMAKE_COMMAND} -E make_directory
            ${ANDROID_OUTPUT}/lib/arm64-v8a
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}/res
            COMMAND ${CMAKE_COMMAND} -E make_directory ${ANDROID_OUTPUT}/obj)
    endif(CMAKE_BUILD_TYPE STREQUAL "Release")

    # ordering the apk directory
    if(NOT EXISTS ${ANDROID_OUTPUT}/key/key.keystore)
        add_custom_command(
            OUTPUT "${ANDROID_OUTPUT}/key/key.keystore"
            COMMAND keytool ARGS -genkeypair -validity 1000 -dname
            "CN=${APP_COMPANY_NAME},O=Android,C=ES" -keystore
            ${ANDROID_OUTPUT}/key/key.keystore -storepass ${APP_KEYSTORE_PASS}
            -keypass ${APP_KEYSTORE_PASS} -alias ${target_link}Key -keyalg RSA)
        add_custom_target("generateKey" ALL DEPENDS "${ANDROID_OUTPUT}/key/key.keystore")
    endif()
endmacro(AndroidSetup target_link)
