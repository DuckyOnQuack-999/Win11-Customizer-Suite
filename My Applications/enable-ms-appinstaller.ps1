# Define the registry path for the ms-appinstaller protocol
$msAppInstallerRegistryPath = "HKCR\ms-appinstaller"

# Check if the protocol key exists
if (-not (Test-Path $msAppInstallerRegistryPath)) {
    # Create the protocol registry key
    New-Item -Path $msAppInstallerRegistryPath -Force | Out-Null

    # Set the protocol's default value to empty
    Set-ItemProperty -Path $msAppInstallerRegistryPath -Name "(Default)" -Value "URL:ms-appinstaller"

    # Set the URL Protocol value
    Set-ItemProperty -Path $msAppInstallerRegistryPath -Name "URL Protocol" -Value ""

    # Define the shell open command key path
    $commandKeyPath = "$msAppInstallerRegistryPath\shell\open\command"
    New-Item -Path $commandKeyPath -Force | Out-Null

    # Set the command that will be run by the protocol
    Set-ItemProperty -Path $commandKeyPath -Name "(Default)" -Value "`"%SystemRoot%\System32\AppInstaller.exe`" %1"

    Write-Host "ms-appinstaller protocol has been successfully re-enabled in the registry."
} else {
    Write-Host "ms-appinstaller protocol is already present in the registry."
}
