##########################################
# checks a present DNS suffix search list
# for the fritz.box entry and deletes it
# if present
##########################################

$fritzbox = "fritz.box"
$suffixesalt = (Get-DnsClientGlobalSetting).SuffixSearchList
$suffixesneu = @()
$suffixesalt | % {If($_ -notin $fritzbox){[array]$suffixesneu += [array]$_}}
Set-DnsClientGlobalSetting -SuffixSearchList @($suffixesneu)
