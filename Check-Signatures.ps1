###################################
# Check files for valid signatures
#
# Fritz R. 07.12.2021 
###################################

$searchpath = "C:\Windows\System32\drivers\"
Get-ChildItem -Path $searchpath -Recurse | where {$_.extension -in ".dll", ".exe", ".sys" } | Where { ! $_.PSIsContainer } | Get-AuthenticodeSignature | Where-Object {$_.status -ne "Valid"} | Select-Object status,path
