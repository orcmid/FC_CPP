/*****************************************************************************
*---|----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*
*
* rayconfirm.c 2021-11-04 adaptation
*
*   based on core_basic_window.c from raylib/projects/scripts/
*
*   Welcome to raylib!
*
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h
*   for details)
*
*   Copyright (c) 2013-2016 Ramon Santamaria (@raysan5)
*   Adapted by orcmid on 2021-11-04 and verified with raylib 3.7.0
*
*****************************************************************************/

#include <raylib.h>

int main(void)
{
    // Initialization
    //------------------------------------------------------------------------
    int screenWidth = 800;
    int screenHeight = 450;

    InitWindow(screenWidth, screenHeight,
               "VC rayApp Confirmation");

    SetTargetFPS(60);
    //------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Draw
        //--------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(RAYWHITE);

            DrawText("GREAT!! Your Native Windows raylib setup is confirmed!",
                     190, 200, 20, BLUE);

            DrawText("Press ESC to Quit",
                     190, 400, 20, RED);

        EndDrawing();
        //--------------------------------------------------------------------
    }

    // De-Initialization
    //------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //------------------------------------------------------------------------

    return 0;
}
