# PowerShell script to diagnose and fix common causes of unexpected shutdowns

# Function to check for Windows Updates
function Check-WindowsUpdate {
    Write-Output "Checking for Windows Updates..."
    Install-Module PSWindowsUpdate -Force -Scope CurrentUser
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot
    Write-Output "Windows Updates checked and installed if available."
}

# Function to clean temporary files
function Clean-TempFiles {
    Write-Output "Cleaning temporary files..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force
    Write-Output "Temporary files cleaned."
}

# Function to run a malware scan using Windows Defender
function Run-MalwareScan {
    Write-Output "Running a malware scan..."
    Start-MpScan -ScanType QuickScan
    Write-Output "Malware scan completed."
}

# Function to check Event Viewer for critical errors
function Check-EventViewer {
    Write-Output "Checking Event Viewer for critical errors..."
    $events = Get-WinEvent -LogName System | Where-Object { $_.LevelDisplayName -eq "Critical" }
    if ($events.Count -gt 0) {
        Write-Output "Critical errors found in Event Viewer:"
        $events | Select-Object TimeCreated, Id, LevelDisplayName, Message
    } else {
        Write-Output "No critical errors found in Event Viewer."
    }
}

# Function to check disk for errors
function Check-Disk {
    Write-Output "Checking disk for errors..."
    chkdsk C: /f /r
    Write-Output "Disk check completed."
}

# Function to update drivers
function Update-Drivers {
    Write-Output "Updating drivers..."
    pnputil.exe /enum-devices /connected | ForEach-Object { $_.Split("`t")[0] } | ForEach-Object { pnputil.exe /add-driver $_ /install }
    Write-Output "Drivers updated."
}

# Main script execution
Check-WindowsUpdate
Clean-TempFiles
Run-MalwareScan
Check-EventViewer
Check-Disk
Update-Drivers

Write-Output "All checks and updates completed. Please restart your computer."
