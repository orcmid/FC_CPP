@echo off
rem VCrayApp 0.0.0 rayApp.bat 0.0.3 UTF-8                         2021-11-08
rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

rem                  BUILDING RAYLIB APP WITH VC/C++ TOOLS
rem                  =====================================

rem This code depends on the presence of cache\, app\, and ..\raylib\.  It
rem must be operated from within a VS Command Prompt command-line environment.
rem Use the script without modification until installation and operation is
rem confirmed.

rem After successful confirmation, substitute your app's .exe name here ...
SET GAME_EXE=rayConfirm.exe

rem ... and switch to your app's source code location, e.g., SRC=src\*.c ...
SET SRC=cache\rayConfirm.c

rem rayConfirm.c is compiled as a simple example to confirm the setup.


rem *********** NO CHANGES ARE NEEDED BELOW HERE *****************************
rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

rem Additional documentation of this procedure and its usage are found in the
rem accompanying VCrayApp file.  For further information, see
rem <place-to-be-announced> and check for the latest
rem version at <the-related-place-to-be-announced>.

rem Designate the semantic-versioned distribution
SET VCrayApp=0.0.0



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
REM XXXXXXXXX There seems no need for this

REM XXXXXXXXX THIS CODE BUILDS EVERYTHING WITH VERBOSITY - FIX VCbind STYLE

REM Flags
set OUTPUT_FLAG=/Fe: "!GAME_EXE!"
set SUBSYSTEM_FLAGS=/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup


REM Display what we're doing
echo COMPILE-INFO: Cache raylib *.obj files for linking with the app.

REM Cache raylib .obj files

cd cache

REM XXXXXXXX Check Result Codes rather than crashing out with Exit
cl.exe /w /c @VCoptions.opt @raylibVars.opt @raylibCode.opt || exit /B

echo COMPILE-INFO: Raylib object files compiled to: cache\

REM Move to the app directory
cd ..\app
del *.exe

REM Build the actual game
echo COMPILE-INFO: Compiling and linking game code.

cl.exe /W3 /c @..\cache\VCoptions.opt ..\!SRC! || exit /B
cl.exe !OUTPUT_FLAG! @rayLinking.opt /link /LTCG !SUBSYSTEM_FLAGS! || exit /B

del *.obj
echo COMPILE-INFO: Game compiled to app\%GAME_EXE%

REM Back to development directory
cd ..
echo COMPILE-INFO: All done.

rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*
rem
rem 0.0.3 2021-11-08T22:05Z Start blending VCbind on-ramp and guard rails
rem 0.0.2 2021-11-07T23:43Z Rename and continue prototyping.
rem 0.0.1 2021-11-05T21:39Z Trial Simplification for nfoTools + FC_CPP
rem 0.0.0 2021-04-26T00:01Z 3.7.0 raylib/projects/scripts/build_windows.bat
