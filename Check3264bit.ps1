###############################################
# Check3264bit.ps1
# binaryzero 09/2022
# Checks binaries in a path for 32bit or 64bit
# needs Sysinternals sigcheck.exe
# https://learn.microsoft.com/en-us/sysinternals/downloads/sigcheck
# here: dlls only, output to file
###############################################

sigcheck -s -e C:\VST\*.dll | Select-String dll,MachineType | Out-File vst_32_64.txt
