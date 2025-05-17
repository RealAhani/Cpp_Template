@REM  Check if an argument is passed
@echo off
setlocal

@REM Check if parameter is passed
if "%~1"=="" (
    echo [ERROR] You must specify a build configuration: Debug or Release.
    exit /b 1
)

set "config=%~1"

@REM Handle logic based on value
@REM   allways first build the desktop version for creating compile_commands.json
@REM  Check the argument
if /i "%config%"=="Release" (
    echo You selected RELEASE configuration.
    echo Building in Release mode...
    rm -rf ./build/Windows/Other/Android/*
    cmake --preset "arm64-v8a" -DCMAKE_BUILD_TYPE=Release
    cmake --build --preset "arm64-v8a" --config Release

    cmake --preset "armeabi-v7a" -DCMAKE_BUILD_TYPE=Release
    cmake --build --preset "armeabi-v7a" --config Release

    @REM  cmake --preset "x86_64" -DCMAKE_BUILD_TYPE=Release
    @REM  cmake --build --preset "x86_64" --config Release

    @REM  cmake --preset "x86" -DCMAKE_BUILD_TYPE=Release
    @REM  cmake --build --preset "x86" --config Release

    cmake --preset "Build-App" -DCMAKE_BUILD_TYPE=Release
    cmake --build --preset "Build-App" --config Release

    rm -rf ./build/Windows/Other/Android/Build-App

    adb uninstall com.RealAhani.app
    adb install -r ./build/Windows/Other/Android/App/bin/app.final.apk
) else if /i "%config%"=="Debug" (
    echo You selected DEBUG configuration.
    echo Building in Debug mode...
    rm -rf ./build/Windows/Other/Android/*
    cmake --preset "arm64-v8a" -DCMAKE_BUILD_TYPE=Debug
    cmake --build --preset "arm64-v8a" --config Debug

    cmake --preset "Build-App" -DCMAKE_BUILD_TYPE=Debug
    cmake --build --preset "Build-App" --config Debug

    adb uninstall com.RealAhani.app
    adb install -r ./build/Windows/Other/Android/App/bin/app.final.apk 
) else (
    echo [ERROR] Invalid configuration: "%config%". Use Debug or Release.
    exit /b 1
)

endlocal
