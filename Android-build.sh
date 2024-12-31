#!/bin/bash
### use it like this bash ./Android-build.sh Release or ./Android-build.sh Debug 

# Check if an argument is passed
if [ -z "$1" ]; then
    echo "Error: No argument provided. pass Release or Debug"
    exit 1
fi

#  allways first build the desktop version for creating compile_commands.json
# Check the argument
if [ "$1" == "Release" ]; then
    echo "Release Build"
    cmake --preset "arm64-v8a" -DCMAKE_BUILD_TYPE=Release
    cmake --build --preset "arm64-v8a" --config Release

    cmake --preset "armeabi-v7a" -DCMAKE_BUILD_TYPE=Release
    cmake --build --preset "armeabi-v7a" --config Release

    cmake --preset "x86_64" -DCMAKE_BUILD_TYPE=Release
    cmake --build --preset "x86_64" --config Release

    cmake --preset "x86" -DCMAKE_BUILD_TYPE=Release
    cmake --build --preset "x86" --config Release

    cmake --preset "Build-App" -DCMAKE_BUILD_TYPE=Release
    cmake --build --preset "Build-App" --config Release

    rm -rf ./build/Darwin/Other/Android/Build-App

    adb uninstall com.Nullref.app
    adb install -r ./build/Darwin/Other/Android/App/bin/app.final.apk
elif [ "$1" == "Debug" ]; then
    echo "Debug Build"
    cmake --preset "arm64-v8a" -DCMAKE_BUILD_TYPE=Debug
    cmake --build --preset "arm64-v8a" --config Debug

    cmake --preset "Build-App" -DCMAKE_BUILD_TYPE=Debug
    cmake --build --preset "Build-App" --config Debug

    adb uninstall com.Nullref.app
    adb install -r ./build/Darwin/Other/Android/App/bin/app.final.apk
else
    echo "Error: Unknown argument. Debug or Release"
    exit 1
fi