**Use this cmake/c++ template for creating Application for desktop and android**

## Prerequisite (win/mac/linux) 
 - LLVM 19 or greater (clang++)
 - clang-format , clang-tidy , cmake-format 
 - vcpkg (catch2) 
 - cmake 3.26 or greater
 - ninja
 - cpp-check
 - clangd 
### Sanitizers are not working properly on windows
### Dont use sanitizers with test has been enabled

## Prerequisite for Android 
 - NDK 27.2.12479018
 - SDK 34
 - Build_toold 29.0.3
 - JDK 8
 ### the android command line tool and all env variables should be set and availble on path  

 ### Env variables
  - VCPKG_ROOT
  - ANDROID_HOME
  - ANDROID_NDK_HOME
  - ANDROID_SDK_HOME
  - BUILD_TOOLS
  - JAVA_HOME
  - platform-tools dir should be availble on path

--------------------------------------------------------------------------------
*put all the assets like .wav , .png ,etc ... on resources/assets* 

### for project configuration just modify cmakepreset.json or Setting.cmake
### for build android (if needed:modify it) build-android.sh 
### pch(ALL) and unity-build(Release) is availble 
### use config.hh for fetching information or adding information about project (preprossors , compile-option,cmake-defines)
--------------------------------------------------------------------------------
### asset and resources like text files sound texture model etc ... should be placed in recources/assets/ 
### if you create new folder for each asset type you should add it to android build in BuildAPK.cmake (line 25 and 96)
## for strip out console on windows you can exec this command on msvc powershell tool
`editbin /subsystem:windows my_game.exe
`