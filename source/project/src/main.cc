/*
 * Copyright (C) 2024 RealAhani - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the MIT license, which unfortunately won't be
 * written for another century.
 * You should have received a copy of the MIT license with
 * this file.
 */

// #include <string>
// #include <fstream>
// #include <chrono>
// #include <mutex>
// #include <algorithm>
// #include <map>


// // box2d headers
// #include <box2d/box2d.h>
// #include <box2d/types.h>
// #include <box2d/base.h>
// #include <box2d/math_functions.h>
// #include <box2d/id.h>
// #include <box2d/collision.h>


// // raylib headers
// #include <raylib.h>
// #include <raymath.h>
// #include "config.hh"
int main([[maybe_unused]] int argc, [[maybe_unused]] char* argv[])
{
    // benchmark is activate from presets and with PROFILE or
    // PROFILE_SCOP macro`s .
    // PROFILE();
    //     using namespace std::string_literals;
    //     using namespace myproject::cmake;
    //     // __________ Project Informations __________
    // #if (MYOS == 1)                                   // OS is Windows
    //     mloge::print("WIN"s);
    // #elif (MYOS == 2)                                 // OS is GNU/Linux
    //     mloge::print("LINUX"s);
    // #elif (MYOS == 3)                                 // OS is OSX
    //     mloge::print("MAC"s);
    // #endif

    //     mloge::print(myproject::cmake::projectName);  // Project-name!
    //     mloge::print(myproject::cmake::projectVersion);  // Project-version!
    // __________ Project Informations __________

    // Raylib window init
    InitWindow(0, 0, "Test");
    ToggleFullscreen();

    // Window properties
    [[maybe_unused]]
    int const width  = {GetScreenWidth()};
    int const height = {GetScreenHeight()};
    bool      isQuit = {false};

    // Physics related values for box2d (box2d-related)
    float const squerWidth  = {50.f};
    float const squerHeight = {50.f};
    float const squerX      = {800.f};
    float const squerY      = {(height / 2.f) - 500.f};
    float const rectWidth   = {5000.f};
    float const rectHeight  = {50.f};
    float const rectX       = {0.f};
    float const rectY       = {(height / 2.f)};
    float const rectDec     = {10.f};

    // box2d init of the world of the game (box2d-related)
    b2WorldDef   worldDef = {b2DefaultWorldDef()};
    b2Vec2 const gravity  = {-5.f, -10.f};
    worldDef.gravity      = gravity;
    b2WorldId worldID     = {b2CreateWorld(&worldDef)};
    worldDef.enableSleep  = false;

    // Creatig a ground (box2d-related)
    b2BodyDef groundDef = {b2DefaultBodyDef()};
    groundDef.position  = b2Vec2 {-rectX, -rectY};
    groundDef.type      = b2_staticBody;
    groundDef.rotation  = b2MakeRot(rectDec * DEG2RAD);

    b2BodyId const groundBodyId = {b2CreateBody(worldID, &groundDef)};
    b2Polygon const groundShape = {
        b2MakeBox(rectWidth / 2.f, rectHeight / 2.f)};
    b2ShapeDef groundShapeDef = {b2DefaultShapeDef()};
    // Mass is not need for static object
    groundShapeDef.friction    = 0.3f;
    groundShapeDef.restitution = 0.7f;
    b2CreatePolygonShape(groundBodyId, &groundShapeDef, &groundShape);

    // Ground 2 (box2d-related)
    b2BodyDef groundDef2 = {b2DefaultBodyDef()};
    groundDef2.position  = b2Vec2 {-(rectX + 1400), -(rectY - 300)};
    groundDef2.type      = b2_staticBody;
    groundDef2.rotation  = b2MakeRot(75.f * DEG2RAD);

    b2BodyId const groundBodyId2 = {b2CreateBody(worldID, &groundDef2)};
    b2Polygon const groundShape2 = {
        b2MakeBox(rectWidth / 2.f, rectHeight / 2.f)};
    b2ShapeDef groundShapeDef2 = {b2DefaultShapeDef()};
    // Mass is not need for static object
    groundShapeDef2.friction    = 0.3f;
    groundShapeDef2.restitution = 0.7f;
    b2CreatePolygonShape(groundBodyId2, &groundShapeDef2, &groundShape2);

    // Create a dynamic box (box2d-related)
    b2BodyDef boxDef = {b2DefaultBodyDef()};
    boxDef.position  = b2Vec2 {-squerX, -squerY};
    boxDef.type      = b2_dynamicBody;
    boxDef.rotation  = b2MakeRot(30.f * DEG2RAD);

    b2BodyId const  boxBodyId = {b2CreateBody(worldID, &boxDef)};
    b2Polygon const boxShape  = {
        b2MakeBox(squerWidth / 2.f, squerHeight / 2.f)};
    b2ShapeDef boxShapeDef = {b2DefaultShapeDef()};
    boxShapeDef.density    = 1.f;
    boxShapeDef.friction   = 0.7f;
    b2CreatePolygonShape(boxBodyId, &boxShapeDef, &boxShape);

    // Simulating setting (box2d-related)
    SetTargetFPS(GetMonitorRefreshRate(0));
    float const  timeStep     = {1.f / 15.f};  // 60HZ
    int8_t const subStepCount = {3};


    // Main loop
    while (!WindowShouldClose() && !isQuit)
    {
        // PROFILE_SCOPE("LOOP");
        // Input managment with raylib
        if (IsKeyPressed(KEY_ESCAPE)) [[unlikely]]
        {
            isQuit = true;
        }
        // Update world state (box2d-related)
        b2World_Step(worldID, timeStep, subStepCount);

        // Rendering
        ClearBackground(BLACK);
        BeginDrawing();
        DrawFPS(0, 10);
        b2Vec2 const boxPos {b2Body_GetPosition(boxBodyId)};
        b2Vec2 const groundPos {b2Body_GetPosition(groundBodyId)};
        b2Vec2 const groundPos2 {b2Body_GetPosition(groundBodyId2)};

        // Draw a dynamic box
        DrawRectanglePro(Rectangle {.x      = -boxPos.x,
                                    .y      = -boxPos.y,
                                    .width  = squerWidth,
                                    .height = squerHeight},
                         Vector2 {.x = (squerWidth / 2.f),
                                  .y = (squerHeight / 2.f)},
                         b2Rot_GetAngle(b2Body_GetRotation(boxBodyId)) *
                             RAD2DEG,
                         RED);

        // Draw the ground as a box
        DrawRectanglePro(Rectangle {.x      = -groundPos.x,
                                    .y      = -groundPos.y,
                                    .width  = rectWidth,
                                    .height = rectHeight},
                         Vector2 {.x = (rectWidth / 2),
                                  .y = (rectHeight / 2)},
                         b2Rot_GetAngle(b2Body_GetRotation(groundBodyId)) *
                             RAD2DEG,
                         GREEN);

        // Draw the second ground
        DrawRectanglePro(Rectangle {.x      = -groundPos2.x,
                                    .y      = -groundPos2.y,
                                    .width  = rectWidth,
                                    .height = rectHeight},
                         Vector2 {.x = (rectWidth / 2),
                                  .y = (rectHeight / 2)},
                         b2Rot_GetAngle(b2Body_GetRotation(groundBodyId2)) *
                             RAD2DEG,
                         GREEN);

        EndDrawing();
    }
    // Cleaning up and bye
    b2DestroyWorld(worldID);
    worldID = b2_nullWorldId;
    CloseWindow();
    return 0;
}

// // If this is a window app and WinMain is needed
// // #include <windows.h>
// // int WINAPI WinMain(HINSTANCE hInstance,
// //                    HINSTANCE hPrevInstance,
// //                    LPSTR     lpCmdLine,
// //                    int       nCmdShow)
// // {
// //     MessageBox(nullptr, "Hello, World!", "My First WinMain", MB_OK);

// //     return 0;
// // }


// #include "raylib.h"

// //------------------------------------------------------------------------------------
// // Program main entry point
// //------------------------------------------------------------------------------------
// int main([[maybe_unused]] int argc, [[maybe_unused]] char* argv[])
// {
//     // Initialization
//     //--------------------------------------------------------------------------------------
//     int const screenWidth  = 800;
//     int const screenHeight = 450;

//     InitWindow(screenWidth,
//                screenHeight,
//                "raylib [core] example - keyboard input");

//     Vector2 ballPosition = {screenWidth / 2.f, screenHeight / 2.f};

//     SetTargetFPS(60);  // Set our game to run at 60 frames-per-second
//     //--------------------------------------------------------------------------------------

//     // Main game loop
//     while (!WindowShouldClose())  // Detect window close button or ESC key
//     {
//         // Update
//         //----------------------------------------------------------------------------------
//         if (IsKeyDown(KEY_RIGHT))
//             ballPosition.x += 2.0f;
//         if (IsKeyDown(KEY_LEFT))
//             ballPosition.x -= 2.0f;
//         if (IsKeyDown(KEY_UP))
//             ballPosition.y -= 2.0f;
//         if (IsKeyDown(KEY_DOWN))
//             ballPosition.y += 2.0f;
//         //----------------------------------------------------------------------------------

//         // Draw
//         //----------------------------------------------------------------------------------
//         BeginDrawing();

//         ClearBackground(RAYWHITE);

//         DrawText("move the ball with arrow keys", 10, 10, 20, DARKGRAY);

//         DrawCircleV(ballPosition, 50, MAROON);

//         EndDrawing();
//         //----------------------------------------------------------------------------------
//     }

//     // De-Initialization
//     //--------------------------------------------------------------------------------------
//     CloseWindow();  // Close window and OpenGL context
//     //--------------------------------------------------------------------------------------

//     return 0;
// }