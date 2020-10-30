:: This batch allows to run simulations with Esmini and openPASS.
@ECHO OFF
cls
SETLOCAL ENABLEDELAYEDEXPANSION

ECHO ====================================
ECHO ####################################
ECHO #       SIMULATION TOOL SELECTION         #
ECHO ####################################

SET sel=0
ECHO Please select simulation tool:
ECHO [0]: Abort program
ECHO [1]: Esmini
ECHO [2]: openPASS
SET /p sel="Enter ID: "

IF %sel% LSS 1 GOTO finish
IF %sel% GTR 2 GOTO finish
IF %sel% EQU 1 GOTO Esmini
IF %sel% EQU 2 GOTO OpenPASS

:Esmini

ECHO ####################################
ECHO #    ESMINI: SYSTEM SETTINGS       #
ECHO ####################################

IF NOT DEFINED ESMINI (
    ECHO Esmini path not found. Please install and create ESMINI environment variable.
    PAUSE
    GOTO finish
)

ECHO esmini path: %ESMINI%

FOR /F "tokens=2 delims==" %%a in ('findstr /I "ESMINI_GIT_TAG=" "%ESMINI%\..\version.txt"') DO SET "ReleaseVersion=%%a"
SET ReleaseVersion=!ReleaseVersion:~2,-1!

FOR /F "tokens=1,2,3 delims=." %%a in ("!ReleaseVersion!") DO (
    SET Major=%%a
    SET Minor=%%b
    SET Revision=%%c
)

ECHO esmini version is: !Major!.!Minor!.!Revision!

SET supported=1

IF !Major! LSS 1 SET supported=0
IF !Major! EQU 1 (
    IF !Minor! LSS 7 SET supported=0
    IF !Minor! EQU 7 (
        IF !Revision! LSS 13 SET supported=0
        )
    )
)

IF !supported! EQU 0 (
    ECHO Unsupported esmini version.
    GOTO finish
)

SET x=0
FOR /f "delims=" %%a in ('dir /s /b *.xosc') DO (
    SET /A "x+=1"
    SET list[!x!]=%%a
)
SET Filesx=%x%

ECHO ####################################
ECHO #       ESMINI: SIMULATION         #
ECHO ####################################

ECHO Supported OpenSCENARIO (XOSC) files:
FOR /L %%i in (1,1,%Filesx%) DO ECHO [%%i]: "!list[%%i]!"
:again_esmini
ECHO ------------------------------------
ECHO Select a scenario by number.
ECHO Abort with 0.
SET id=0
SET /p id="Enter ID: "

IF %id% GEQ 1 (
    IF %id% LEQ !x! (
        "%ESMINI%\EgoSimulator.exe" --window 100 200 1024 576  --osc !list[%id%]! --trails off
        GOTO again_esmini
    )
)

GOTO finish

:OpenPASS

SET num_supported_scenario_version=7
SET list_supported_scenario_version[1]=4.1_1
SET list_supported_scenario_version[2]=4.2_1
SET list_supported_scenario_version[3]=4.2_2
SET list_supported_scenario_version[4]=4.2_4
SET list_supported_scenario_version[5]=4.5_1
SET list_supported_scenario_version[6]=4.5_2
SET list_supported_scenario_version[7]=4.6_1

ECHO ####################################
ECHO #    OPENPASS: SYSTEM SETTINGS     #
ECHO ####################################

SET dir_path=%~dp0

IF DEFINED OPENPASS (
    ECHO OPENPASS path found.
    ECHO OPENPASS path: %OPENPASS%
) ELSE (
    ECHO OPENPASS path not found. 
    ECHO Please create OPENPASS environment variable, which directs to the installation directory of openPASS and restart shell.
    PAUSE 
    GOTO finish
)

:: Missing: Version Check of OpenPASS

ECHO Settings successful.

SET x=0
FOR /F "delims=" %%a in ('dir /s /b %dir_path%*.xosc') DO (
    SET /A "x+=1"
    SET list_scenario_path_and_filename[!x!]=%%a
    SET list_scenario_path[!x!]=%%~dpa
    SET list_scenario_filename[!x!]=%%~nxa
)
SET num_scenarios=%x%

SET x=0
FOR /L %%i in (1,1,%num_scenarios%) DO (
    FOR /L %%j in (1,1,%num_supported_scenario_version%) DO (
        IF "!list_scenario_filename[%%i]:~14,5!"=="!list_supported_scenario_version[%%j]!" (
            SET /A "x+=1"
            SET list_supported_scenario_path_and_filename[!x!]=!list_scenario_path_and_filename[%%i]!
        )
    )
)

ECHO ####################################
ECHO #      OPENPASS: SIMULATION        #
ECHO ####################################

ECHO Supported OpenSCENARIO (XOSC) files:
FOR /L %%i in (1,1,%num_supported_scenario_version%) DO (
    ECHO [%%i]: !list_supported_scenario_path_and_filename[%%i]!
)

:again_openpass
ECHO ------------------------------------
ECHO Select a scenario by number.
ECHO Abort with 0.
SET id=0
SET /p id="Enter ID: "

if %id% GEQ 1 (
    if %id% LEQ !num_supported_scenario_version! (
        ECHO Running...
        IF EXIST %OPENPASS%\configs\NUL (
            ECHO Config directory does exist. Empty config directory.
            cd /d "%OPENPASS%\configs"
            FOR /F "delims=" %%i in ('dir /b') DO (
                rmdir "%%i" /s/q 2>NUL || del "%%i" /s/q >NUL 
            )
        ) ELSE (
            ECHO Config directory does not exist. Create config directory.
            mkdir %OPENPASS%\configs
        )

        xsltproc -o %OPENPASS%\configs\Scenario.xosc %dir_path%openPASS_Resources\AdaptALKSToOpenPASS.xslt !list_supported_scenario_path_and_filename[%id%]! >NUL

        copy %dir_path%openPASS_Resources\ProfilesCatalog.xml %OPENPASS%\configs  >NUL
        copy %dir_path%openPASS_Resources\slaveConfig.xml %OPENPASS%\configs >NUL
        copy %dir_path%openPASS_Resources\systemConfigBlueprint.xml %OPENPASS%\configs >NUL
        copy %dir_path%ALKS_Road_Different_Curvatures.xodr %OPENPASS%\configs >NUL
        copy %dir_path%ALKS_Road.xodr %OPENPASS%\configs >NUL
        copy %dir_path%..\Catalogs\Pedestrians\PedestrianCatalog.xosc %OPENPASS%\configs >NUL
        copy %dir_path%..\Catalogs\Vehicles\VehicleCatalog.xosc %OPENPASS%\configs >NUL

        %OPENPASS%\OpenPassSlave.exe --logFile %OPENPASS%\results\OpenPassSlave.log 

        IF %ERRORLEVEL% EQU 0 (
            FOR %%A in (%OPENPASS%\results\OpenPassSlave.log) DO (
                IF %%~zA==0 (
                    ECHO Simulation successful.
                    ECHO Simulation output written to %OPENPASS%\results
                    GOTO again_openpass
                ) ELSE (
                    FOR /F "tokens=*" %%A in (%OPENPASS%\results\OpenPassSlave.log) DO ECHO %%A
                    ECHO Simulation failed.
                    GOTO finish
                )
            )
        ) ELSE (
            FOR /F "tokens=*" %%A in (%OPENPASS%\results\OpenPassSlave.log) DO ECHO %%A
            ECHO Simulation failed.
            GOTO finish
        )
    )
)

GOTO finish

:finish 
ECHO ------------------------------------
ECHO Good bye.
ECHO ====================================
ENDLOCAL 