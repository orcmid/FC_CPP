@echo off
rem VCrayApp 0.0.0 rayApp.bat 0.0.4 UTF-8                         2021-11-08
rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

rem                  BUILDING RAYLIB APP WITH VC/C++ TOOLS
rem                  =====================================

rem This code depends on the presence of cache\, app\, and ..\raylib\.  It
rem must be operated from within a VS Command Prompt command-line environment.
rem Use the script without modification until installation and operation is
rem confirmed.

SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 GOTO :FAIL0

rem After successful confirmation, substitute your app's .exe name here ...
SET GAME_EXE=rayConfirm.exe

rem ... and switch to your app's source code location, e.g., SRC=src\*.c ...
SET SRC=cache\rayConfirm.c

rem rayConfirm.c is compiled as a simple example to confirm the setup.


rem *********** NO CHANGES ARE NEEDED BELOW HERE *****************************
rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

rem Additional documentation of this procedure and its usage are found in the
rem accompanying VCrayApp.txt file.  For further information, see
rem <place-to-be-announced> and check for the latest
rem version at <the-related-place-to-be-announced>.

rem Designate the semantic-versioned distribution
SET VCrayApp=0.0.0

rem SELECT EMBEDDED, TERSE, OR DEFAULT
rem     %1 value "+" selects smooth non-stop operation for splicing output
rem        into that of a calling script.
rem     %2 might then be "*" and allow for that.
rem don't shift anything out until %1-%2 handled.
SET VCterse=
SET VCsplice=%1
IF NOT "%1" == "+" GOTO :MAYBETERSE
IF "%2" == "*" SET VCterse=^>NUL

:MAYBETERSE
rem SELECT TERSE OR VERBOSE
IF "%1" == "*" SET VCterse=^>NUL
rem                used to dump verbose echoes

rem ANNOUNCE THIS SCRIPT
IF "%1" == "*" GOTO :WHISPER
IF "%1" == "+" GOTO :WHISPER
TITLE BUILDING RAYLIB APP WITH VC/C++ TOOLS
CLS

:WHISPER
ECHO: [rayApp] %VCrayApp% BUILDING RAYLIB APP WITH VC/C++ TOOLS

IF "%VCsplice%" == "+" GOTO :LOCATE
ECHO:          %TIME% %DATE% on %USERNAME%'s %COMPUTERNAME%         %VCterse%
ECHO:          %~dp0                                                %VCterse%
rem            reporting script directory location

:LOCATE
rem VERIFY LOCATION OF THE SCRIPT WHERE VCRayApp.zip IS FULLY EXTRACTED
IF NOT EXIST "%~dp0cache\cache.txt" GOTO :FAIL1
IF NOT EXIST "%~dp0app\app.txt" GOTO :FAIL1
IF NOT EXIST "%~dp0VCrayApp-%VCrayApp%.txt" GOTO :FAIL1
IF NOT EXIST "%~dp0rayApp.bat" GOTO :FAIL1

rem DETERMINE PARAMETERS
rem    See :USAGE for the VCbind API contract
IF "%1" == "+" SHIFT /1
IF "%1" == "?" GOTO :USAGE
IF "%1" == "*" SHIFT /1

rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*
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


:FAIL1
ECHO:          **** FAIL: SCRIPT IS NOT IN THE REQUIRED LOCATION ****
ECHO:          rayApp.bat must be in the folder that VCbind.zip     %VCterse%
ECHO:          is extracted into.  VCbind.bat is not designed to be %VCterse%
ECHO:          separated from the extracted contents of VCbind.zip. %VCterse%
ECHO:          %VCterse%
ECHO:          NO ENVIRONMENT CHANGES HAVE BEEN MADE                %VCterse%
ECHO:          Follow instructions in the VCbind-%VCverNum%.txt     %VCterse%
ECHO:          file for extracting all of VCbind.zip content to a   %VCterse%
ECHO:          working location and using the VCbind.bat there. Also%VCterse%
ECHO:          see ^<http://nfoWare.com/dev/2016/11/d161101.htm^>.  %VCterse%
GOTO :BAIL

:FAIL0
ECHO:          **** FAIL: COMMAND SHELL EXTENSIONS REQUIRED ****
ECHO:          rayApp.bat requires CMDEXTVERSION 2 or greater.       %VCterse%
ECHO:          This is available everywhere rayApp.bat is usable.    %VCterse%
ECHO:          %VCterse%
ECHO:          NO ENVIRONMENT CHANGES HAVE BEEN MADE                 %VCterse%
GOTO :BAIL

:USAGE
rem    PROVIDE USAGE INFORMATION
ECHO:   %VCterse%
ECHO:   USAGE: rayApp [+] ?
ECHO:          rayApp [+] [*] [-c] [-r]
IF NOT "%1" == "?" GOTO :BAIL
ECHO:   where
ECHO:           ? produces this usage information.
ECHO:           + for operating non-stop without any screen clearings
ECHO:             and pausings.  Good for providing output as a helper
ECHO:             to a calling script.
ECHO:           * selects terse output.  If operation fails, repeat
ECHO:             the command line without this option for more details.
ECHO:          -c for a complete rebuild of any cache before building the app
ECHO:          -r for running the app on successful build
ECHO:
ECHO:    Exit code 0 is produced on all successful operations.  Exit codes
ECHO:    greater than 1 are produced for all failure cases.
ECHO:
IF "%VCsplice%" == "+" EXIT /B 0
PAUSE
EXIT /B 0

:BAIL
ECHO:
IF NOT ERRORLEVEL 2 SET ERRORLEVEL=2
IF NOT "%VCterse%" == "" EXIT /B %ERRORLEVEL%
IF "%VCsplice%" == "+" EXIT /B %ERRORLEVEL%
ECHO:
PAUSE
EXIT /B %ERRORLEVEL%

rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*
rem
rem 0.0.4 2021-11-08T23:43Z First stage provisional built
rem 0.0.3 2021-11-08T22:05Z Start blending VCbind on-ramp and guard rails
rem 0.0.2 2021-11-07T23:43Z Rename and continue prototyping.
rem 0.0.1 2021-11-05T21:39Z Trial Simplification for nfoTools + FC_CPP
rem 0.0.0 2021-04-26T00:01Z 3.7.0 raylib/projects/scripts/build_windows.bat
