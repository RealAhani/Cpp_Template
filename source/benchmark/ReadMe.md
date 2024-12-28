Copyright (C) 2024 RealAhani - All Rights Reserved
You may use, distribute and modify this code under the
terms of the MIT license, which unfortunately won't be
written for another century.
You should have received a copy of the MIT license with
this file.
 

Benchmark.hh header is a header only lib ,so this is link and use through the pch 

Profiler.hh is a header for the purpose to turn on or off the profiling
this is set through HAS_BENCHMARK in cmake-preset and in config.hh
and activate with PROFILING macro in config.hh
this Profiler.hh is included in config.h

the output file should be on out/bin but maybe created in root of the project directory