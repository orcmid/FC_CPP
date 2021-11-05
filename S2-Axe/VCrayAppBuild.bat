@echo off
REM VCrayAppBuild.bat 0.0.1         UTF-8                         2021-11-05
REM |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

REM Specify your executable name here
set GAME_EXE=rayConfirm.exe
REM Set your sources here (relative paths!)
set SOURCES=rayConfirm.c

REM Keep these presets unless a different configuration is desired
REM Select the folder for caching raylib .obj files
set TEMP_DIR=cache
REM Set your raylib\src location here (relative path from cache!)
set RAYLIB_SRC=..\raylib\src
REM Set the folder for holding the compiled program and any resources
set OUTPUT_DIR=app

REM *********** NO CHANGES ARE NEEDED BELOW HERE *****************************
REM |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

REM Check if Native Command-Line Environment is established.
REM TODO: CHANGE TO VCBIND STYLE CONFIRMATION <<<<<<<<<<<<<<<<<<<<<
WHERE cl >nul 2>nul
IF %ERRORLEVEL% == 0 goto BUILD
echo "Developer Command-line environment must be set first."
REM TODO: PROVIDE BETTER HELP ON SETTING ENVIRONMENT <<<<<<<<<<<<<<<<<<<<<
exit /B

:BUILD
REM For the ! variable notation
setlocal EnableDelayedExpansion

set BUILD_ALL=1
REM TODO: CREATE A SEPARATE CLEAR FUNCTION/OPTION SOMEHOW
set VERBOSE=1
REM TODO: SWITCH TO VCBIND SILENT OPTION

REM Directories
set "ROOT_DIR=%CD%"
set "SOURCES=!ROOT_DIR!\!SOURCES!"
set "RAYLIB_SRC=!ROOT_DIR!\!RAYLIB_SRC!"

REM Flags
set OUTPUT_FLAG=/Fe: "!GAME_EXE!"
set COMPILATION_FLAGS=/O1 /GL
set WARNING_FLAGS=
set SUBSYSTEM_FLAGS=/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup
set LINK_FLAGS=/link /LTCG kernel32.lib user32.lib shell32.lib winmm.lib gdi32.lib opengl32.lib


REM Display what we're doing
echo COMPILE-INFO: Linker code generation: !COMPILATION_FLAGS! /link /LTCG

REM Cache raylib .obj files

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
cd !OUTPUT_DIR!
del *.exe

REM Build the actual game
echo COMPILE-INFO: Compiling and linking game code.

cl.exe !COMPILATION_FLAGS! !WARNING_FLAGS! /c /I"!RAYLIB_SRC!" !SOURCES! || exit /B
cl.exe !OUTPUT_FLAG! "!ROOT_DIR!\!TEMP_DIR!\*.obj" *.obj !LINK_FLAGS! !SUBSYSTEM_FLAGS! || exit /B

del *.obj
echo COMPILE-INFO: Game compiled to !OUTPUT_DIR!\!GAME_EXE!

REM Back to development directory
cd ..
echo COMPILE-INFO: All done.

REM |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*
REM
REM 0.0.1 2021-11-05T21:39Z Trial Simplification for nfoTools + FC_CPP
REM 0.0.0 2021-04-26T00:01Z 3.7.0 raylib/projects/scripts/build_windows.bat
