"Active Powerplan: $((Get-WmiObject -Class win32_powerplan -Namespace root\cimv2\power -Filter isActive=true).ElementName)"
