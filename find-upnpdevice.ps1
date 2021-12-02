$finder = New-Object -ComObject UPnP.UPnPDeviceFinder;
$devices = $finder.FindByType("upnp:rootdevice", 0)
foreach($device in $devices)
{
    Write-Host -ForegroundColor Red ---------------------------------------------
    Write-Host -ForegroundColor Green Device Name: $device.FriendlyName
    Write-Host -ForegroundColor Green Unique Device Name: $device.UniqueDeviceName
    Write-Host -ForegroundColor Green Description: $device.Description
    Write-Host -ForegroundColor Green Model Name: $device.ModelName
    Write-Host -ForegroundColor Green Model Number: $device.ModelNumber
    Write-Host -ForegroundColor Green Serial Number: $device.SerialNumber
    Write-Host -ForegroundColor Green Manufacturer Name: $device.ManufacturerName
    Write-Host -ForegroundColor Green Manufacturer URL: $device.ManufacturerURL
    Write-Host -ForegroundColor Green Type: $device.Type
}
