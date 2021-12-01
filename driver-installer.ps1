Clear-Host
######################################
# Extract all drivers in ZIP archives
# and install all of them via their
# INF files recursively
# Fritz R. 29.10.2021
######################################

"`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n"
$currentScript = $MyInvocation.MyCommand.Name

"********** INF Installer Script **********"
"- Script $currentScript started"

##### check for target folder
$today=(Get-Date).ToString("yyyyMMdd")
"- checking for target path c:\drivers\$today"
if(!(Test-Path "c:\drivers")){mkdir "c:\drivers"}
if(!(Test-Path "c:\drivers\$today")){mkdir "c:\drivers\$today"}

##### check for archives in current folder
"- checking for archives in current folder $PSScriptRoot"
$zipFiles = Get-ChildItem $PSScriptRoot -Filter *.zip

##### expanding driver archives
"- expanding archives in current folder $PSScriptRoot to c:\drivers\$today"
foreach ($zipFile in $zipFiles) {
    $zipOutPutFolderExtended = "c:\drivers\$today" + "\" + $zipFile.BaseName
    Expand-Archive -Path $zipFile.FullName -DestinationPath $zipOutPutFolderExtended
}

##### check for INF files
"- checking for INF files in c:\drivers\$today..."
$infFiles = Get-ChildItem "c:\drivers\$today" -Recurse -Filter "*.inf"
# Get-ChildItem "c:\drivers\$today\" -Recurse -Filter "*.inf" | ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install }
"- $infFiles.Count INF files found"

##### install drivers via INF files
"- installing drivers via INF files from c:\drivers\$today..."
foreach ($infFile in $infFiles) {
    "- installing " + $infFile.FullName
    pnputil.exe /add-driver $infFile.FullName /install
}

"**********        ready.        **********"
"`r`n"
