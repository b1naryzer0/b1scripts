
IF (!(Test-Path c:\temp)){
    New-Item -ItemType Directory c:\temp
}
IF (!(Test-Path c:\temp\text.txt)){
    New-Item -ItemType File c:\temp\text.txt
}

& cmd.exe /c "type C:\Windows\System32\cmd.exe > c:\Temp\test.txt:cmd.exe"
& wmic process call create '"c:\Temp\test.txt:cmd.exe"'
