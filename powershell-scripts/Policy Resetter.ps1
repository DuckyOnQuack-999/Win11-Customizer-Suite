# Run PowerShell as an Administrator

# Disable Windows Defender settings managed by organization
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -DisableBehaviorMonitoring $false
Set-MpPreference -DisableIOAVProtection $false
Set-MpPreference -DisablePrivacyMode $false
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $false
Set-MpPreference -DisableArchiveScanning $false

# Remove specific registry keys that might be causing the issue
$registryPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Defender",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
)

foreach ($path in $registryPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse
    }
}

# Remove Group Policy registry settings
$gpRegistryPaths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects",
    "HKCU:\Software\Policies\Microsoft\Windows",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects",
    "HKLM:\Software\Policies\Microsoft\Windows"
)

foreach ($path in $gpRegistryPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse
    }
}

# Refresh Group Policy
gpupdate /force

# Restart the computer to apply changes
Restart-Computer
