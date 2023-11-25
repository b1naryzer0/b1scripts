##################################################################
# Mariah.ps1
# self-elevates to admin
# disables keys & mouse
# turns volume up to 100
# plays Mariah Carey All I Want For Xmas Is You looped for 8 hours
# merry Xmas
# Fritz R. 24.11.2023
##################################################################

### Self-elevate the script if required
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    If ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

### Disable user input
$code = @"
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
"@
$userInput = Add-Type -MemberDefinition $code -Name UserInput -Namespace UserInput -PassThru

Function Disable-UserInput($seconds) {
    $userInput::BlockInput($true)
    Start-Sleep $seconds
    $userInput::BlockInput($false)
}

### Turn volume up
Function Set-Speaker($Volume)
{
    $wshShell = new-object -com wscript.shell;1..50 | % {$wshShell.SendKeys([char]174)};1..$Volume | % {$wshShell.SendKeys([char]175)}
}

### Main
Set-Speaker -Volume 100
Start-Process "https://www.youtube.com/watch?v=aAkMkVFwAoo?autoplay=1&loop=1"
Disable-UserInput -seconds 28800 | Out-Null
