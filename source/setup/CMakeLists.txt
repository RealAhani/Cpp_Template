### Setup
if(HAS_PCH)
include_directories(PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/generate" PUBLIC "${CMAKE_SOURCE_DIR}/source/library/include" PUBLIC "${CMAKE_SOURCE_DIR}/source/project/include" PUBLIC "${CMAKE_SOURCE_DIR}/source/benchmark/include")
endif(HAS_PCH)