# ## Build android apk
macro(BuildAPK target_link)
    if(BUILD_APK)
        set(ANDROIDLISTS "arm64-v8a")

        # after build add lib to the specific folder
        if(CMAKE_BUILD_TYPE STREQUAL "Release")
            # LIST(APPEND ANDROIDLISTS "armeabi-v7a;x86_64;x86")
            LIST(APPEND ANDROIDLISTS "armeabi-v7a")
        endif(CMAKE_BUILD_TYPE STREQUAL "Release")

        foreach(P_ABI IN LISTS ANDROIDLISTS)
            add_custom_command(
                OUTPUT "${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/Other/Android/App/lib/${P_ABI}"
                COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/thirdParty/lib/Android/${CMAKE_BUILD_TYPE}/lib${LIBNAME}.so" ${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/Other/Android/App/lib/${P_ABI})
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
                COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_SOURCE_DIR}/resources/android/lib"
                "jarLibs"

                # copy config_bak
                COMMAND ${CMAKE_COMMAND} -E copy_directory "config_bak" "."
                COMMAND ${CMAKE_COMMAND} -E remove_directory "config_bak"

                # generate R.java
                COMMAND $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS package -f -m -S "res" -J "src" -M
                "AndroidManifest.xml" -I "${ANDROID_PLATFORM_PATH}/android.jar"

                # ##compile java to class
                # NOTE: on line 43 you should change : with ; in windows

                # ## for java 8.0
                # COMMAND
                # javac${BINEXE} ARGS -Xlint:deprecation -verbose -source 1.8 -target 1.8 -d
                # "${ANDROID_OUTPUT}/obj" -bootclasspath "${JAVA_HOME}/jre/lib/rt.jar"
                # -classpath "${ANDROID_PLATFORM_PATH}/android.jar:${ANDROID_OUTPUT}/jarLibs/*" -sourcepath
                # "${ANDROID_OUTPUT}/src"
                # "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/R.java"
                # "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.java"

                # ## for java > 8.0
                COMMAND
                javac${BINEXE} ARGS -Xlint:deprecation -verbose -source 1.8 -target 1.8 -d
                "${ANDROID_OUTPUT}/obj"
                -bootclasspath "${ANDROID_PLATFORM_PATH}/android.jar"
                -classpath "${ANDROID_OUTPUT}/jarLibs/*"
                -sourcepath "${ANDROID_OUTPUT}/src"
                "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/R.java"
                "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.java"

                # compile .class to .dex
                # ## with dx
                # COMMAND $ENV{BUILD_TOOLS}/dx${BINSHELL} ARGS --verbose --dex
                # --output="${ANDROID_OUTPUT}/bin/classes.dex" "${ANDROID_OUTPUT}/obj"
                # ## with d8
                COMMAND $ENV{BUILD_TOOLS}/d8${BINSHELL} ARGS "${ANDROID_OUTPUT}/obj/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.class"
                --release --output "${ANDROID_OUTPUT}/bin"
                --lib "${ANDROID_PLATFORM_PATH}/android.jar" --classpath "${ANDROID_OUTPUT}/obj"

                # pack apk
                COMMAND
                $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS package -f -M "AndroidManifest.xml" -S "res"
                -A "${ANDROID_OUTPUT}/assets" -I "${ANDROID_PLATFORM_PATH}/android.jar" -F
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk ${ANDROID_OUTPUT}/bin

                COMMAND
                $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS add
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                "lib/arm64-v8a/lib${LIBNAME}.so"

                COMMAND
                $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS add
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                "lib/armeabi-v7a/lib${LIBNAME}.so"

                # COMMAND
                # $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS add
                # ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                # "lib/x86_64/lib${LIBNAME}.so"

                # COMMAND
                # $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS add
                # ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                # "lib/x86/lib${LIBNAME}.so"

                # align apk
                COMMAND
                $ENV{BUILD_TOOLS}/zipalign${BINEXE} ARGS -f 4
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.signed.apk

                # sign apk
                COMMAND
                $ENV{BUILD_TOOLS}/apksigner${BINSHELL} ARGS sign --ks
                ${ANDROID_OUTPUT}/key/key.keystore --out
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.final.apk --ks-pass
                pass:${APP_KEYSTORE_PASS} ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.signed.apk
                WORKING_DIRECTORY ${ANDROID_OUTPUT})
            add_custom_target("buildapp" ALL DEPENDS "${ANDROID_OUTPUT}/bin")
        else() # debug
            add_custom_command(
                OUTPUT "${ANDROID_OUTPUT}/bin"

                # copy resource
                COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_SOURCE_DIR}/resources/android/res"
                "res"
                COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_SOURCE_DIR}/resources/assets"
                "assets"
                COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_SOURCE_DIR}/resources/android/lib"
                "jarLibs"

                # copy config_bak
                COMMAND ${CMAKE_COMMAND} -E copy_directory "config_bak" "."
                COMMAND ${CMAKE_COMMAND} -E remove_directory "config_bak"

                # generate R.java
                COMMAND $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS package -f -m -S "res" -J "src" -M
                "AndroidManifest.xml" -I "${ANDROID_PLATFORM_PATH}/android.jar"

                # compile java to class
                # on line 136 you should change : with ; if the host is windows
                # ## for java == 8.0
                # COMMAND
                # javac${BINEXE} ARGS -Xlint:deprecation -verbose -source 1.8 -target 1.8 -d
                # "${ANDROID_OUTPUT}/obj" -bootclasspath "${JAVA_HOME}/jre/lib/rt.jar"
                # -classpath "${ANDROID_PLATFORM_PATH}/android.jar:${ANDROID_OUTPUT}/jarLibs/*" -sourcepath
                # "${ANDROID_OUTPUT}/src"
                # "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/R.java"
                # "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.java"

                # ## compile java to class
                # ## for java > 8.0
                COMMAND
                javac${BINEXE} ARGS -Xlint:deprecation -verbose -source 1.8 -target 1.8 -d
                "${ANDROID_OUTPUT}/obj"
                -bootclasspath "${ANDROID_PLATFORM_PATH}/android.jar"
                -classpath "${ANDROID_OUTPUT}/jarLibs/*"
                -sourcepath "${ANDROID_OUTPUT}/src"
                "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/R.java"
                "${ANDROID_OUTPUT}/src/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.java"

                # ## compile .class to .dex

                # ## with .dx
                # COMMAND $ENV{BUILD_TOOLS}/dx${BINSHELL} ARGS --verbose --dex
                # --output="${ANDROID_OUTPUT}/bin/classes.dex" "${ANDROID_OUTPUT}/obj"

                # ## with d8
                COMMAND $ENV{BUILD_TOOLS}/d8${BINSHELL} ARGS "${ANDROID_OUTPUT}/obj/com/${APP_COMPANY_NAME}/${APP_PRODUCT_NAME}/NativeLoader.class"
                --debug --output "${ANDROID_OUTPUT}/bin"
                --lib "${ANDROID_PLATFORM_PATH}/android.jar" --classpath "${ANDROID_OUTPUT}/obj"

                # pack apk
                COMMAND
                $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS package -f -M "AndroidManifest.xml" -S "res"
                -A "${ANDROID_OUTPUT}/assets" -I "${ANDROID_PLATFORM_PATH}/android.jar" -F
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk ${ANDROID_OUTPUT}/bin

                COMMAND
                $ENV{BUILD_TOOLS}/aapt${BINEXE} ARGS add
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                "lib/arm64-v8a/lib${LIBNAME}.so"

                # align apk
                COMMAND
                $ENV{BUILD_TOOLS}/zipalign${BINEXE} ARGS -f 4
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.unsigned.apk
                ${ANDROID_OUTPUT}/bin/${APP_PRODUCT_NAME}.signed.apk

                # sign apk
                COMMAND
                $ENV{BUILD_TOOLS}/apksigner${BINSHELL} ARGS sign --ks
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