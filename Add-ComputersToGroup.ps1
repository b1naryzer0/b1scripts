Clear-Host
###############################
# Add-ComputersToGroup.ps1
###############################
 
### VARS ###
$file = "hosts.txt"
$group = "GROUP_WITH_COMPUTERS"
$machines = Get-Content -Path $file;
 
### MAIN ###
foreach ($machine in $machines)
{
    $machine = $machine.Trim()
    $account = Get-ADComputer -Identity $machine -ErrorAction SilentlyContinue;
    if ($account)
    {
        try {
            [string]$memberofs = Get-ADComputer -Identity $machine -Properties MemberOf | Select-Object MemberOf -ExpandProperty MemberOf
            If ($memberofs -match $groupname) {
                "Machine $machine is already member of group $groupname"
            } Else {
                Add-ADGroupMember -Identity $group -Members $account
                "Machine $machine was added to $groupname"
            }    
        }
        catch {"Machine $machine could not be added to $groupname : " + $_.Exception.Message}
        finally {}
    }
    $account = $null;
}  
