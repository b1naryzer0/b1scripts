#when getting disk full error, increase the MB decreased from FreeSpace
[io.file]::Create("c:\windows\bigblob.txt").SetLength((gwmi Win32_LogicalDisk -Filter "DeviceID='c:'").FreeSpace - 10MB).Close
