# Check for administrative privileges
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

# Function to reset Local Group Policy
function Reset-LocalGroupPolicy {
    Write-Output "Resetting Local Group Policy..."

    # Stop Group Policy Client service
    Write-Output "Stopping Group Policy Client service..."
    Start-Service -Name gpsvc

    # Remove local group policy folders
    Write-Output "Removing Local Group Policy folders..."
    Remove-Item -Path "C:\Windows\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction SilentlyContinue

    # Restart Group Policy Client service
    Write-Output "Restarting Group Policy Client service..."
    

    Write-Output "Local Group Policy has been reset to default."
}

# Function to reset Group Policy
function Reset-GroupPolicy {
    Write-Output "Resetting Group Policy..."

    # Remove Group Policy registry keys
    Write-Output "Removing Group Policy registry keys..."
    Remove-Item -Path "HKLM:\SOFTWARE\Policies" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "HKCU:\SOFTWARE\Policies" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects" -Recurse -Force -ErrorAction SilentlyContinue
	reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" /f

	reg delete "HKCU\Software\Microsoft\WindowsSelfHost" /f

	reg delete "HKCU\Software\Policies" /f

	reg delete "HKLM\Software\Microsoft\Policies" /f

	reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies" /f

	reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /f

	reg delete "HKLM\Software\Microsoft\WindowsSelfHost" /f

	reg delete "HKLM\Software\Policies" /f

	reg delete "HKLM\Software\WOW6432Node\Microsoft\Policies" /f

	reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Policies" /f

	reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /f 
	# Disable Windows Defender settings managed by organization
	Set-MpPreference -DisableRealtimeMonitoring $false
	Set-MpPreference -DisableBehaviorMonitoring $false
	Set-MpPreference -DisableIOAVProtection $false
	Set-MpPreference -DisablePrivacyMode $false
	Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $false
	Set-MpPreference -DisableArchiveScanning $false
    Write-Output "Group Policy has been reset to default."
}

# Reset Local Group Policy
Reset-LocalGroupPolicy

# Reset Group Policy
Reset-GroupPolicy

# Refresh group policy
Write-Output "Refreshing Group Policy..."
gpupdate /force

Write-Output "All policies have been reset to Windows 11 defaults."
