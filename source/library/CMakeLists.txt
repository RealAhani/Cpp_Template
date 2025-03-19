# ## Library
include(${CMAKE_HOME_DIRECTORY}/cmake/Setting.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/StaticAnalyzer.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/Sanitizer.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/LibsConfig.cmake)

# -------------------- source that compile
file(GLOB lib_src_files "${CMAKE_CURRENT_LIST_DIR}/src/*.cpp" "${CMAKE_CURRENT_LIST_DIR}/src/*.cc")
set(mysrc_lib ${lib_src_files})

# -------------------- source that compile
add_library(${P_LIB_NAME} ${P_INTERNAL_LIB_TYPE} ${mysrc_lib})
configure_file("${CMAKE_SOURCE_DIR}/source/setup/config/config.hh.in" "${CMAKE_CURRENT_BINARY_DIR}/generate/config.hh")
target_include_directories(
  ${P_LIB_NAME}
  PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/generate"
  PUBLIC "./include"
  PUBLIC "${CMAKE_SOURCE_DIR}/source/setup/pch"
)

# find_package(SFML COMPONENTS system window graphics CONFIG REQUIRED)
# find_package(box2d CONFIG REQUIRED)
# find_package(raylib CONFIG REQUIRED)
fetch_repositories(${P_LIB_NAME})

if(HAS_PCH)
  target_precompile_headers(${P_LIB_NAME} PUBLIC "${CMAKE_SOURCE_DIR}/source/setup/pch/pch.hh")
endif(HAS_PCH)

# Benchmark enable
if(HAS_BENCHMARK)
  target_link_libraries(${P_LIB_NAME} PUBLIC P_BENCHMARK PRIVATE ${LINK_VARS})

# Benchmark disable
else()
  target_link_libraries(${P_LIB_NAME} PRIVATE ${LINK_VARS})
endif(HAS_BENCHMARK)

if(HAS_UNITY_BUILD)
  set_target_properties(${P_LIB_NAME} PROPERTIES UNITY_BUILD ON)
endif(HAS_UNITY_BUILD)

target_compile_options(${P_LIB_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${CUSTOME_FLAGS}>)

# enable static analyzer
setting_enable_staticanalyzer(${P_LIB_NAME})
setting_enable_sanitizer(${P_LIB_NAME})

if(HAS_PACKAGE)
  include(GNUInstallDirs)
  install(TARGETS ${P_LIB_NAME} LIBRARY DESTINATION lib ARCHIVE DESTINATION lib/${P_LIB_TYPE})
endif(HAS_PACKAGE)
