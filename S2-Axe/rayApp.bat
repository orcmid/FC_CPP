@echo off
rem VCrayApp 0.0.0 rayApp.bat 0.0.5 UTF-8                         2021-11-10
rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

rem                  BUILDING RAYLIB APP WITH VC/C++ TOOLS
rem                  =====================================

rem This code depends on the presence of cache\, app\, and ..\raylib\.  It
rem must be operated from within a VS Command Prompt command-line environment.
rem Use the script without modification until installation and operation is
rem confirmed.  Then alter the GAME_EXE and SRC vars for the raylib project.

SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 GOTO :FAIL0

rem rayConfirm.c is compiled as a simple example to confirm the setup.
rem After successful confirmation, substitute your app's .exe name here ...
SET GAME_EXE=rayConfirm.exe

rem ... and switch to your app's source code location, e.g., SRC=src\*.c
SET SRC=cache\rayConfirm.c


rem *********** NO CHANGES ARE NEEDED BELOW HERE *****************************
rem |----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

rem Designate the semantic-versioned distribution
SET VCrayApp=0.0.0

rem Additional documentation of this procedure and its usage are found in the
rem accompanying VCrayApp-%VCrayApp%.txt file.  For further information, see
rem <place-to-be-announced> and check for the latest
rem version at <the-related-place-to-be-announced>.

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
ECHO           %VCterse%
rem VERIFY LOCATION OF THE SCRIPT WHERE VCRayApp.zip IS FULLY EXTRACTED
rem Some are customizable, none should be removed, all %VCrayApp% specific
IF NOT EXIST "%~dp0cache\cache.txt" GOTO :FAIL1
IF NOT EXIST "%~dp0cache\rayConfirm.c" GOTO :FAIL1
IF NOT EXIST "%~dp0cache\raylibCode.opt" GOTO :FAIL1
IF NOT EXIST "%~dp0cache\raylibVars.opt" GOTO :FAIL1
IF NOT EXIST "%~dp0cache\VCoptions.opt" GOTO :FAIL1
IF NOT EXIST "%~dp0app\app.txt" GOTO :FAIL1
IF NOT EXIST "%~dp0app\rayLinking.opt" GOTO :FAIL1
IF NOT EXIST "%~dp0VCrayApp-%VCrayApp%.txt" GOTO :FAIL1
IF NOT EXIST "%~dp0rayApp.bat" GOTO :FAIL1

rem DETERMINE PARAMETERS
rem    See :USAGE for the rayApp.bat API contract
IF "%1" == "+" SHIFT /1
IF "%1" == "?" GOTO :USAGE
IF "%1" == "*" SHIFT /1
IF "%1" == "-c" ( SET VCclean=1
                  SHIFT /1 )
IF "%1" == "-r" ( SET VCrun=1
                  SHIFT /1 )
IF NOT "%1" == "" GOTO FAIL 2

rem CONFIRM COMMAND-LINE ENVIRONMENT
IF "%VSCMD_VER%" == "" GOTO FAIL3
WHERE /Q cl.exe >nul 2>nul
IF ERRORLEVEL 1 goto FAIL3
ECHO: [rayApp] Using Tools %VSCMD_VER% for %VSCMD_ARG_TGT_ARCH%     %VCterse%
ECHO           %VCterse%

rem COMPILE INTO THE CACHE IF NEEDED
IF NOT "%VCclean%" == "1" GOTO :CACHECHECK
DEL %~dp0cache\rglfw.obj

:CACHECHECK
IF EXIST %~dp0cache\rglfw.obj GOTO :APPBUILD
DEL %~dp0cache\*.obj > nul 2>nul

SET VCfrom=%CD%
CD %~dp0cache
CL.exe /w /c @VCoptions.opt @raylibVars.opt @raylibCode.opt         %VCterse%
IF ERRORLEVEL 2 GOTO :FAIL4
ECHO: [rayApp] FRESH CACHE OF RAYLIB *.OBJ FILES COMPILED           %VCterse%
ECHO: %VCterse%

:APPBUILD
CD %~dp0app
DEL *.exe >nul 2>nul
rem Flags
SET OUTPUT_FLAG=/Fe: "%GAME_EXE%"
SET SUBSYSTEM_FLAGS=/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup

rem Compiling the %SRC%
CL.exe /W3 /c @~dp0cache\VCoptions.opt %~dp0%SRC%                   %VCterse%
IF ERRORLEVEL 2 goto :FAIL5
ECHO: %VCterse%

rem Linking it all to %GAME_EXE%
CL.exe %OUTPUT_FLAG% @rayLinking.opt /link /LTCG %SUBSYSTEM_FLAGS%  %VCterse%
IF ERRORLEVEL 2 goto :FAIL5
ECHO: %VCterse%
DEL *.obj >nul 2>nul
ECHO: [rayApp] RAYLIB APP %dp0app\%GAME_EXE% COMPILED               %VCterse%
ECHO: %VCterse%

CD %VCfrom%
IF NOT "%VCrun%" == "1" GOTO :SUCCESS
%dp0app\%GAME_EXE%

:SUCCESS
IF "%VCsplice%" == "+" EXIT /B 0
IF "%VCterse%" == "" PAUSE
EXIT /B 0

:FAIL5
ECHO: [rayApp] ****FAIL: COMPILING %GAME_EXE% FAILED ****
ECHO:          Review the errors reported for the compilation, make  %VCterse%
ECHO:          repairs and reattempt.                                %VCterse%
ECHO:          RESULTS ARE UNPREDICTABLE                             %VCterse%
GOTO :BAIL

:FAIL4
ECHO: [rayApp] ****FAIL: COMPILING CACHE OF RAYLIB FILES FAILED ****
ECHO:          Review the errors reported for the compilation, make  %VCterse%
ECHO:          repairs and reattempt.                                %VCterse%
ECHO:          RESULTS ARE UNPREDICTABLE                             %VCterse%
GOTO :BAIL

:FAIL3
ECHO: [rayApp] **** FAIL: NO VS NATIVE COMMAND-LINE ENVIRONMENT ****
ECHO:          rayApp.bat requires the command-line environment for %VCterse%
ECHO:          VS Native Build Tools to be already established.     %VCterse%
ECHO:          See ^<some nfoTools support information^>.           %VCterse%
ECHO:          NO ACTIONS HAVE BEEN PERFORMED                       %VCterse%
GOTO :BAIL

:FAIL2
ECHO: [rayApp] **** FAIL: UNSUPPORTED RAYAP PARAMETERS ****
ECHO:          Invalid Here: %*
ECHO:          %VCterse%
ECHO:          NO ACTIONS HAVE BEEN PERFORMED                       %VCterse%
GOTO :USAGE

:FAIL1
ECHO: [rayApp] **** FAIL: INCORRECT VSrayApp FILES CONFIGURATION ****
ECHO:          rayApp.bat must be in the folder that VCrayApp.zip   %VCterse%
ECHO:          is extracted into, along with the cache\ and app\    %VCterse%
ECHO:          subfolders.  The extracted folders and files are not %VCterse%
ECHO:          supported if separated. See                          %VCterse%
ECHO:          ^<some nfoTools support information^>.               %VCterse%
ECHO:          NO ACTIONS HAVE BEEN PERFORMED                       %VCterse%
GOTO :BAIL

:FAIL0
ECHO: [rayApp] **** FAIL: COMMAND SHELL EXTENSIONS REQUIRED ****
ECHO:          rayApp.bat requires CMDEXTVERSION 2 or greater.       %VCterse%
ECHO:          This is available everywhere rayApp.bat is usable.    %VCterse%
ECHO:          %VCterse%
ECHO:          NO ACTIONS HAVE BEEN PERFORMED                        %VCterse%
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
rem 0.0.5 2021-11-10T00:08Z Complete draft of guard-railed script
rem 0.0.4 2021-11-08T23:43Z First stage provisional built
rem 0.0.3 2021-11-08T22:05Z Start blending VCbind on-ramp and guard rails
rem 0.0.2 2021-11-07T23:43Z Rename and continue prototyping.
rem 0.0.1 2021-11-05T21:39Z Trial Simplification for nfoTools + FC_CPP
rem 0.0.0 2021-04-26T00:01Z 3.7.0 raylib/projects/scripts/build_windows.bat
