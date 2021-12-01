@ECHO OFF
@CLS
REM color 0B
REM mode con:cols=100 lines=80

REM ******************************************
REM DISM Update and SFC Integrity Check
REM ******************************************

@ECHO ******************************************
@ECHO DISM Update and SFC Integrity Check

echo.
@ECHO ******************************************
@ECHO - updating Image
DISM.exe /Online /Cleanup-image /Restorehealth
timeout 5 > NUL

echo.
@ECHO ******************************************
@ECHO - checking and repairing system files
sfc /scannow
timeout 5 > NUL

echo.
@ECHO ******************************************
@ECHO - operation complete

PAUSE
