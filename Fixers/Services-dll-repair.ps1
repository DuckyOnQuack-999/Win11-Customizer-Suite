# ============================================
# PowerShell Script to Reset Windows 11 Services and Manage DLLs
# ============================================

# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script.`nPlease run this script as an Administrator!"
    Exit
}

# Define a hashtable with Service Names as keys and their Default Startup Types as values
$defaultServices = @{
    "wuauserv"   = "Automatic"  # Windows Update
    "eventlog"   = "Automatic"  # Windows Event Log
    "rpcss"      = "Automatic"  # Remote Procedure Call (RPC)
    "DcomLaunch" = "Automatic"  # DCOM Server Process Launcher
    "SamSs"      = "Automatic"  # Security Accounts Manager
    "Winmgmt"    = "Automatic"  # Windows Management Instrumentation
    "NlaSvc"     = "Automatic"  # Network Location Awareness
    "w32time"    = "Automatic"  # Windows Time
    "ProfSvc"    = "Automatic"  # User Profile Service
    "MpsSvc"     = "Automatic"  # Windows Defender Firewall
    "Spooler"    = "Automatic"  # Print Spooler
    "SysMain"    = "Automatic"  # SysMain (Superfetch)
    "msiserver"  = "Manual"     # Windows Installer
    "bthserv"    = "Manual"     # Bluetooth Support Service
    "WSearch"    = "Automatic"  # Windows Search
    "PlugPlay"   = "Automatic"  # Plug and Play
    "Appinfo"    = "Manual"     # Application Information
    "WinDefend"  = "Automatic"  # Windows Defender Antivirus Service
    "DefenderAdvancedThreatProtectionService" = "Automatic" # Windows Defender ATP
    # Add more services as needed below
}

# Function to set the startup type of a service
function Set-ServiceStartupType {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,

        [Parameter(Mandatory=$true)]
        [ValidateSet("Automatic", "Manual", "Disabled")]
        [string]$StartupType
    )

    try {
        # Use CIM to change the startup type (instead of WMI)
        $service = Get-CimInstance -ClassName Win32_Service -Filter "Name='$ServiceName'"
        if ($null -ne $service) {
            $result = Invoke-CimMethod -InputObject $service -MethodName ChangeStartMode -Arguments @{StartMode=$StartupType}
            if ($result.ReturnValue -eq 0) {
                Write-Host "✅ Successfully set '$ServiceName' to '$StartupType'."
            }
            else {
                Write-Warning "⚠️ Failed to set '$ServiceName' to '$StartupType'. Return Code: $($result.ReturnValue)"
            }
        }
        else {
            Write-Warning "⚠️ Service '$ServiceName' not found."
        }
    }
    catch {
        Write-Error "❌ Error setting '$ServiceName' to '$StartupType': $_"
    }
}

# Function to register a DLL
function Register-Dll {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DllPath
    )

    try {
        Write-Host "Registering $DllPath ..."
        Start-Process "regsvr32.exe" -ArgumentList "/s", "`"$DllPath`"" -Wait -NoNewWindow
        Write-Host "✅ Successfully registered $DllPath"
    }
    catch {
        Write-Error "❌ Failed to register ${DllPath}: $_"
    }
}

# Function to unregister a DLL
function Unregister-Dll {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DllPath
    )

    try {
        Write-Host "Unregistering $DllPath ..."
        Start-Process "regsvr32.exe" -ArgumentList "/u /s", "`"$DllPath`"" -Wait -NoNewWindow
        Write-Host "✅ Successfully unregistered ${DllPath}"
    }
    catch {
        Write-Error "❌ Failed to unregister ${DllPath}: $_"
    }
}

# Function to reset services to their default startup types
function Reset-Services {
    foreach ($service in $defaultServices.GetEnumerator()) {
        Write-Host "Configuring Service: $($service.Key) => Startup Type: $($service.Value)"
        Set-ServiceStartupType -ServiceName $service.Key -StartupType $service.Value
    }
    Write-Host "`n📄 Service Startup Types have been reset to default settings.`n"

    # Prompt user to restart the system for changes to take effect
    $restart = Read-Host "Would you like to restart your computer now to apply the changes? (Y/N)"
    if ($restart -eq 'Y') {
        Restart-Computer
    }
    else {
        Write-Host "Please restart your computer manually for all changes to take effect."
    }
}

# Function to prompt user for DLL paths
function Get-DllPaths {
    param (
        [Parameter(Mandatory=$false)]
        [string]$PromptMessage = "Enter the full paths of DLL files separated by commas:"
    )
    
    $inputPaths = Read-Host $PromptMessage
    $dllPaths = $inputPaths -split ',' | ForEach-Object { $_.Trim() }
    
    if ($dllPaths.Count -eq 0) {
        Write-Warning "No DLLs were provided."
        return $null
    }

    return $dllPaths
}

# Function to manage DLLs (register or unregister)
function Manage-DLLs {
    $dllChoice = Read-Host "Do you want to register or unregister the DLLs? (Enter 'register' or 'unregister')"
    $dllPaths = Get-DllPaths

    if ($null -eq $dllPaths) {
        Write-Warning "No DLL paths were provided, aborting operation."
        return
    }

    if ($dllChoice -eq 'register') {
        foreach ($dll in $dllPaths) {
            Register-Dll -DllPath $dll
        }
    }
    elseif ($dllChoice -eq 'unregister') {
        foreach ($dll in $dllPaths) {
            Unregister-Dll -DllPath $dll
        }
    }
    else {
        Write-Warning "Invalid option selected. Please enter either 'register' or 'unregister'."
    }
}

# Main menu
Write-Host "What would you like to do?"
Write-Host "1. Reset Windows services to default"
Write-Host "2. Register or Unregister DLLs"
$choice = Read-Host "Enter the number of your choice"

switch ($choice) {
    1 {
        Reset-Services
    }
    2 {
        Manage-DLLs
    }
    default {
        Write-Host "Invalid choice. Please run the script again and select a valid option."
    }
}

Write-Host "`nOperation completed."
