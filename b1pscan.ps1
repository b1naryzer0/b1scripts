$subnet = "10.10.10."
$port = @(22,80,443,3306,3389)

for ($i=1;$i -lt 255;$i++)
{
    for ($p=0;$p -lt $port.Length; $p++)
    {
        $tcpobject = new-Object system.Net.Sockets.TcpClient 
        $connect = $tcpobject.BeginConnect("$subnet$i",$port[$p],$null,$null) 
        $wait = $connect.AsyncWaitHandle.WaitOne(1,$false) 
        If (-Not $Wait) {
            # "$subnet$i : port " + $port[$p] + " closed"
        } Else {
            $error.clear()
            $tcpobject.EndConnect($connect) | out-Null 
            If ($Error[0]) {
                Write-warning ("{0}" -f $error[0].Exception.Message)
            } Else {
                "$subnet$i : port " + $port[$p] + " open!"
            }
        }
    }
}
