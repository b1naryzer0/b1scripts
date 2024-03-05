@echo off
setlocal enabledelayedexpansion
for %%a in (%1) do (
  fsutil file setzerodata offset=1048576 length=%%~za %%a
)
endlocal

