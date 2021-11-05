@echo off
REM Change your executable name here
set GAME_NAME=rayConfirm.exe

REM Set your sources here (relative paths!)
REM Example with two source folders:
REM set SOURCES=src\*.c src\submodule\*.c
set SOURCES=rayConfirm.c

REM Set your raylib\src location here (relative path!)
set RAYLIB_SRC=..\raylib\src

REM Checks if cl is available and builds
WHERE cl >nul 2>nul
IF %ERRORLEVEL% == 0 goto BUILD
echo "Developer Command-line environment must be set first."
exit /B

:BUILD
REM For the ! variable notation
setlocal EnableDelayedExpansion
REM For shifting, which the command line argument parsing needs
setlocal EnableExtensions

set BUILD_ALL=1
set VERBOSE=1

REM Directories
set "ROOT_DIR=%CD%"
set "SOURCES=!ROOT_DIR!\!SOURCES!"
set "RAYLIB_SRC=!ROOT_DIR!\!RAYLIB_SRC!"

REM Flags
set OUTPUT_FLAG=/Fe: "!GAME_NAME!"
set COMPILATION_FLAGS=/O1 /GL
set WARNING_FLAGS=
set SUBSYSTEM_FLAGS=/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup
set LINK_FLAGS=/link /LTCG kernel32.lib user32.lib shell32.lib winmm.lib gdi32.lib opengl32.lib
set OUTPUT_DIR=app

REM Display what we're doing
echo COMPILE-INFO: Compiling in release mode, flags: !COMPILATION_FLAGS! /link /LTCG

REM Create the cache directory for raylib
set TEMP_DIR=cache

cd !TEMP_DIR!
REM Raylib's src folder
set "RAYLIB_DEFINES=/D_DEFAULT_SOURCE /DPLATFORM_DESKTOP /DGRAPHICS_API_OPENGL_33"
set RAYLIB_C_FILES="!RAYLIB_SRC!\core.c" "!RAYLIB_SRC!\shapes.c" "!RAYLIB_SRC!\textures.c" "!RAYLIB_SRC!\text.c" "!RAYLIB_SRC!\models.c" "!RAYLIB_SRC!\utils.c" "!RAYLIB_SRC!\raudio.c" "!RAYLIB_SRC!\rglfw.c"
set RAYLIB_INCLUDE_FLAGS=/I"!RAYLIB_SRC!" /I"!RAYLIB_SRC!\external\glfw\include"

cl.exe /w /c !RAYLIB_DEFINES! !RAYLIB_INCLUDE_FLAGS! !COMPILATION_FLAGS! !RAYLIB_C_FILES! || exit /B

echo COMPILE-INFO: Raylib compiled into object files in: !TEMP_DIR!\

REM Out of the temp directory
cd !ROOT_DIR!

REM Move to the build directory
IF NOT EXIST !OUTPUT_DIR! mkdir !OUTPUT_DIR!
cd !OUTPUT_DIR!

REM Build the actual game
echo COMPILE-INFO: Compiling game code.

cl.exe !COMPILATION_FLAGS! !WARNING_FLAGS! /c /I"!RAYLIB_SRC!" !SOURCES! || exit /B
cl.exe !OUTPUT_FLAG! "!ROOT_DIR!\!TEMP_DIR!\*.obj" *.obj !LINK_FLAGS! !SUBSYSTEM_FLAGS! || exit /B

del *.obj
echo COMPILE-INFO: Game compiled into an executable in: !OUTPUT_DIR!\

REM Back to development directory
cd ..
echo COMPILE-INFO: All done.
