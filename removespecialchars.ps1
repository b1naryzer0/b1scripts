####################################
# Remove special chars in file
# names for all files in a folder
# Fritz R. 19.08.2013
####################################

$path   = "E:\mp3s"

$files = Get-Childitem -Path $path | where-object {$_.PsISContainer -ne $true}

ForEach ($file in $files)
{
	$fn = $file.Fullname
	$fn = $fn -replace ("&","_")
	$fn = $fn -replace ("\..txt",".txt")
	$fn = $fn -replace ("ä","ae")
	$fn = $fn -replace ("ö","oe")
	$fn = $fn -replace ("ü","ue")
	Rename-Item $file.Fullname $fn
	Write-Host $fn
}

Write-Host "ready."
