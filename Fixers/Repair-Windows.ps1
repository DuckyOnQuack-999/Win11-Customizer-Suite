# Elevate the script to run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as an Administrator."
    Start-Process powershell -ArgumentList ("-File", $MyInvocation.MyCommand.Path) -Verb RunAs
    Exit
}

# Function to log error messages
function Log-Error {
    param (
        [string]$Message
    )
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

# Function to log informational messages
function Log-Info {
    param (
        [string]$Message
    )
    Write-Host "INFO: $Message" -ForegroundColor Green
}

# Function to ensure a registry path exists
function Ensure-RegistryPathExists {
    param (
        [string]$Path
    )
    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
            Log-Info "Created registry path: $Path"
        } else {
            Log-Info "Registry path already exists: $Path"
        }
    } catch {
        Log-Error "Failed to create registry path ${Path}: $_"
    }
}

# Remove Group Policy folders with error handling
Log-Info "Removing Group Policy Folders..."
try {
    if (Test-Path "$env:WinDir\System32\GroupPolicyUsers") {
        Remove-Item -Path "$env:WinDir\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction Stop
        Log-Info "Removed GroupPolicyUsers folder successfully."
    } else {
        Log-Info "GroupPolicyUsers folder does not exist."
    }
} catch {
    Log-Error "Failed to remove GroupPolicyUsers: $_"
}

try {
    if (Test-Path "$env:WinDir\System32\GroupPolicy") {
        Remove-Item -Path "$env:WinDir\System32\GroupPolicy" -Recurse -Force -ErrorAction Stop
        Log-Info "Removed GroupPolicy folder successfully."
    } else {
        Log-Info "GroupPolicy folder does not exist."
    }
} catch {
    Log-Error "Failed to remove GroupPolicy: $_"
}

# Force update Group Policy
Log-Info "Updating Group Policy..."
try {
    gpupdate /force
    Log-Info "Group Policy updated successfully."
} catch {
    Log-Error "Failed to update Group Policy: $_"
}

# Delete registry keys related to policies with error handling
Log-Info "Deleting registry keys related to policies..."
$regPaths = @(
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies",
    "HKCU\Software\Policies",
    "HKLM\Software\Microsoft\Policies",
    "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies",
    "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate",
    "HKLM\Software\Policies",
    "HKLM\Software\WOW6432Node\Microsoft\Policies",
    "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Policies",
    "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate"
)

foreach ($regPath in $regPaths) {
    try {
        if (Test-Path $regPath) {
            reg delete $regPath /f
            Log-Info "Deleted $regPath successfully."
        } else {
            Log-Info "$regPath does not exist."
        }
    } catch {
        Log-Error "Failed to delete {$regPath}: $_"
    }
}

# Restore Settings / Apps / Startup page with error handling
Log-Info "Restoring startup settings..."
$startupRegEntries = @(
    @{Path="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; Name="SupportUwpStartupTasks"; Type="REG_DWORD"; Value=1},
    @{Path="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; Name="EnableFullTrustStartupTasks"; Type="REG_DWORD"; Value=2},
    @{Path="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; Name="EnableUwpStartupTasks"; Type="REG_DWORD"; Value=2},
    @{Path="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; Name="SupportFullTrustStartupTasks"; Type="REG_DWORD"; Value=1}
)

# Ensure the parent registry path exists before creating the entries
$parentPath = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Ensure-RegistryPathExists -Path $parentPath

foreach ($entry in $startupRegEntries) {
    try {
        New-ItemProperty -Path $entry.Path -Name $entry.Name -PropertyType $entry.Type -Value $entry.Value -Force | Out-Null
        Log-Info "Restored $($entry.Name) in $($entry.Path) successfully."
    } catch {
        Log-Error "Failed to restore $($entry.Name) in $($entry.Path): $_"
    }
}

# Run System File Checker (SFC) with error handling
Log-Info "Running System File Checker (SFC)..."
try {
    sfc /scannow
    Log-Info "System File Checker (SFC) completed."
} catch {
    Log-Error "Failed to run SFC: $_"
}

# Use DISM to restore system health with error handling
Log-Info "Running DISM to restore system health..."
try {
    dism /online /cleanup-image /restorehealth
    Log-Info "DISM completed successfully."
} catch {
    Log-Error "Failed to run DISM: $_"
}

# Run SFC again after DISM with error handling
Log-Info "Running System File Checker (SFC) again..."
try {
    sfc /scannow
    Log-Info "System File Checker (SFC) completed successfully."
} catch {
    Log-Error "Failed to run SFC the second time: $_"
}

Log-Info "Windows repair operations completed."
