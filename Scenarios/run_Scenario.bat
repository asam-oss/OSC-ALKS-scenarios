@ECHO OFF
cls
:: This batch allows to run the different scenarios with esmini.
:: Section 1: SYSTEM information.
ECHO ====================================
ECHO SYSTEM INFO.
ECHO ====================================
setlocal EnableDelayedExpansion

if not defined ESMINI (
    ECHO Esmini path not found. Please install and create ESMINI environment variable.
    pause
    GOTO finish
)

ECHO esmini path: %ESMINI%

for /F "tokens=2 delims==" %%a in ('findstr /I "ESMINI_GIT_TAG=" "%ESMINI%\..\version.txt"') do set "ReleaseVersion=%%a"
set ReleaseVersion=!ReleaseVersion:~2,-1!

for /F "tokens=1,2,3 delims=." %%a in ("!ReleaseVersion!") do (
   set Major=%%a
   set Minor=%%b
   set Revision=%%c
)

echo esmini version is: !Major!.!Minor!.!Revision!

set supported=1

if !Major! LSS 1 set supported=0
if !Major! EQU 1 (
    if !Minor! LSS 7 set supported=0
    if !Minor! EQU 7 (
        if !Revision! LSS 12 set supported=0
        )
    )
)

if !supported! EQU 0 (
    echo Unsupported esmini version.
    goto finish
)

:: Section 2: Parse OpenScenario files in same folder.
set x=0
for /f "delims=" %%a in ('dir /s /b *.xosc') do (
   set /A "x+=1"
   set list[!x!]=%%a
)
set Filesx=%x%

:again
ECHO ====================================
ECHO List of OpenSceanrio (XOSC) files.
ECHO ====================================
rem Display array elements
for /L %%i in (1,1,%Filesx%) do echo [%%i]: "!list[%%i]!"
ECHO ====================================
ECHO Select and play a scenario by number.
ECHO Abort with 0.
ECHO ====================================
set id=0
set /p id="Enter ID: "

if %id% GEQ 1 (
    if %id% LEQ !x! (
        "%ESMINI%\EgoSimulator.exe" --window 100 200 1024 576  --osc !list[%id%]! --trails off
        cls
        GOTO again
    )
)

:finish
ECHO Good bye.
