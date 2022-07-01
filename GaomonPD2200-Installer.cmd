@ECHO OFF & CLS & COLOR 17
REM ******************************************
REM Gaomon PD2200 Windows Enterprise Installer
REM (c) Fritz R. 01.07.2022
REM ******************************************
 
ECHO - checking for administrative privileges
net session >nul 2>&1 || (PowerShell start -verb runas '%~0' &exit /b)
 
ECHO ******************************************
ECHO Gaomon PD2200 Windows Enterprise Installer
ECHO (c) Fritz R. 01.07.2022
ECHO ******************************************
 
ECHO - changing path to %CD%
CD %CD%
PUSHD %CD%
IF %errorlevel% NEQ 0 GOTO:ERROR
 
ECHO - starting Gaomon installer, please wait...
%cd%\GaomonWindowsDriver_v14.8.213.1502_HID.exe /DIR="c:\program files\Gaomon" /ALLUSERS /VERYSILENT /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /TYPE=FULL /SUPPRESSMSGBOXES
IF %errorlevel% NEQ 0 GOTO:ERROR
 
GOTO:DONE
 
:ERROR
ECHO - ERROR - INSTALLATION FAILED
ECHO - Gaomon Inno installer failed, check for errors
PAUSE
GOTO:END
 
:DONE
ECHO - Gaomon Inno installer finished the installation
 
:END
POPD
ECHO - current path is %CD%
ECHO - you can close this window now
ECHO.
PAUSE
COLOR
