# ## Project
include(${CMAKE_SOURCE_DIR}/cmake/Setting.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/StaticAnalyzer.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/Sanitizer.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/LibsConfig.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/Android.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/BuildAPK.cmake)

# -------------------- source that compile
file(GLOB p_src_files "${CMAKE_CURRENT_LIST_DIR}/src/*.cpp" "${CMAKE_CURRENT_LIST_DIR}/src/*.cc")
set(mysrc_exe ${p_src_files})

# -------------------- source that compile
if(HAS_EXE)
  # target is desktop app with console debuger
  if(HAS_CONSOLE)
    add_executable(${P_OUT_NAME} ${mysrc_exe})

  # its Desktop without console
  else()
    add_executable(${P_OUT_NAME} WIN32 ${mysrc_exe})
  endif(HAS_CONSOLE)

# other target: target is Android
else()
  add_library(${P_OUT_NAME} ${P_LIB_TYPE} ${mysrc_exe})
  AndroidSetup(${P_OUT_NAME})
endif(HAS_EXE)

if(HAS_LIB)
  # PCH
  if(HAS_PCH)
    target_precompile_headers(${P_OUT_NAME} REUSE_FROM ${P_LIB_NAME})
  endif(HAS_PCH)

  # BenchMark
  if(HAS_BENCHMARK)
    target_link_libraries(${P_OUT_NAME} PRIVATE ${P_LIB_NAME} P_BENCHMARK ${LINK_VARS})
  else()
    target_link_libraries(${P_OUT_NAME} PRIVATE ${P_LIB_NAME} ${LINK_VARS})
  endif(HAS_BENCHMARK)

# not use internal lib
else()
  # config.hh add to project
  configure_file("${CMAKE_SOURCE_DIR}/source/setup/config/config.hh.in" "${CMAKE_CURRENT_BINARY_DIR}/generate/config.hh")
  fetch_repositories(${P_OUT_NAME})

  # PCH
  if(HAS_PCH)
    target_include_directories(${P_OUT_NAME} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/generate" PUBLIC "${CMAKE_SOURCE_DIR}/source/setup/pch")
    target_precompile_headers(${P_OUT_NAME} PUBLIC "${CMAKE_SOURCE_DIR}/source/setup/pch/pch.hh")
  endif(HAS_PCH)

  # BenchMark
  if(HAS_BENCHMARK)
    target_link_libraries(${P_OUT_NAME} PRIVATE P_BENCHMARK ${LINK_VARS})
  else()
    target_link_libraries(${P_OUT_NAME} PRIVATE ${LINK_VARS})
  endif(HAS_BENCHMARK)
endif(HAS_LIB)

# Unity build
if(HAS_UNITY_BUILD)
  set_target_properties(${P_OUT_NAME} PROPERTIES UNITY_BUILD ON)
endif(HAS_UNITY_BUILD)

target_include_directories(${P_OUT_NAME} PUBLIC "./include")
target_compile_options(${P_OUT_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${CUSTOME_FLAGS}>)

# enable static analyzer
setting_enable_staticanalyzer(${P_OUT_NAME})
setting_enable_sanitizer(${P_OUT_NAME})

if(HAS_PACKAGE)
  install(TARGETS ${P_OUT_NAME} RUNTIME DESTINATION bin)
endif(HAS_PACKAGE)
