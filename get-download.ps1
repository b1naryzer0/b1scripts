Clear-Host
####################
# get-download.ps1
# simple downloader
####################
$url = "https://www.archlinux.de/download/iso/2021.12.01/archlinux-2021.12.01-x86_64.iso"
$output = "$PSScriptRoot\test.blob

"-checking if $output exists already..."
If (Test-Path $output)
{
    "-$output already exists, trying to delete it..."
    Remove-Item $output -Force -ErrorVariable $myerr
    If ($myerr)
    {
        "-Error: could not delete $output, breaking..."
        Exit 1
    } Else {
        "-$output successfully deleted"
    }
}

"-trying: $url"
$wc = New-Object System.Net.WebClient
$start_time = Get-Date

try
{
    $wc.DownloadFile($url,$output)
}
catch [System.Net.WebException]
{
    Write-Host $_.Exception.ToString()
}

"-Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

