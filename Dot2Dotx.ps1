############################
# Dot2Dotx.ps1
# v 1.0
# b1naryzer0 01/2023
############################
<#
    .Synopsis
    PowerShellscript zur Konvertierung von *.DOT nach *.DOTX
    .PARAMETER Path
    Gültiger Pfad zu einem Ordner, der die zu konvertierenden Dokumente enthält
#>
[CmdletBinding()]
  Param(
    [string]$Path = ''
)
$ERR_PATHMISSING = 1002
if($Path -eq '') {
    Write-Warning -Message 'Bitte einen gültigen Dateipfad angeben!'
    exit $ERR_PATHMISSING
}
$word = New-Object -ComObject Word.Application
$Format = [Microsoft.Office.Interop.Word.WdSaveFormat]::wdFormatXMLTemplate
Get-ChildItem -Path $Path -Filter *.dot | ForEach-Object {
    $document = $word.Documents.Open($_.FullName)
    try {
        $document.Convert() | Out-Null -ErrorAction SilentlyContinue
    } catch {}
    $docx_filename = "$($_.DirectoryName)\$($_.BaseName).dotx"
    $document.SaveAs([ref] $docx_filename, [ref]$Format)
    $document.Close()
    "$docx_filename"
}
$word.Quit()
