# Run as administrator
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as an administrator."
    exit
}

# Path to the registry key for display settings
$regPath = "HKCU:\Control Panel\Desktop"

# Remove the custom scaling key if it exists
if (Test-Path "$regPath\LogPixels") {
    Remove-ItemProperty -Path $regPath -Name "LogPixels"
    Write-Output "Custom scaling size reset to default."
} else {
    Write-Output "Custom scaling size is already set to default."
}

# Notify the user to log off and log back in
Write-Output "Please log off and log back in for the changes to take effect."
