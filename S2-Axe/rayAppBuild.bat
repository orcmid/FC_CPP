@echo off
REM rayAppBuild.bat 0.0.2           UTF-8                         2021-11-07
REM |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

REM Specify your executable name here
set GAME_EXE=rayConfirm.exe
REM Set your sources here (relative to rayAppBuild.bat location)
set SRC=cache\rayConfirm.c
REM cache\rayConfirm.c is provided with the raylib setup to confirm proper
REM installation and compilation

REM This code depends on the presence of cache/, app/, and ../raylib/

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

REM |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*
REM
REM 0.0.2 2021-11-07T23:43Z Rename and continue prototyping.
REM 0.0.1 2021-11-05T21:39Z Trial Simplification for nfoTools + FC_CPP
REM 0.0.0 2021-04-26T00:01Z 3.7.0 raylib/projects/scripts/build_windows.bat
