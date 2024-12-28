/*
 * Copyright (C) 2024 RealAhani - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the MIT license, which unfortunately won't be
 * written for another century.
 * You should have received a copy of the MIT license with
 * this file.
 */

#include "Log.hh"
#include <catch2/catch_test_macros.hpp>


TEST_CASE("first test", "[myfirsttest]")
{
    REQUIRE(mloge::myfirsttest(0) == 0);
    REQUIRE(mloge::myfirsttest(1) == 1);
    REQUIRE(mloge::myfirsttest(2) == 2);
    REQUIRE(mloge::myfirsttest(3) == 3);
    REQUIRE(mloge::myfirsttest(10) == 10);
}