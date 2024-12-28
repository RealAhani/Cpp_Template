# A Template to start a Cmake/C++ project with using libraries

# Windows and linux/unix-likes are now supported
# pre requresit app , pakages , Dependencies
### cmake ,Ninja ,ccache ,clang-tidy ,cppcheck ,cpplint ,iwyu ,clang-format ,cmake-format ,vcpkg ,and a compiler like clang++ or cl are should be installed and added to your system path enviroment

### for compiling for android you need NDK / SDK / JDK

## this template support clang++ and c++23 so use llvm-18 or above
clang is prefered and work with vs code
msvc generation project is work but for build the codes you should build within the Vs 22 IDE

## config the project just with config.cmake and cmakepresets.json 
## if you want to use any open source library as dependencies you can add it to the vcpkg.json or via config.cmake variables fetch the github repositories

    for config.cmake
    (1. add git repo links to REP_URLS)
    (2. add git branch that you want to REP_BRANCH the order of indexes are important)
    (3. add the library linkage name to LIB_LINKAGE_VAR for linking to your exe)

### 1.Edit config.cmake for (Naming Convention , Project Setting , Versioning , Compiler Flag , C++ Standard , and more ... )

### 2.A write your translation units in relevent src directory ( as .cc or .cpp)
### 2.B write your header in (.hh or .hpp )

### 3.if you dont want to use cmake presets you can use build.bat (but cmake prests are preferred)

      (in Safe build (Safe-Debug) all warings,sanitizer,static analyzes( cppcheck, clang-tidy , cpplint ) are enabled for each compiler defienitions)
      (for Release build warning are turn off and optimizations for compile and lto(not supported on unix/linux) are enabled)
      (Static Analyzers and sanitizer are do increase the build time (not work smoothly on msvc) ... and have some runtime overhead )
### 4.if you want to use test with catch2 set the preset to warning mode
        (for some reason safe mode and test does not work at the same time)
        (sanitizer link in runtime with shared lib so edit the path to the lib in config.cmake and edit the name of the lib in sanitizer.cmake if you dont use windows)
#### sample folder is for your application.exe that means all srcs and includes in that folder are for .exe
#### library folder is for your Name.lib that means all srcs and includes in that folder are for *.lib 
    (you can chose between static and shared lib and nolib at all)
    (or turn off the whole library folder effect within config.cmake (INTERNAL_MYLIB_USAGE OFF) or use preset Nolib)
#### you can write all the headers you want to precompile in pch.hh in library/include/pch
    ( the template use PCH and unitybuild together for decreasing compile tim )
    ( also the multi-threaded compile translation unit are enabled by default )
#### for profiling the code you can use the header-only lib Benchmark i added in source directory
    ( turn it on or off in each build mode you want )
    ( load the benchmark.json file in chrome://tracing in chrome browser and visulising the timing )
