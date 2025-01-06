# ## TEST
include(${CMAKE_SOURCE_DIR}/cmake/Setting.cmake)

# -------------------- source that compile
file(GLOB test_src_files "${CMAKE_CURRENT_LIST_DIR}/src/*.cpp" "${CMAKE_CURRENT_LIST_DIR}/src/*.cc")
set(mysrc_test ${test_src_files})

# -------------------- source that compile
if(PROJECT_IS_TOP_LEVEL AND HAS_TEST)
  find_package(Catch2 CONFIG REQUIRED)
  add_executable(${P_TEST_NAME} ${mysrc_test})
  target_compile_options(${P_TEST_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${CUSTOME_FLAGS}>)

  # target_include_directories(
  # ${P_TEST_NAME} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/generate" PRIVATE "../source/library/include" PRIVATE "../source/project/include"
  # )
  if(HAS_LIB)
    target_link_libraries(${P_TEST_NAME} PRIVATE Catch2::Catch2WithMain ${LINK_VARS} ${P_LIB_NAME})
  else()
    target_link_libraries(${P_TEST_NAME} PRIVATE Catch2::Catch2WithMain ${LINK_VARS})
  endif(HAS_LIB)

  fetch_repositories(${P_TEST_NAME})
  include(CTest)
  include(Catch)
  catch_discover_tests(${P_TEST_NAME})

  if(HAS_PACKAGE)
    # Set package types (e.g., ZIP,External ,WIX (msiinstaller),IFW(qtinstaller),INNOSETUP,NSIS,NSIS64 ,Nuget TBZ2, TGZ, TXZ ,TZ , DEB, RPM, NSIS, etc.)
    install(TARGETS ${P_TEST_NAME} RUNTIME DESTINATION bin)
  endif()
endif()