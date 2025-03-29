# ## Settings
include_guard()

# ################### Naming Conventions of project
# project name
set(P_NAME "NAME" CACHE STRING "project name" FORCE)

# output name
set(P_OUT_NAME "main" CACHE STRING "exe or lib name" FORCE)

# internal library name
set(P_LIB_NAME "main2" CACHE STRING "internal lib name" FORCE)

# test name
set(P_TEST_NAME "${P_NAME}_test" CACHE STRING "test name" FORCE)

# ################### Versioning
set(PRVERSION_MAJOR "0" CACHE STRING "" FORCE)
set(PRVERSION_MINOR "0" CACHE STRING "" FORCE)
set(PRVERSION_PATCH "1" CACHE STRING "" FORCE)

# projcet version
set(P_VERSION "${PRVERSION_MAJOR}.${PRVERSION_MINOR}.${PRVERSION_PATCH}" CACHE STRING "project version" FORCE)

# c++ version
set(P_CXX_VERSION 20 CACHE STRING "c++ version")

# c version
set(P_C_VERSION 11 CACHE STRING "c version")

# ################### Compiler detail
# compiler name
set(P_CXX_COMPILER "clang++" CACHE STRING "c++ compiler name" FORCE)

# c++ Extention option
option(P_CXX_EXTENTION ON "c++ extentions")

# c++ Standard option
option(P_CXX_STANDARD ON "c++ standard")

# ################### Flags
# debug flags
option(WERROR_FLAG OFF "Warning as error on/off")

# -Wall
# -Wextra # reasonable and standard
# -Wshadow # warn the user if a variable declaration shadows one from a parent context
# -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps catch hard to track down memory errors
# -Wcast-align # warn for potential performance problem casts
# -Wunused # warn on anything being unused
# -Woverloaded-virtual # warn if you overload (not override) a virtual function
# -Wconversion # warn on type conversions that may lose data
# -Wsign-conversion # warn on sign conversions
# -Wdouble-promotion # warn if float is implicit promoted to double
# -Wformat=2 # warn on security issues around functions that format output (ie printf)
# -Wimplicit-fallthrough # warn when a missing break causes control flow to continue at the next case in a switch statement
# -Wsuggest-override # warn when 'override' could be used on a member function overriding a virtual function
# -Wnull-dereference # warn if a null dereference is detected
# -Wold-style-cast # warn for c-style casts
# -Wpedantic # warn if non-standard C++ is used
# ${OS_ANDROID}:-Wno-main
set(DBG_FLAGS "-DDEBUG;-Wall;-Wextra;-Wpedantic;-Wshadow;-Wconversion;-Wnon-virtual-dtor;-Wcast-align;-Wunused;-Woverloaded-virtual;-Wsign-conversion;-Wdouble-promotion;-Wformat=2;-Wimplicit-fallthrough;-Wsuggest-override;-Wnull-dereference;-Wold-style-cast;-Wpedantic"
  CACHE STRING "debug flags")

# if werror is on add it to debug flags
if(WERROR_FLAG)
  list(APPEND DBG_FLAGS "-Werror")
endif(WERROR_FLAG)

# release flags
# -march=native -flto -fPIC
set(REL_FLAGS "-O3;-DNDEBUG;-ftree-vectorize"
  CACHE STRING "release flags")

# sanitizer flags
# "-address,-undefined,-memory,-pointer-compare,-pointer-subtract;"
# ## should be something like this ==> set(SAN_FLAGS "address,undefined,memory,pointer-compare,pointer-subtract" CACHE STRING "sanitizer flags" FORCE)
set(SAN_FLAGS "address,undefined"
  CACHE STRING "sanitizer flags")

# sanitizer option
option(HAS_SAN ON "sanitizer can enabled/disabled")

# ################### static_analyzer
option(HAS_STATIC_ANALYZER ON "static_analyzer can enabled/disabled")

# ################### Project config
# the output type of the project can be exe or lib
option(HAS_EXE ON "project is an exe type")
option(HAS_CONSOLE ON "exe run with window and console at the same time")

# the output of project is a library if has_exe is off
if(NOT HAS_EXE)
  set(P_LIB_TYPE "SHARED" CACHE STRING "project library type (STATIC/SHARED)")
endif(NOT HAS_EXE)

# ################### Testing and Benchmark
option(HAS_TEST ON "testing can enabled/disabled")

# Benchmarking config should be (1 or 0)
option(HAS_BENCHMARK ON "banchmarking can enabled/disabled")

# ################### Build Config
option(HAS_PCH ON "pre compiled header option for increase build speed")
option(HAS_UNITY_BUILD OFF "unity build should just enabled in release mode")

# ################### Internal Library
option(HAS_LIB ON "internal library can enabled/disabled")

# internal lib type
set(P_INTERNAL_LIB_TYPE "STATIC" CACHE STRING "internal library type (STATIC/SHARED)")
# External fetched libs type
set(P_EXTERNAL_LIBS_TYPE "STATIC" CACHE STRING "Fetched librareis type (STATIC/SHARED)")

# ################### ThirdParty Dependencies or Fetch Libraries from github (External Libraries)
# URLS          = [raylib git url;box2d git url]
# TAGS          = [raylib git tag;box2d git tag] e.g (version or master/main or comit hash)
# LINKING_VARS  = [raylib;box2d]
set(URLS "https://github.com/raysan5/raylib.git;https://github.com/erincatto/box2d.git" CACHE STRING "repositories usrls")
set(TAGS "5.5;28adacf82377d4113f2ed00586141463244b9d10" CACHE STRING "Tag that you want to fetch or branch name")
set(LINK_VARS "raylib;box2d" CACHE STRING "the library linking variables")

if(${PLATFORM} STREQUAL "Android")
  list(APPEND LINK_VARS "native_app_glue;log;android;EGL;GLESV2;OpenSLES")
endif(${PLATFORM} STREQUAL "Android")

# ################### Packaging for release
option(HAS_PACKAGE OFF "packaging for release")
set(DISCRIPTION "MyProject - A brief description" CACHE STRING "")
set(VENDOR "YOUR COMPANY" CACHE STRING "")
set(SUPPORTMAIL "support@mycompany.com" CACHE STRING "")

# ################### Android config
set(LIBNAME "${P_OUT_NAME}")
set(ANDROID_OUTPUT "${CMAKE_BINARY_DIR}/../App")
set(APP_LABEL "Raylib" CACHE STRING "")
set(APP_COMPANY_NAME "Nullref" CACHE STRING "")
set(APP_PRODUCT_NAME "game" CACHE STRING "")
set(APP_PACKAGE "com.${APP_COMPANY_NAME}.${APP_PRODUCT_NAME}" CACHE STRING "")
set(APP_VERSION_CODE "1")
set(APP_VERSION_NAME "${P_VERSION}")
set(APP_ORIENTATION "landscape" CACHE STRING "")
set(APP_KEYSTORE_PASS "password" CACHE STRING "")
set(JAVA_HOME "$ENV{JAVA_HOME}")
set(ANDROID_PLATFORM "34")
set(ANDROID_ABI "arm64-v8a")
set(ANDROID_NDK "$ENV{ANDROID_NDK_HOME}")
set(ANDROID_PLATFORM_PATH "$ENV{ANDROID_SDK_HOME}")
set(CMAKE_ANDROID_STL_TYPE c++_static)
option(BUILD_APK OFF "first build all android targets then set this to ON for build .apk")