1..100 | % { Rundll32.exe C:\Windows\System32\comsvcs.dll, MiniDump ((Get-Process | Sort-Object -Property "PM" -Descending | Select-Object -First 1).Id) (([guid]::NewGuid()).ToString()) full }
