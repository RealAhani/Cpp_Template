/*
 * Copyright (C) 2024 RealAhani - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the MIT license, which unfortunately won't be
 * written for another century.
 * You should have received a copy of the MIT license with
 * this file.
 */

// First set Benchmark to 1 in cmake-preset (release or debug or safe)
// After finishing the execution of program you have a .json file in
// out/{ARCH}/bin Load this file with chrome://tracing

// Benchmark is ON
#if (PROFILER == 1)
// Profile the current function
#define PROFILE() BENCHMARK(__FUNCTION__)
// Profile the current scoop use this macro inside { }
// e.g: {PROFILE_SCOPE(YOUR-NAME);}
#define PROFILE_SCOPE(NAME) BENCHMARK(NAME)
// DONT USE THIS MACRO JUST USE PROFILE and PROFILE_SCOPE
#define BENCHMARK(NAME) Profiler::BenchMark profile##__LINE__(NAME);
#else  // Benchmark is OFF replace all above macro with ;
#define PROFILE()           ;
#define PROFILE_SCOPE(NAME) ;
#endif