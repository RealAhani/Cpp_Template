# ## ROOT
# TODO add RelWithDebugInfo
message("--------------------------------------------- General info:")
include(${CMAKE_SOURCE_DIR}/cmake/Setting.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/BuildAPK.cmake)

# compiler should be clang++
set(CMAKE_CXX_COMPILER ${P_CXX_COMPILER})
set(CMAKE_C_COMPILER clang)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# debug mode
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  list(APPEND DBG_FLAGS "-g")
  list(APPEND DBG_FLAGS "-fno-limit-debug-info")
  message("============================================= Debuging is ON ")
  set(CUSTOME_FLAGS ${DBG_FLAGS})

# release mode
else()
  message("============================================= Debuging is OFF (Release Mode with Optimization) ")
  set(CUSTOME_FLAGS ${REL_FLAGS})
endif()

# find and config ccache
find_program(CCACHE_FOUND ccache)

if(CCACHE_FOUND)
  set(CMAKE_CXX_COMPILER_LAUNCHER ccache CACHE STRING "C++ compiler launcher")
  set(CMAKE_C_COMPILER_LAUNCHER ccache CACHE STRING "C compiler launcher")
  message("--------------------------------------------- CCACHE: ON ")
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
endif()

cmake_minimum_required(VERSION 3.25...3.31)

project(${P_NAME} VERSION ${P_VERSION})
set(CMAKE_CXX_STANDARD ${P_CXX_VERSION})
set(CMAKE_C_STANDARD ${P_C_VERSION})
set(CMAKE_CXX_STANDARD_REQUIRED ${P_CXX_STANDARD})
set(CMAKE_CXX_EXTENSIONS ${P_CXX_EXTENTION})

if(WIN32)
  message("============================================ OPERATING SYS :WINDOWS ")
  set(CURRENTOS 1 CACHE STRING "OS TYPE ")
elseif(LINUX)
  message("============================================ OPERATING SYS :Linux ")
  set(CURRENTOS 2 CACHE STRING "OS TYPE ")
elseif(UNIX)
  message("============================================ OPERATING SYS :UNIX ")
  set(CURRENTOS 3 CACHE STRING "OS TYPE ")
endif()

# define the architecture type
set(BUILD_ARCH "" CACHE STRING "os architecture type")

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(BUILD_ARCH "x64")
  message("--------------------------------------------- Arch: ${BUILD_ARCH} ")
else()
  set(BUILD_ARCH "x86")
  message("--------------------------------------------- Arch: ${BUILD_ARCH} ")
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
  "$<0:>${CMAKE_BINARY_DIR}/out/${BUILD_ARCH}_${CMAKE_BUILD_TYPE}/${PRESET_NAME}/bin"
) # .exe and .dll
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY
  "$<0:>${CMAKE_BINARY_DIR}/out/${BUILD_ARCH}_${CMAKE_BUILD_TYPE}/${PRESET_NAME}/lib"
) # .so and .dylib
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY
  "$<0:>${CMAKE_BINARY_DIR}/out/${BUILD_ARCH}_${CMAKE_BUILD_TYPE}/${PRESET_NAME}/lib"
) # .lib and .a

message("--------------------------------------------- C++ COMPILER ID: ${CMAKE_CXX_COMPILER_ID} ")
message("--------------------------------------------- C++ COMPILER: ${CMAKE_CXX_COMPILER} ")
message("--------------------------------------------- C COMPILER: ${CMAKE_C_COMPILER} ")
message("--------------------------------------------- BUILD TYPE: ${CMAKE_BUILD_TYPE}  ")
message("--------------------------------------------- UNITY BUILD: ${HAS_UNITY_BUILD} ")
message("--------------------------------------------- Compiler Flags: ${CUSTOME_FLAGS} ")
message("--------------------------------------------- CXX Version: ${P_CXX_VERSION} ")
message("--------------------------------------------- C Version: ${P_C_VERSION} ")
message("--------------------------------------------- Sulotion name : ${P_NAME} ")

if(HAS_LIB)
  message("--------------------------------------------- Library name : ${P_LIB_NAME} ")
endif(HAS_LIB)

message("--------------------------------------------- Exe name : ${P_OUT_NAME} ")
message("--------------------------------------------- Version: ${P_VERSION} ")

if(NOT BUILD_APK)
  if(HAS_PCH)
    add_subdirectory("./source/setup")
  endif(HAS_PCH)

  if(HAS_LIB)
    add_subdirectory("./source/library")
  endif()

  if(NOT HAS_TEST)
    add_subdirectory("./source/project")
  endif(NOT HAS_TEST)

  if(HAS_BENCHMARK)
    add_subdirectory("./source/benchmark")
  endif(HAS_BENCHMARK)
else()
  BuildAPK(${P_NAME})
endif(NOT BUILD_APK)

message("--------------------------------------------- Benchmarking : ${HAS_BENCHMARK}")

# Don't even look at tests if we're not top level
if(NOT PROJECT_IS_TOP_LEVEL)
  return()
endif()

# Adding the tests:
if(HAS_TEST)
  message("============================================ TESTING IS ON")
  enable_testing()
  list(APPEND CMAKE_MODULE_PATH ${catch2_SOURCE_DIR}/extras)
  add_subdirectory("test")
endif(HAS_TEST)

if(HAS_PACKAGE)
  # Set package types (e.g., ZIP,External ,WIX (msiinstaller),IFW(qtinstaller),INNOSETUP,NSIS,NSIS64 ,Nuget TBZ2, TGZ, TXZ ,TZ , DEB, RPM, NSIS, etc.)
  if(WIN32)
    set(CPACK_GENERATOR "ZIP;WIX;" CACHE STRING "" FORCE)
  else()
    set(CPACK_GENERATOR "ZIP;DEB;" CACHE STRING "" FORCE)
  endif()

  message("============================================ PACKAGING")
  set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
  set(CPACK_PACKAGE_VERSION ${P_VERSION})
  set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${DISCRIPTION})
  set(CPACK_PACKAGE_VENDOR ${VENDOR})
  set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Your Name")
  set(CPACK_PACKAGE_CONTACT ${SUPPORTMAIL})
  set(CPACK_PACKAGE_INSTALL_DIRECTORY ${P_NAME})

  # Set architecture (e.g., amd64, i386, etc.)
  set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE ${CMAKE_SYSTEM_PROCESSOR})

  # Set installation prefix (this will be /usr/local by default)
  set(CPACK_PACKAGING_INSTALL_PREFIX "/out")

  # Specify additional files to include in the package
  install(FILES README.md DESTINATION .)

  if(WIN32)
    # Additional settings (Optional)
    set(CPACK_WIX_PRODUCT_GUID "12345678-1234-1234-1234-1234567890AB")

    # Optional: Unique GUID for the installer
    set(CPACK_WIX_UPGRADE_GUID "12345678-1234-1234-1234-1234567890AC")

    # Optional: Upgrade GUID for future versions
    set(CPACK_WIX_LICENSE_RTF "${CMAKE_SOURCE_DIR}/LICENSE")
  endif()

  include(CPack)
endif()

# copying compile_commands.json to root of the build dir for clangd intellisence
# Specify the source and destination paths
set(SOURCE_FILE "${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/Desktop/compile_commands.json")

# if(NOT EXISTS ${SOURCE_FILE})
# set(SOURCE_FILE "${CMAKE_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/Other/compile_commands.json")
# endif(NOT EXISTS ${SOURCE_FILE})
set(DESTINATION_DIR "${CMAKE_SOURCE_DIR}/build")
set(TARGET_FILE "${DESTINATION_DIR}/compile_commands.json")

# Add a post-build custom target to copy the file
add_custom_command(
  OUTPUT "${TARGET_FILE}"
  COMMAND ${CMAKE_COMMAND} -E copy_if_different "${SOURCE_FILE}" "${TARGET_FILE}"
  DEPENDS "${SOURCE_FILE}" # Ensure the command runs only after the file exists
  COMMENT "Copying compile_commands.json to ${DESTINATION_DIR}"
)

add_custom_target(copy_compile_commands ALL DEPENDS "${TARGET_FILE}")

# copy assets to bin folder for not android devices (Desktopes)
if(NOT ${PLATFORM} STREQUAL "Android")
  set(ASSETS "${CMAKE_SOURCE_DIR}/resources/assets")
  add_custom_target(copy_assets ALL COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${ASSETS}
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    COMMENT "Copying assets to bin directory")
endif(NOT ${PLATFORM} STREQUAL "Android")
