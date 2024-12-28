/*
 * Copyright (C) 2024 RealAhani - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the MIT license, which unfortunately won't be
 * written for another century.
 * You should have received a copy of the MIT license with
 * this file.
 */

// Dont include this file seperatedly
// pch and unity build supported in default of this project
#ifndef PCH_HH  // PCH_HH
#define PCH_HH

// box2d headers
#include <box2d/box2d.h>
#include <box2d/types.h>
#include <box2d/base.h>
#include <box2d/math_functions.h>
#include <box2d/id.h>
#include <box2d/collision.h>

// raylib headers
#include <raylib.h>
#include <raymath.h>

// C++ headers
#include <iostream>
#include <string>
#include <string_view>
#include <fstream>
#include <chrono>
#include <mutex>
#include <algorithm>
#include <map>
#include <thread>

// Project generated header for config macro nad variables
#include "config.hh"

#if PROFILING == 1
#include "Benchmark.hh"
#include "Profiler.hh"
#endif

// include your internall headers hear
#if INERNAL_LIB == 1
#include "Log.hh"
#endif

#endif  // PCH_HH