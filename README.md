**Use this cmake/c++ template for creating Application for desktop and android**

## Prerequisite (win/mac/linux) 
 - LLVM 19 or greater (clang++)
 - clang-format , clang-tidy , cmake-format 
 - vcpkg (catch2) 
 - cmake 3.26 or greater
 - cppcheck
 - clangd 
### Asan and UBsan are not working on windows

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
  - platform-tools should be on path

--------------------------------------------------------------------------------
*put all the assets like .wav .png ,etc ... on resources/assets* 

### for project configuration just modify cmakepreset.json or setting.cmake
### for build android (if needed:modify it) build-android.sh 
### pch(ALL) and unity-build(Release) is availble 
### use config.hh for fetching information or adding information about project (preprossors , compile-option,cmake-defines)