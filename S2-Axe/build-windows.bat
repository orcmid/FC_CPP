@REM build-windows.bat 0.0.9       UTF-8                          2021-09-30
@REM ----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*
@echo off
REM Change your executable name here
set GAME_NAME=core_basic_window.exe

REM Set your sources here (relative paths!)
REM Example with two source folders:
REM set SOURCES=src\*.c src\submodule\*.c
set SOURCES=core_basic_window.c

REM Set your raylib\src location here (relative path!)
set RAYLIB_SRC=..\..\..\raylib\src

REM Set the target platform for the compiler (Ex: x86 or x64)
set TARGET_PLATFORM=x64

echo build-windows.bat 0.0.9 Simple raylib VC project

REM About this build script: it does many things, but in essence, it's
REM very simple. It has 3 compiler invocations: building raylib (which
REM is not done always, see logic by searching "Build raylib"), building
REM src/*.c files, and linking together those two. Each invocation is
REM wrapped in an if statement to make the -qq flag work, it's pretty
REM verbose, sorry.

REM To skip to the actual building part of the script, search for ":BUILD"

REM Check that cl is available
WHERE cl >nul 2>nul
IF %ERRORLEVEL% == 0 goto READ_ARGS
echo "Command-line environment is not set up.  Please do so."
exit /B
)

:READ_ARGS
REM For the ! variable notation
setlocal EnableDelayedExpansion
REM For shifting, which the command line argument parsing needs
setlocal EnableExtensions

:ARG_LOOP
set ARG=%1
if "!ARG!" == "" ( goto BUILD )
IF NOT "x!ARG!" == "x!ARG:h=!" (
  goto HELP
)
IF NOT "x!ARG!" == "x!ARG:r=!" (
  set RUN_AFTER_BUILD=1
)
IF NOT "x!ARG!" == "x!ARG:c=!" (
  set BUILD_ALL=1
)
IF NOT "x!ARG!" == "x!ARG:v=!" (
  set VERBOSE=1
)
IF NOT "%1" == "" (
  shift /1
  goto ARG_LOOP
)


:HELP
echo Usage: build-windows.bat [-hrcv]
echo  -h  Show this information
echo  -r  Run the executable after compilation
echo  -c  Remove the temp\{debug,release} directory, ie. full recompile
echo  -v  cl.exe normally prints out a lot of superficial information, as
echo      well as the MSVC build environment activation scripts, but these are
echo      mostly suppressed by default. If you do want to see everything, use
echo      this flag.
echo.
echo Examples:
echo  Build a release build:                    build-windows.bat
echo  Build a release build, full recompile:    build-windows.bat -c
echo  Build a fresh verbose build and run:      build-windows.bat -c -v -r
exit /B


:BUILD
REM Directories
set ROOT_DIR=%CD%
set SOURCES=!ROOT_DIR!\!SOURCES!
set RAYLIB_SRC=!ROOT_DIR!\!RAYLIB_SRC!

REM Flags
set OUTPUT_FLAG=/Fe: "!GAME_NAME!"
set COMPILATION_FLAGS=/std:c11 /O1 /GL /favor:blend /utf-8 /validate-charset /EHsc
set WARNING_FLAGS=/W3 /sdl
set SUBSYSTEM_FLAGS=/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup
set LINK_FLAGS=/link /LTCG kernel32.lib user32.lib shell32.lib winmm.lib gdi32.lib opengl32.lib
REM /LTCG deleted
set OUTPUT_DIR=app

IF NOT DEFINED VERBOSE (
  set VERBOSITY_FLAG=/nologo
)

REM Display what we're doing
echo COMPILE-INFO: Compiling raylib project, flags: !COMPILATION_FLAGS! /link /LTCG

REM Create the temp directory for raylib
set "TEMP_DIR=wrk


IF DEFINED BUILD_ALL (
  IF EXIST !TEMP_DIR!\core.obj (
    echo COMPILE-INFO: Found cached raylib files, rebuilding.
    del !TEMP_DIR!\*.obj
  )
)

REM Build raylib if it hasn't been cached in TEMP_DIR
IF NOT EXIST !TEMP_DIR!\core.obj (
  cd !TEMP_DIR!
  REM Raylib's src folder
  set "RAYLIB_DEFINES=/D_DEFAULT_SOURCE /DPLATFORM_DESKTOP /DGRAPHICS_API_OPENGL_33"
  set RAYLIB_C_FILES="!RAYLIB_SRC!\core.c" "!RAYLIB_SRC!\shapes.c" "!RAYLIB_SRC!\textures.c" "!RAYLIB_SRC!\text.c" "!RAYLIB_SRC!\models.c" "!RAYLIB_SRC!\utils.c" "!RAYLIB_SRC!\raudio.c" "!RAYLIB_SRC!\rglfw.c"
  set RAYLIB_INCLUDE_FLAGS=/I"!RAYLIB_SRC!" /I"!RAYLIB_SRC!\external\glfw\include"

  cl.exe /w /c !VERBOSITY_FLAG! !RAYLIB_DEFINES! !RAYLIB_INCLUDE_FLAGS! !COMPILATION_FLAGS! !RAYLIB_C_FILES! || exit /B

  echo COMPILE-INFO: Raylib compiled into object files in: !TEMP_DIR!\

  REM Out of the temp directory
  cd !ROOT_DIR!
)

REM Move to the build directory
IF NOT EXIST !OUTPUT_DIR! mkdir !OUTPUT_DIR!
cd !OUTPUT_DIR!

REM Build the actual game
echo COMPILE-INFO: Compiling game code.
cl.exe !VERBOSITY_FLAG! !COMPILATION_FLAGS! !WARNING_FLAGS! /c /I"!RAYLIB_SRC!" !SOURCES! || exit /B
echo COMPILE_INFO: Linkiing game code.
cl.exe !VERBOSITY_FLAG! !OUTPUT_FLAG! "!ROOT_DIR!\!TEMP_DIR!\*.obj" *.obj !LINK_FLAGS! !SUBSYSTEM_FLAGS! || exit /B
)
del *.obj
echo COMPILE-INFO: Game compiled into an executable in: !OUTPUT_DIR!\

REM Finally, run the produced executable
IF DEFINED RUN_AFTER_BUILD (
     echo COMPILE-INFO: Running
     !GAME_NAME!
)

REM Back to development directory
cd !ROOT_DIR!

echo COMPILE-INFO: All done.

@REM 0.0.9 2021-09-30T18:08Z Fix warnings and resume /link code generation
@REM 0.0.8 2021-09-30T00:30Z Get Stable build/rebuild working
@REM 0.0.7 2021-09-29T22:41Z Do Wall on the source (not raylib)
@REM 0.0.6 2021-09-29T22:35Z Change how wrk/ is cleaned
@REM 0.0.5 2021-09-29T22:19Z Switch to wrk/ from temp variations
@REM 0.0.4 2021-09-29T21:42Z Simplify confirmation of VC Tools
@REM 0.0.3 2021-09-29T21:32Z Eliminate all but -v -c -r options
@REM 0.0.2 2021-09-29T21:03Z Change output directory to app/
@REM 0.0.1 2021-09-29T18:35Z Set parameters for compiling at rawVC/
@REM 0.0.0 2021-09-29T18:27Z Cloned from raylib scripts/ folder.
