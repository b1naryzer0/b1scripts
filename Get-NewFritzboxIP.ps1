###########################################################################
# Get-NewFritzboxIP.ps1
#
# reset Internet-Connection on fritz.box to get new IP:
# original code by CarstenG2
# https://gist.github.com/CarstenG2/162ca553f9b5096499a1cc34fb88397b
# absolutely minor modifications (try catch, self elevation) by Fritz R.
###########################################################################

# self-elevate because we need it
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

Add-Type -AssemblyName System.Net.Http
$handler = [System.Net.Http.HttpClientHandler]::new()
$ignoreCerts = [System.Net.Http.HttpClientHandler]::DangerousAcceptAnyServerCertificateValidator
$handler.ServerCertificateCustomValidationCallback = $ignoreCerts
$client = [System.Net.Http.HttpClient]::new($handler)
$url = 'http://fritz.box:49000/igd2upnp/control/WANIPConn1'
$body = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
<s:Body>
<u:ForceTerminationResponse xmlns:u="urn:schemas-upnp-org:service:WANIPConnection:2" />
</s:Body>
</s:Envelope>
"@
$content = [System.Net.Http.StringContent]::new($body)
$content.Headers.ContentType = 'text/xml'
$content.Headers.Add('SoapAction', 'urn:schemas-upnp-org:service:WANIPConnection:2#ForceTermination')
$result = $client.PostAsync($url, $content).Result

# wait for the new IP:
$body = @"
<s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'>
<s:Body>
<u:GetExternalIPAddress xmlns:u='urn:schemas-upnp-org:service:WANIPConnection:2' />
</s:Body>
</s:Envelope>"
"@
$oldIp = $null

Try {
    foreach ($sec in 1..30) {
        $content = [System.Net.Http.StringContent]::new($body)
        $content.Headers.ContentType = 'text/xml'
        $content.Headers.Add('SoapAction', 'urn:schemas-upnp-org:service:WANIPConnection:2#GetExternalIPAddress')
        $result = $client.PostAsync($url, $content).Result
        $response = $result.Content.ReadAsStreamAsync().Result
        $stream = [System.IO.StreamReader]::new($response)
        [xml]$data = $stream.ReadToEndAsync().Result
        $ip = $data.Envelope.Body.GetExternalIPAddressResponse.NewExternalIPAddress
        If ($oldIp -eq $null) {$oldIp = $ip; write-host "Old IP address: $oldIp"}
        If ($ip -and $ip -ne $oldIp) {break}
        Sleep 1
    }
} Catch {
    " "
}

"New IP address: $ip"
$client.dispose()

Pause
