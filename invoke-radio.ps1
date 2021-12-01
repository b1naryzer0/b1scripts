# ------- save this as Invoke-Radio.ps1 -------------
function global:Invoke-Radio($url) {  
    $player = new-object -ComObject "WmPlayer.ocx"
    $player.url = $url
    $player.openPlayer($url)
}

$url = "https://ais-sa3.cdnstream1.com/2606_128.aac"
invoke-radio $url
# ------------------------------------------------------
