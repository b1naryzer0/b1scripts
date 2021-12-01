REM ************************
REM simple robocopy script
REM ************************

SET source=\\server\share
SET target=d:\data\data1
robocopy.exe "%source%" "%target%" /copy:DAT /E /R:1 /W:1
