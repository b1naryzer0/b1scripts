##########################################
# Shutdown with reminder 
# reminds to switch speakers off :)
# or any other task which can't be 
# automated
##########################################
Add-Type -AssemblyName System.Windows.Forms
$result = [System.Windows.Forms.MessageBox]::Show("Speakers off!","Save energy!!!",1)

IF ($result -eq "OK") {
    C:\Windows\System32\shutdown.exe /h
} else {
    "Shutdown aborted."
}
