/*
 * Copyright (C) 2024 RealAhani - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the MIT license, which unfortunately won't be
 * written for another century.
 * You should have received a copy of the MIT license with
 * this file.
 */


namespace mloge
{
void print(std::string const & str)
{
    std::cout << str << '\n';
}

void print(std::string_view const & str)
{
    std::cout << str << '\n';
}

int myfirsttest(int id)
{
    return id;
}
}  // namespace mloge
