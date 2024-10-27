# Check if the script is run with administrative privileges
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "This script needs to be run as an Administrator."
    Exit
}

# Function to set a registry value
Function Set-RegistryValue {
    param (
        [string]$Path,
        [string]$Name,
        [string]$ValueType,
        [string]$Value
    )
    Try {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $ValueType -ErrorAction Stop
        Write-Host "Successfully set $Name to $Value in $Path"
    } Catch {
        Write-Host "Failed to set $Name in $Path. Error: $_"
    }
}

# Enable Optional Diagnostic Data
$diagnosticsPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
Set-RegistryValue -Path $diagnosticsPath -Name "AllowTelemetry" -ValueType "DWord" -Value 3

# Enable Inking and Typing Diagnostic Data
$inkingPath = "HKLM:\SOFTWARE\Microsoft\InputPersonalization"
Set-RegistryValue -Path $inkingPath -Name "RestrictImplicitTextCollection" -ValueType "DWord" -Value 0
Set-RegistryValue -Path $inkingPath -Name "RestrictImplicitInkCollection" -ValueType "DWord" -Value 0

# Enable Tailored Experiences
$tailoredPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
Set-RegistryValue -Path $tailoredPath -Name "TailoredExperiencesWithDiagnosticDataEnabled" -ValueType "DWord" -Value 1

Write-Host "Script execution completed."
pause
# Check if the script is run with administrative privileges
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "This script needs to be run as an Administrator."
    Exit
}

# Reset Group Policy settings to default
Write-Host "Resetting Group Policy settings to default..."

# Remove all policies set by Group Policy
Try {
    # Remove registry policies
    Remove-Item -Path "HKCU:\Software\Policies" -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "HKLM:\Software\Policies" -Recurse -ErrorAction SilentlyContinue

    # Remove Group Policy cache
    Remove-Item -Path "C:\Windows\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction SilentlyContinue

    # Refresh Group Policy
    gpupdate /force

    Write-Host "Group Policy settings have been reset to default. A system restart is recommended."
} Catch {
    Write-Host "Failed to reset Group Policy settings. Error: $_"
}

# Optional: Restart the computer to apply changes
# Restart-Computer -Force

Write-Host "Script execution completed."
pause
