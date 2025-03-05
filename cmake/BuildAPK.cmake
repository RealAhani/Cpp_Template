# ## Build android apk
macro(BuildAPK target_link)
    if(BUILD_APK)
        set(ANDROIDLISTS "arm64-v8a")

        # after build add lib to the specific folder
        if(CMAKE_BUILD_TYPE STREQUAL "Release")
            LIST(APPEND ANDROIDLISTS "armeabi-v7a;x86_64;x86")
        endif(CMAKE_BUILD_TYPE STREQUAL "Release")

        foreach(P_ABI IN LISTS ANDROIDLISTS)
            add_custom_command(
                OUTPUT "${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/Other/Android/App/lib/${P_ABI}"
                COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/Other/Android/${P_ABI}/out/${BUILD_ARCH}_${CMAKE_BUILD_TYPE}/lib/lib${LIBNAME}.so" ${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/Other/Android/App/lib/${P_ABI})
            add_custom_target("copy_file${P_ABI}" ALL DEPENDS "${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/Other/Android/App/lib/${P_ABI}")
        endforeach(P_ABI IN LISTS ANDROIDLISTS)

        if(CMAKE_BUILD_TYPE STREQUAL "Release")
            add_custom_command(
                OUTPUT "${ANDROID_OUTPUT}/bin"

                # copy resource
                COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_SOURCE_DIR}/resources/android/res"
                "res"
                COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_SOURCE_DIR}/resources/assets"
                "assets"

                # copy config_bak
                COMMAND ${CMAKE_COMMAND} -E copy_directory "config_bak" "."
                COMMAND ${CMAKE_COMMAND} -E remove_directory "config_bak"

                # generate R.java
                COMMAND $ENV{BUILD_TOOLS}/aapt ARGS package -f -m -S "res" -J "src" -M
                "AndroidManifest.xml" -I "${ANDROID_PLATFORM_PATH}/android.jar"

                # compile java to class
                COMMAND
                javac ARGS -Xlint:deprecation -verbose -source 1.8 -target 1.8 -d
                "${ANDROID_OUTPUT}/obj" -bootclasspath "${JAVA_HOME}/jre/lib/rt.jar"
                -classpath "${ANDROID_PLATFORM_PATH}/android.jar" -sourcepath
                "${ANDROID_OUTPUT}/src"
                "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/R.java"
                "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.java"

                # compile .class to .dex
                COMMAND $ENV{BUILD_TOOLS}/dx ARGS --verbose --dex
                --output="${ANDROID_OUTPUT}/bin/classes.dex" "${ANDROID_OUTPUT}/obj"

                # pack apk
                COMMAND
                $ENV{BUILD_TOOLS}/aapt ARGS package -f -M "AndroidManifest.xml" -S "res"
                -A "${ANDROID_OUTPUT}/assets" -I "${ANDROID_PLATFORM_PATH}/android.jar" -F
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk ${ANDROID_OUTPUT}/bin

                COMMAND
                $ENV{BUILD_TOOLS}/aapt ARGS add
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                "lib/arm64-v8a/*"

                COMMAND
                $ENV{BUILD_TOOLS}/aapt ARGS add
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                "lib/armeabi-v7a/*"

                COMMAND
                $ENV{BUILD_TOOLS}/aapt ARGS add
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                "lib/x86_64/*"

                COMMAND
                $ENV{BUILD_TOOLS}/aapt ARGS add
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                "lib/x86/*"

                # align apk
                COMMAND
                $ENV{BUILD_TOOLS}/zipalign ARGS -f 4
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.signed.apk

                # sign apk
                COMMAND
                $ENV{BUILD_TOOLS}/apksigner ARGS sign --ks
                ${ANDROID_OUTPUT}/key/key.keystore --out
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.final.apk --ks-pass
                pass:${APP_KEYSTORE_PASS} ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.signed.apk
                WORKING_DIRECTORY ${ANDROID_OUTPUT})
            add_custom_target("buildapp" ALL DEPENDS "${ANDROID_OUTPUT}/bin")
        else()
            add_custom_command(
                OUTPUT "${ANDROID_OUTPUT}/bin"

                # copy resource
                COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_SOURCE_DIR}/resources/android/res"
                "res"
                COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_SOURCE_DIR}/resources/assets"
                "assets"

                # copy config_bak
                COMMAND ${CMAKE_COMMAND} -E copy_directory "config_bak" "."
                COMMAND ${CMAKE_COMMAND} -E remove_directory "config_bak"

                # generate R.java
                COMMAND $ENV{BUILD_TOOLS}/aapt ARGS package -f -m -S "res" -J "src" -M
                "AndroidManifest.xml" -I "${ANDROID_PLATFORM_PATH}/android.jar"

                # compile java to class
                COMMAND
                javac ARGS -Xlint:deprecation -verbose -source 1.8 -target 1.8 -d
                "${ANDROID_OUTPUT}/obj" -bootclasspath "${JAVA_HOME}/jre/lib/rt.jar"
                -classpath "${ANDROID_PLATFORM_PATH}/android.jar" -sourcepath
                "${ANDROID_OUTPUT}/src"
                "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/R.java"
                "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.java"

                # compile .class to .dex
                COMMAND $ENV{BUILD_TOOLS}/dx ARGS --verbose --dex
                --output="${ANDROID_OUTPUT}/bin/classes.dex" "${ANDROID_OUTPUT}/obj"

                # pack apk
                COMMAND
                $ENV{BUILD_TOOLS}/aapt ARGS package -f -M "AndroidManifest.xml" -S "res"
                -A "${ANDROID_OUTPUT}/assets" -I "${ANDROID_PLATFORM_PATH}/android.jar" -F
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk ${ANDROID_OUTPUT}/bin

                COMMAND
                $ENV{BUILD_TOOLS}/aapt ARGS add
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                "lib/arm64-v8a/*"

                # align apk
                COMMAND
                $ENV{BUILD_TOOLS}/zipalign ARGS -f 4
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.signed.apk

                # sign apk
                COMMAND
                $ENV{BUILD_TOOLS}/apksigner ARGS sign --ks
                ${ANDROID_OUTPUT}/key/key.keystore --out
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.final.apk --ks-pass
                pass:${APP_KEYSTORE_PASS} ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.signed.apk
                WORKING_DIRECTORY ${ANDROID_OUTPUT})
            add_custom_target("buildapp" ALL DEPENDS "${ANDROID_OUTPUT}/bin")
        endif(CMAKE_BUILD_TYPE STREQUAL "Release")

        # working with android command line tools to generate android related stuff and finally create the .apk
    endif(BUILD_APK)

    # end
endmacro(BuildAPK target_link)