# ## BenchMark
include(${CMAKE_HOME_DIRECTORY}/cmake/Setting.cmake)

if(HAS_BENCHMARK)
    # if You want u can change it to SHARED
    add_library(P_BENCHMARK INTERFACE)

    target_include_directories(P_BENCHMARK INTERFACE "${CMAKE_CURRENT_LIST_DIR}/include")

    if(HAS_UNITY_BUILD)
        set_target_properties(P_BENCHMARK PROPERTIES UNITY_BUILD ON)
    endif(HAS_UNITY_BUILD)

    target_compile_options(P_BENCHMARK INTERFACE $<$<COMPILE_LANGUAGE:CXX>:${CUSTOME_FLAGS}>)

    if(HAS_UNITY_BUILD AND HAS_PACKAGE)
        install(DIRECTORY include/ DESTINATION include/Benchmark)
    endif(HAS_UNITY_BUILD AND HAS_PACKAGE)
endif(HAS_BENCHMARK)