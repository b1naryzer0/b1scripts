###############################
# diaspora_contact_exporter.ps1
###############################

$7z = 'D:\Program Files\7-Zip\7z.exe'
$exp = 'diaspora_data.json.gz'
$json = [io.path]::GetFileNameWithoutExtension($exp)
$txt = $json + '.txt'
.$7z e $exp
jq '.user.contacts[] | select(.followed).account_id' -r $json | sort | tee $txt

<###############################
Dependency: jq
- download https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe and install
- or with chocolatey: choco install jq

Dependency: 7-Zip
- download https://7-zip.org/a/7z2107-x64.exe and install
- or with chocolatey: choco install 7z
###############################>
