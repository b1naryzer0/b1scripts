param (
    [Parameter(Mandatory=$true)][string]$computer
)
 
# $computer = "computer1"
 
If (Test-Connection -Count 1 $computer){
    "- $computer is online, trying to get userprofiles..."
    $profiles = Get-CimInstance -Computer $computer win32_userprofile
    "- there are ${$profiles.Count} profiles, filtering..."
    $Profiles | ForEach-Object {
        if (-not ($_.SID -in @("S-1-5-18", "S-1-5-19", "S-1-5-20", (([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value)))) {
            $_ | Remove-CimInstance
            if (Test-Path $_.LocalPath) {
                "- deleting leftover directory $_.LocalPath"
                Remove-Item -Recurse -Force $_.LocalPath
            }
        }
    }
