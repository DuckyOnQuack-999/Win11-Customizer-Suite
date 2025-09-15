# PowerShell Script to Repair Windows 11 Components
# ------------------------------------------------------------
# Enhanced Version with Select All, Deselect All, Apply, Cancel Buttons,
# Progress Bar on the Left, and a Console-like TextBox for Status Messages
# Improved Layout to Ensure All Controls Are Visible
# ------------------------------------------------------------

# ------------------------------------------------------------
# Warning: This script makes significant changes to your system.
# Ensure you have backups and restore points before proceeding.
# ------------------------------------------------------------

# Define Log File Path
$logFile = "$env:USERPROFILE\Desktop\Windows11RepairLog.txt"

# Initialize Log File
if (-Not (Test-Path -Path $logFile)) {
    New-Item -Path $logFile -ItemType File -Force | Out-Null
} else {
    # Archive old log file to prevent bloat
    Rename-Item -Path $logFile -NewName "$logFile.old_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -Path $logFile -ItemType File -Force | Out-Null
}

# Function to Log Messages
Function Write-Log {
    Param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $Message"
    # Update the console TextBox if it exists and is not disposed
    if ($consoleBox -and !$consoleBox.IsDisposed) {
        $consoleBox.Invoke([System.Action[string]]{ param($msg) $consoleBox.AppendText("$msg`r`n") }, "$timestamp - $Message")
    }
}

# Start Logging
Write-Log "Windows 11 Repair Script Started."

# Elevate the script if not running as Administrator
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator."
    Write-Log "Script not run as Administrator. Exiting."
    [System.Windows.Forms.MessageBox]::Show("This script must be run as Administrator.", "Insufficient Privileges", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    Exit
}

# Backup Important Data Warning
Write-Log "Ensuring backups are in place and informing the user."
[System.Windows.Forms.MessageBox]::Show("Ensure you have backed up your important data before proceeding.", "Backup Reminder", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Initialize GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 11 Repair Tool"
$form.Size = New-Object System.Drawing.Size(1000,800)  # Increased height to 800
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Instruction Label
$instructionLabel = New-Object System.Windows.Forms.Label
$instructionLabel.Size = New-Object System.Drawing.Size(960,60)
$instructionLabel.Location = New-Object System.Drawing.Point(20,10)
$instructionLabel.Text = "Select the repair tasks you want to perform. It is highly recommended to backup your important data before proceeding."
$instructionLabel.AutoSize = $false
$instructionLabel.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Regular)
$instructionLabel.TextAlign = "MiddleLeft"
$form.Controls.Add($instructionLabel)

# Panel for Checkboxes and Control Buttons (Left Side)
$leftPanel = New-Object System.Windows.Forms.Panel
$leftPanel.Size = New-Object System.Drawing.Size(480,580)  # Increased height
$leftPanel.Location = New-Object System.Drawing.Point(20,80)
$leftPanel.BorderStyle = 'FixedSingle'
$leftPanel.AutoScroll = $false  # Disabled AutoScroll for better control
$form.Controls.Add($leftPanel)

# Container for Checkboxes with Scrolling
$checkboxContainer = New-Object System.Windows.Forms.Panel
$checkboxContainer.Size = New-Object System.Drawing.Size(460,520)  # Slight padding
$checkboxContainer.Location = New-Object System.Drawing.Point(10,10)
$checkboxContainer.AutoScroll = $true
$leftPanel.Controls.Add($checkboxContainer)

# Checkbox List for Repair Tasks
$checkboxes = @()
$tasks = @(
    "Reset Local Group Policy",
    "Reset Windows Services",
    "Reset Appx Packages",
    "Reset Winsock",
    "Reset Firewall Settings",
    "Reset Network Settings",
    "Reset Hosts File",
    "Reset Windows Update Components",
    "Reset Windows Defender",
    "Rebuild Windows Search Index",
    "Reset Windows Store",
    "Clean Temporary Files",
    "Repair Microsoft Edge",
    "Re-register All Windows DLLs",
    "Re-register All Windows Services DLLs",
    "Repair Windows Defender Firewall",
    "Run SFC and DISM Scans"
)
$yPos = 10
foreach ($task in $tasks) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Text = $task
    $checkbox.Size = New-Object System.Drawing.Size(440,20)  # Increased width
    $checkbox.Location = New-Object System.Drawing.Point(10,$yPos)
    $checkbox.Checked = $false
    $checkbox.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)
    $checkboxContainer.Controls.Add($checkbox)
    $checkboxes += $checkbox
    $yPos += 30
}

# Container for Select All and Deselect All Buttons
$buttonContainer = New-Object System.Windows.Forms.Panel
$buttonContainer.Size = New-Object System.Drawing.Size(460,50)
$buttonContainer.Location = New-Object System.Drawing.Point(10,540)  # Positioned below the checkboxContainer
$leftPanel.Controls.Add($buttonContainer)

# Select All Button
$selectAllButton = New-Object System.Windows.Forms.Button
$selectAllButton.Text = "Select All"
$selectAllButton.Size = New-Object System.Drawing.Size(120,35)
$selectAllButton.Location = New-Object System.Drawing.Point(0,5)  # Positioned at the left within buttonContainer
$selectAllButton.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)
$buttonContainer.Controls.Add($selectAllButton)

# Deselect All Button
$deselectAllButton = New-Object System.Windows.Forms.Button
$deselectAllButton.Text = "Deselect All"
$deselectAllButton.Size = New-Object System.Drawing.Size(120,35)
$deselectAllButton.Location = New-Object System.Drawing.Point(140,5)  # Positioned to the right within buttonContainer
$deselectAllButton.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)
$buttonContainer.Controls.Add($deselectAllButton)

# Event for Select All Button
$selectAllButton.Add_Click({
    foreach ($cb in $checkboxes) {
        $cb.Checked = $true
    }
    Write-Log "All repair tasks selected by user."
    $consoleBox.AppendText("All repair tasks selected by user.`r`n")
})

# Event for Deselect All Button
$deselectAllButton.Add_Click({
    foreach ($cb in $checkboxes) {
        $cb.Checked = $false
    }
    Write-Log "All repair tasks deselected by user."
    $consoleBox.AppendText("All repair tasks deselected by user.`r`n")
})

# Panel for Progress and Console (Right Side)
$rightPanel = New-Object System.Windows.Forms.Panel
$rightPanel.Size = New-Object System.Drawing.Size(500,580)  # Adjusted size
$rightPanel.Location = New-Object System.Drawing.Point(520,80)
$rightPanel.BorderStyle = 'FixedSingle'
$form.Controls.Add($rightPanel)

# Progress Label
$progressLabel = New-Object System.Windows.Forms.Label
$progressLabel.Size = New-Object System.Drawing.Size(480,25)
$progressLabel.Location = New-Object System.Drawing.Point(10,10)
$progressLabel.Text = "Progress:"
$progressLabel.AutoSize = $false
$progressLabel.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)
$progressLabel.TextAlign = "MiddleLeft"
$rightPanel.Controls.Add($progressLabel)

# Progress Bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(480,30)
$progressBar.Location = New-Object System.Drawing.Point(10,45)
$progressBar.Minimum = 0
$progressBar.Maximum = ($tasks.Count)
$progressBar.Step = 1
$rightPanel.Controls.Add($progressBar)

# Console-like TextBox
$consoleBox = New-Object System.Windows.Forms.TextBox
$consoleBox.Multiline = $true
$consoleBox.ScrollBars = 'Vertical'
$consoleBox.Size = New-Object System.Drawing.Size(480,400)
$consoleBox.Location = New-Object System.Drawing.Point(10,90)
$consoleBox.ReadOnly = $true
$consoleBox.BackColor = 'Black'
$consoleBox.ForeColor = 'White'
$consoleBox.Font = New-Object System.Drawing.Font("Consolas",10)
$rightPanel.Controls.Add($consoleBox)

# Buttons Panel at the Bottom
$buttonsPanel = New-Object System.Windows.Forms.Panel
$buttonsPanel.Size = New-Object System.Drawing.Size(960,60)  # Adjusted size
$buttonsPanel.Location = New-Object System.Drawing.Point(20,700)  # Positioned within the form
$buttonsPanel.BorderStyle = 'None'
$form.Controls.Add($buttonsPanel)

# Apply Button
$applyButton = New-Object System.Windows.Forms.Button
$applyButton.Text = "Apply"
$applyButton.Size = New-Object System.Drawing.Size(120,40)
$applyButton.Location = New-Object System.Drawing.Point(720,10)
$applyButton.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)
$buttonsPanel.Controls.Add($applyButton)

# Cancel Button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Size = New-Object System.Drawing.Size(120,40)
$cancelButton.Location = New-Object System.Drawing.Point(860,10)
$cancelButton.Enabled = $false
$cancelButton.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)
$buttonsPanel.Controls.Add($cancelButton)

# Flag to indicate cancellation
$global:CancelRequested = $false

# Cancel Button Event
$cancelButton.Add_Click({
    if ($CancelRequested) {
        Write-Host "Cancellation requested by user."
    } = $true
    Write-Log "Cancellation requested by user."
    $consoleBox.AppendText("Cancellation requested by user.`r`n")
    $progressLabel.Text = "Cancelling..."
})

# Function to Update Progress
Function Update-ProgressWindow {
    Param (
        [string]$StatusMessage
    )
    $progressLabel.Invoke([action]{ param($msg) $progressLabel.Text = "Progress: $msg" }, $StatusMessage)
    $progressBar.Invoke([action]{ $progressBar.PerformStep() })
    Write-Log $StatusMessage
}

# Function to Check for Cancellation
Function Check-Cancellation {
    if ($global:CancelRequested) {
        Write-Log "Operation cancelled by user."
        $consoleBox.AppendText("Operation cancelled by user.`r`n")
        throw "Operation cancelled by user."
    }
}

# Function to Backup Critical Files
Function Backup-CriticalFiles {
    Update-ProgressWindow -StatusMessage "Backing up critical files..."
    $consoleBox.AppendText("Backing up critical files...`r`n")
    $backupPath = "$env:USERPROFILE\Desktop\Windows11RepairBackup"
    if (-Not (Test-Path -Path $backupPath)) {
        New-Item -Path $backupPath -ItemType Directory | Out-Null
        Write-Log "Created backup directory at $backupPath."
        $consoleBox.AppendText("Created backup directory at $backupPath.`r`n")
    }
    # Backup Hosts File
    $hostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"
    $hostsBackupPath = "$backupPath\hosts.backup"
    Try {
        Copy-Item -Path $hostsFilePath -Destination $hostsBackupPath -Force -ErrorAction Stop
        Write-Log "Hosts file backed up to $hostsBackupPath."
        $consoleBox.AppendText("Hosts file backed up to $hostsBackupPath.`r`n")
    }
    Catch {
        Write-Log "Error backing up Hosts file: $_"
        $consoleBox.AppendText("Error backing up Hosts file: $_`r`n")
    }
}

# Function to Reset Local Group Policy
Function Reset-LocalGroupPolicy {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Local Group Policy..."
    $consoleBox.AppendText("Resetting Local Group Policy...`r`n")
    Try {
        # Delete the contents of the Group Policy folders
        Remove-Item -Path "$env:windir\System32\GroupPolicy\*" -Recurse -Force -ErrorAction Stop
        Remove-Item -Path "$env:windir\System32\GroupPolicyUsers\*" -Recurse -Force -ErrorAction Stop
        # Refresh Group Policy
        gpupdate /force | Out-Null
        Write-Log "Local Group Policy reset successfully."
        $consoleBox.AppendText("Local Group Policy reset successfully.`r`n")
    }
    Catch {
        Write-Log "Error resetting Local Group Policy: $_"
        $consoleBox.AppendText("Error resetting Local Group Policy: $_`r`n")
    }
}

# Function to Reset All Windows Services to Default
Function Reset-WindowsServices {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Windows Services to default settings..."
    $consoleBox.AppendText("Resetting Windows Services to default settings...`r`n")
    Try {
        # List of critical services to reset
        $services = @(
            'wuauserv',           # Windows Update
            'bits',               # Background Intelligent Transfer Service
            'Dhcp',               # DHCP Client
            'Dnscache',           # DNS Client
            'lmhosts',            # TCP/IP NetBIOS Helper
            'Winmgmt',            # Windows Management Instrumentation
            'EventLog',           # Windows Event Log
            'CryptSvc',           # Cryptographic Services
            'RpcSs',              # Remote Procedure Call (RPC)
            'DcomLaunch',         # DCOM Server Process Launcher
            'PlugPlay',           # Plug and Play
            'SystemEventsBroker', # System Events Broker
            'BFE',                # Base Filtering Engine
            'mpssvc'              # Windows Firewall
        )
    
        foreach ($service in $services) {
            Check-Cancellation
            Try {
                sc.exe config $service start= auto | Out-Null
                Start-Service $service -ErrorAction SilentlyContinue
                Write-Log "Service '$service' set to automatic and started."
                $consoleBox.AppendText("Service '$service' set to automatic and started.`r`n")
            }
            Catch {
                Write-Log "Error resetting service '$service': $_"
                $consoleBox.AppendText("Error resetting service '$service': $_`r`n")
            }
        }
    }
    Catch {
        Write-Log "Error in Reset-WindowsServices: $_"
        $consoleBox.AppendText("Error in Reset-WindowsServices: $_`r`n")
    }
}

# Function to Reset Appx Packages
Function Reset-AppxPackages {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Reinstalling and re-registering all built-in Windows apps..."
    $consoleBox.AppendText("Reinstalling and re-registering all built-in Windows apps...`r`n")
    Try {
        # Remove all Appx packages for current user
        Get-AppxPackage | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-Log "All user Appx packages removed."
        $consoleBox.AppendText("All user Appx packages removed.`r`n")
        # Reinstall default Appx packages
        $appManifests = Get-ChildItem "$env:windir\SystemApps" -Filter AppxManifest.xml -Recurse -ErrorAction SilentlyContinue
        foreach ($manifest in $appManifests) {
            Check-Cancellation
            Try {
                Add-AppxPackage -DisableDevelopmentMode -Register $manifest.FullName -ForceApplicationShutdown -ErrorAction SilentlyContinue
                Write-Log "Re-registered Appx package from $($manifest.FullName)."
                $consoleBox.AppendText("Re-registered Appx package from $($manifest.FullName).`r`n")
            }
            Catch {
                Write-Log "Error re-registering Appx package from $($manifest.FullName): $_"
                $consoleBox.AppendText("Error re-registering Appx package from $($manifest.FullName): $_`r`n")
            }
        }
    }
    Catch {
        Write-Log "Error in Reset-AppxPackages: $_"
        $consoleBox.AppendText("Error in Reset-AppxPackages: $_`r`n")
    }
}

# Function to Reset Winsock
Function Reset-Winsock {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Winsock catalog..."
    $consoleBox.AppendText("Resetting Winsock catalog...`r`n")
    Try {
        netsh winsock reset | Out-Null
        netsh int ip reset | Out-Null
        Write-Log "Winsock and IP settings reset."
        $consoleBox.AppendText("Winsock and IP settings reset.`r`n")
    }
    Catch {
        Write-Log "Error resetting Winsock/IP settings: $_"
        $consoleBox.AppendText("Error resetting Winsock/IP settings: $_`r`n")
    }
}

# Function to Reset Firewall Settings
Function Reset-FirewallSettings {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Windows Firewall settings..."
    $consoleBox.AppendText("Resetting Windows Firewall settings...`r`n")
    Try {
        netsh advfirewall reset | Out-Null
        Write-Log "Windows Firewall settings reset."
        $consoleBox.AppendText("Windows Firewall settings reset.`r`n")
    }
    Catch {
        Write-Log "Error resetting Firewall settings: $_"
        $consoleBox.AppendText("Error resetting Firewall settings: $_`r`n")
    }
}

# Function to Reset Network Settings
Function Reset-NetworkSettings {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting network settings..."
    $consoleBox.AppendText("Resetting network settings...`r`n")
    Try {
        netsh int ip reset | Out-Null
        netsh winsock reset | Out-Null
        ipconfig /release | Out-Null
        ipconfig /renew | Out-Null
        ipconfig /flushdns | Out-Null
        Write-Log "Network settings reset and IP configuration refreshed."
        $consoleBox.AppendText("Network settings reset and IP configuration refreshed.`r`n")
    }
    Catch {
        Write-Log "Error resetting Network settings: $_"
        $consoleBox.AppendText("Error resetting Network settings: $_`r`n")
    }
}

# Function to Reset Hosts File to Default
Function Reset-HostsFile {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Hosts file to default..."
    $consoleBox.AppendText("Resetting Hosts file to default...`r`n")
    Try {
        $hostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"
        $backupPath = "$env:USERPROFILE\Desktop\Windows11RepairBackup\hosts.backup"
        if (-Not (Test-Path -Path $backupPath)) {
            Copy-Item -Path $hostsFilePath -Destination $backupPath -Force -ErrorAction Stop
            Write-Log "Hosts file backed up to $backupPath."
            $consoleBox.AppendText("Hosts file backed up to $backupPath.`r`n")
        }
        $defaultHostsContent = @"
# Copyright (c) 1993-2006 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# [Rest of the default hosts file content]
127.0.0.1       localhost
::1             localhost
"@

        # Overwrite the hosts file
        $defaultHostsContent | Set-Content -Path $hostsFilePath -Encoding ASCII -Force
        Write-Log "Hosts file reset to default."
        $consoleBox.AppendText("Hosts file reset to default.`r`n")
    }
    Catch {
        Write-Log "Error resetting Hosts file: $_"
        $consoleBox.AppendText("Error resetting Hosts file: $_`r`n")
    }
}

# Function to Update Progress
Function Update-ProgressWindow {
    Param (
        [string]$StatusMessage
    )
    $progressLabel.Invoke([action]{ param($msg) $progressLabel.Text = "Progress: $msg" }, $StatusMessage)
    $progressBar.Invoke([action]{ $progressBar.PerformStep() })
    Write-Log $StatusMessage
}

# Function to Check for Cancellation
Function Check-Cancellation {
    if ($global:CancelRequested) {
        Write-Log "Operation cancelled by user."
        $consoleBox.AppendText("Operation cancelled by user.`r`n")
        throw "Operation cancelled by user."
    }
}

# Function to Backup Critical Files
Function Backup-CriticalFiles {
    Update-ProgressWindow -StatusMessage "Backing up critical files..."
    $consoleBox.AppendText("Backing up critical files...`r`n")
    $backupPath = "$env:USERPROFILE\Desktop\Windows11RepairBackup"
    if (-Not (Test-Path -Path $backupPath)) {
        New-Item -Path $backupPath -ItemType Directory | Out-Null
        Write-Log "Created backup directory at $backupPath."
        $consoleBox.AppendText("Created backup directory at $backupPath.`r`n")
    }
    # Backup Hosts File
    $hostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"
    $hostsBackupPath = "$backupPath\hosts.backup"
    Try {
        Copy-Item -Path $hostsFilePath -Destination $hostsBackupPath -Force -ErrorAction Stop
        Write-Log "Hosts file backed up to $hostsBackupPath."
        $consoleBox.AppendText("Hosts file backed up to $hostsBackupPath.`r`n")
    }
    Catch {
        Write-Log "Error backing up Hosts file: $_"
        $consoleBox.AppendText("Error backing up Hosts file: $_`r`n")
    }
}

# Function to Reset Local Group Policy
Function Reset-LocalGroupPolicy {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Local Group Policy..."
    $consoleBox.AppendText("Resetting Local Group Policy...`r`n")
    Try {
        # Delete the contents of the Group Policy folders
        Remove-Item -Path "$env:windir\System32\GroupPolicy\*" -Recurse -Force -ErrorAction Stop
        Remove-Item -Path "$env:windir\System32\GroupPolicyUsers\*" -Recurse -Force -ErrorAction Stop
        # Refresh Group Policy
        gpupdate /force | Out-Null
        Write-Log "Local Group Policy reset successfully."
        $consoleBox.AppendText("Local Group Policy reset successfully.`r`n")
    }
    Catch {
        Write-Log "Error resetting Local Group Policy: $_"
        $consoleBox.AppendText("Error resetting Local Group Policy: $_`r`n")
    }
}

# Function to Reset All Windows Services to Default
Function Reset-WindowsServices {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Windows Services to default settings..."
    $consoleBox.AppendText("Resetting Windows Services to default settings...`r`n")
    Try {
        # List of critical services to reset
        $services = @(
            'wuauserv',           # Windows Update
            'bits',               # Background Intelligent Transfer Service
            'Dhcp',               # DHCP Client
            'Dnscache',           # DNS Client
            'lmhosts',            # TCP/IP NetBIOS Helper
            'Winmgmt',            # Windows Management Instrumentation
            'EventLog',           # Windows Event Log
            'CryptSvc',           # Cryptographic Services
            'RpcSs',              # Remote Procedure Call (RPC)
            'DcomLaunch',         # DCOM Server Process Launcher
            'PlugPlay',           # Plug and Play
            'SystemEventsBroker', # System Events Broker
            'BFE',                # Base Filtering Engine
            'mpssvc'              # Windows Firewall
        )
    
        foreach ($service in $services) {
            Check-Cancellation
            Try {
                sc.exe config $service start= auto | Out-Null
                Start-Service $service -ErrorAction SilentlyContinue
                Write-Log "Service '$service' set to automatic and started."
                $consoleBox.AppendText("Service '$service' set to automatic and started.`r`n")
            }
            Catch {
                Write-Log "Error resetting service '$service': $_"
                $consoleBox.AppendText("Error resetting service '$service': $_`r`n")
            }
        }
    }
    Catch {
        Write-Log "Error in Reset-WindowsServices: $_"
        $consoleBox.AppendText("Error in Reset-WindowsServices: $_`r`n")
    }
}

# Function to Reset Appx Packages
Function Reset-AppxPackages {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Reinstalling and re-registering all built-in Windows apps..."
    $consoleBox.AppendText("Reinstalling and re-registering all built-in Windows apps...`r`n")
    Try {
        # Remove all Appx packages for current user
        Get-AppxPackage | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-Log "All user Appx packages removed."
        $consoleBox.AppendText("All user Appx packages removed.`r`n")
        # Reinstall default Appx packages
        $appManifests = Get-ChildItem "$env:windir\SystemApps" -Filter AppxManifest.xml -Recurse -ErrorAction SilentlyContinue
        foreach ($manifest in $appManifests) {
            Check-Cancellation
            Try {
                Add-AppxPackage -DisableDevelopmentMode -Register $manifest.FullName -ForceApplicationShutdown -ErrorAction SilentlyContinue
                Write-Log "Re-registered Appx package from $($manifest.FullName)."
                $consoleBox.AppendText("Re-registered Appx package from $($manifest.FullName).`r`n")
            }
            Catch {
                Write-Log "Error re-registering Appx package from $($manifest.FullName): $_"
                $consoleBox.AppendText("Error re-registering Appx package from $($manifest.FullName): $_`r`n")
            }
        }
    }
    Catch {
        Write-Log "Error in Reset-AppxPackages: $_"
        $consoleBox.AppendText("Error in Reset-AppxPackages: $_`r`n")
    }
}

# Function to Reset Winsock
Function Reset-Winsock {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Winsock catalog..."
    $consoleBox.AppendText("Resetting Winsock catalog...`r`n")
    Try {
        netsh winsock reset | Out-Null
        netsh int ip reset | Out-Null
        Write-Log "Winsock and IP settings reset."
        $consoleBox.AppendText("Winsock and IP settings reset.`r`n")
    }
    Catch {
        Write-Log "Error resetting Winsock/IP settings: $_"
        $consoleBox.AppendText("Error resetting Winsock/IP settings: $_`r`n")
    }
}

# Function to Reset Firewall Settings
Function Reset-FirewallSettings {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Windows Firewall settings..."
    $consoleBox.AppendText("Resetting Windows Firewall settings...`r`n")
    Try {
        netsh advfirewall reset | Out-Null
        Write-Log "Windows Firewall settings reset."
        $consoleBox.AppendText("Windows Firewall settings reset.`r`n")
    }
    Catch {
        Write-Log "Error resetting Firewall settings: $_"
        $consoleBox.AppendText("Error resetting Firewall settings: $_`r`n")
    }
}

# Function to Reset Network Settings
Function Reset-NetworkSettings {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting network settings..."
    $consoleBox.AppendText("Resetting network settings...`r`n")
    Try {
        netsh int ip reset | Out-Null
        netsh winsock reset | Out-Null
        ipconfig /release | Out-Null
        ipconfig /renew | Out-Null
        ipconfig /flushdns | Out-Null
        Write-Log "Network settings reset and IP configuration refreshed."
        $consoleBox.AppendText("Network settings reset and IP configuration refreshed.`r`n")
    }
    Catch {
        Write-Log "Error resetting Network settings: $_"
        $consoleBox.AppendText("Error resetting Network settings: $_`r`n")
    }
}

# Function to Reset Hosts File to Default
Function Reset-HostsFile {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Hosts file to default..."
    $consoleBox.AppendText("Resetting Hosts file to default...`r`n")
    Try {
        $hostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"
        $backupPath = "$env:USERPROFILE\Desktop\Windows11RepairBackup\hosts.backup"
        if (-Not (Test-Path -Path $backupPath)) {
            Copy-Item -Path $hostsFilePath -Destination $backupPath -Force -ErrorAction Stop
            Write-Log "Hosts file backed up to $backupPath."
            $consoleBox.AppendText("Hosts file backed up to $backupPath.`r`n")
        }
        $defaultHostsContent = @"
# Copyright (c) 1993-2006 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# [Rest of the default hosts file content]
127.0.0.1       localhost
::1             localhost
"@

        # Overwrite the hosts file
        $defaultHostsContent | Set-Content -Path $hostsFilePath -Encoding ASCII -Force
        Write-Log "Hosts file reset to default."
        $consoleBox.AppendText("Hosts file reset to default.`r`n")
    }
    Catch {
        Write-Log "Error resetting Hosts file: $_"
        $consoleBox.AppendText("Error resetting Hosts file: $_`r`n")
    }
}

# Function to Reset Windows Update Components
Function Reset-WindowsUpdateComponents {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Windows Update components..."
    $consoleBox.AppendText("Resetting Windows Update components...`r`n")
    Try {
        # Stop Windows Update services
        $servicesToStop = 'wuauserv', 'bits', 'cryptSvc', 'msiserver'
        foreach ($service in $servicesToStop) {
            Try {
                Stop-Service -Name $service -Force -ErrorAction Stop
                Write-Log "Stopped service '$service'."
                $consoleBox.AppendText("Stopped service '$service'.`r`n")
            }
            Catch {
                Write-Log "Error stopping service '$service': $_"
                $consoleBox.AppendText("Error stopping service '$service': $_`r`n")
            }
        }

        # Delete SoftwareDistribution and Catroot2 folders
        Try {
            Remove-Item -Path "$env:SystemRoot\SoftwareDistribution" -Recurse -Force -ErrorAction Stop
            Remove-Item -Path "$env:SystemRoot\System32\catroot2" -Recurse -Force -ErrorAction Stop
            Write-Log "Deleted SoftwareDistribution and Catroot2 folders."
            $consoleBox.AppendText("Deleted SoftwareDistribution and Catroot2 folders.`r`n")
        }
        Catch {
            Write-Log "Error deleting SoftwareDistribution or Catroot2 folders: $_"
            $consoleBox.AppendText("Error deleting SoftwareDistribution or Catroot2 folders: $_`r`n")
        }

        # Restart Windows Update services
        foreach ($service in $servicesToStop) {
            Try {
                Start-Service -Name $service -ErrorAction Stop
                Write-Log "Started service '$service'."
                $consoleBox.AppendText("Started service '$service'.`r`n")
            }
            Catch {
                Write-Log "Error starting service '$service': $_"
                $consoleBox.AppendText("Error starting service '$service': $_`r`n")
            }
        }
    }
    Catch {
        Write-Log "Error resetting Windows Update components: $_"
        $consoleBox.AppendText("Error resetting Windows Update components: $_`r`n")
    }
}

# Function to Reset Windows Defender Settings
Function Reset-WindowsDefender {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Windows Defender settings..."
    $consoleBox.AppendText("Resetting Windows Defender settings...`r`n")
    Try {
        # Reset Windows Defender settings to default
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "*" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager" -Name "*" -ErrorAction SilentlyContinue
        Write-Log "Windows Defender registry settings reset."
        $consoleBox.AppendText("Windows Defender registry settings reset.`r`n")

        # Restart Windows Defender services
        $defenderServices = 'WinDefend', 'SecurityHealthService'
        foreach ($service in $defenderServices) {
            Try {
                Set-Service -Name $service -StartupType Automatic -ErrorAction Stop
                Start-Service -Name $service -ErrorAction Stop
                Write-Log "Service '$service' set to automatic and started."
                $consoleBox.AppendText("Service '$service' set to automatic and started.`r`n")
            }
            Catch {
                Write-Log "Error restarting service '$service': $_"
                $consoleBox.AppendText("Error restarting service '$service': $_`r`n")
            }
        }
    }
    Catch {
        Write-Log "Error resetting Windows Defender: $_"
        $consoleBox.AppendText("Error resetting Windows Defender: $_`r`n")
    }
}

# Function to Rebuild Windows Search Index
Function Rebuild-WindowsSearchIndex {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Rebuilding Windows Search Index..."
    $consoleBox.AppendText("Rebuilding Windows Search Index...`r`n")
    Try {
        # Stop Windows Search service
        Stop-Service -Name WSearch -Force -ErrorAction SilentlyContinue
        Write-Log "Stopped Windows Search service."
        $consoleBox.AppendText("Stopped Windows Search service.`r`n")

        # Delete the search index files
        Try {
            Remove-Item -Path "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\*" -Recurse -Force -ErrorAction Stop
            Write-Log "Deleted Windows Search index files."
            $consoleBox.AppendText("Deleted Windows Search index files.`r`n")
        }
        Catch {
            Write-Log "Error deleting search index files: $_"
            $consoleBox.AppendText("Error deleting search index files: $_`r`n")
        }

        # Start Windows Search service
        Start-Service -Name WSearch -ErrorAction SilentlyContinue
        Write-Log "Started Windows Search service."
        $consoleBox.AppendText("Started Windows Search service.`r`n")
    }
    Catch {
        Write-Log "Error rebuilding Windows Search Index: $_"
        $consoleBox.AppendText("Error rebuilding Windows Search Index: $_`r`n")
    }
}

# Function to Reset Windows Store Components
Function Reset-WindowsStore {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Resetting Windows Store components..."
    $consoleBox.AppendText("Resetting Windows Store components...`r`n")
    Try {
        # Clear Windows Store cache
        Start-Process -FilePath "wsreset.exe" -Wait -ErrorAction SilentlyContinue
        Write-Log "Windows Store cache cleared."
        $consoleBox.AppendText("Windows Store cache cleared.`r`n")

        # Re-register Windows Store app
        Try {
            Get-AppxPackage -AllUsers Microsoft.WindowsStore | ForEach-Object {
                Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppxManifest.xml" -ErrorAction SilentlyContinue
                Write-Log "Re-registered Windows Store app."
                $consoleBox.AppendText("Re-registered Windows Store app.`r`n")
            }
        }
        Catch {
            Write-Log "Error re-registering Windows Store app: $_"
            $consoleBox.AppendText("Error re-registering Windows Store app: $_`r`n")
        }
    }
    Catch {
        Write-Log "Error resetting Windows Store components: $_"
        $consoleBox.AppendText("Error resetting Windows Store components: $_`r`n")
    }
}

# Function to Clean Temporary Files and Caches
Function Clean-TemporaryFiles {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Cleaning temporary files and caches..."
    $consoleBox.AppendText("Cleaning temporary files and caches...`r`n")
    Try {
        # Delete temporary files
        Try {
            Remove-Item -Path "$env:Temp\*" -Recurse -Force -ErrorAction Stop
            Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction Stop
            Write-Log "Temporary files deleted."
            $consoleBox.AppendText("Temporary files deleted.`r`n")
        }
        Catch {
            Write-Log "Error deleting temporary files: $_"
            $consoleBox.AppendText("Error deleting temporary files: $_`r`n")
        }

        # Clean up Windows Update cache
        Try {
            Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction Stop
            Write-Log "Windows Update cache cleaned."
            $consoleBox.AppendText("Windows Update cache cleaned.`r`n")
        }
        Catch {
            Write-Log "Error cleaning Windows Update cache: $_"
            $consoleBox.AppendText("Error cleaning Windows Update cache: $_`r`n")
        }
    }
    Catch {
        Write-Log "Error cleaning temporary files: $_"
        $consoleBox.AppendText("Error cleaning temporary files: $_`r`n")
    }
}

# Function to Repair Microsoft Edge
Function Repair-MicrosoftEdge {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Repairing Microsoft Edge..."
    $consoleBox.AppendText("Repairing Microsoft Edge...`r`n")
    Try {
        # Reinstall Microsoft Edge
        $edgePackage = Get-AppxPackage -AllUsers Microsoft.MicrosoftEdge.Stable
        if ($edgePackage) {
            Add-AppxPackage -DisableDevelopmentMode -Register "$($edgePackage.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue
            Write-Log "Microsoft Edge re-registered."
            $consoleBox.AppendText("Microsoft Edge re-registered.`r`n")
        }
        else {
            Write-Log "Microsoft Edge package not found."
            $consoleBox.AppendText("Microsoft Edge package not found.`r`n")
        }
    }
    Catch {
        Write-Log "Error repairing Microsoft Edge: $_"
        $consoleBox.AppendText("Error repairing Microsoft Edge: $_`r`n")
    }
}

# Function to Re-register All Windows DLLs
Function ReRegister-AllDLLs {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Re-registering all Windows DLLs..."
    $consoleBox.AppendText("Re-registering all Windows DLLs...`r`n")
    Try {
        $dlls = Get-ChildItem "$env:SystemRoot\System32\*.dll" -Recurse -ErrorAction SilentlyContinue
        foreach ($dll in $dlls) {
            Check-Cancellation
            Try {
                regsvr32.exe /s $dll.FullName
                Write-Log "Re-registered DLL: $($dll.FullName)"
                $consoleBox.AppendText("Re-registered DLL: $($dll.FullName)`r`n")
            }
            Catch {
                Write-Log "Error re-registering DLL '$($dll.FullName)': $_"
                $consoleBox.AppendText("Error re-registering DLL '$($dll.FullName)': $_`r`n")
            }
        }
    }
    Catch {
        Write-Log "Error in ReRegister-AllDLLs: $_"
        $consoleBox.AppendText("Error in ReRegister-AllDLLs: $_`r`n")
    }
}

# Function to Re-register All Windows Services DLLs
Function ReRegister-AllServiceDLLs {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Re-registering all Windows Services DLLs..."
    $consoleBox.AppendText("Re-registering all Windows Services DLLs...`r`n")
    Try {
        $serviceDLLs = Get-ChildItem "$env:SystemRoot\System32\*.dll" -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*service*.dll" }
        foreach ($dll in $serviceDLLs) {
            Check-Cancellation
            Try {
                regsvr32.exe /s $dll.FullName
                Write-Log "Re-registered Service DLL: $($dll.FullName)"
                $consoleBox.AppendText("Re-registered Service DLL: $($dll.FullName)`r`n")
            }
            Catch {
                Write-Log "Error re-registering Service DLL '$($dll.FullName)': $_"
                $consoleBox.AppendText("Error re-registering Service DLL '$($dll.FullName)': $_`r`n")
            }
        }
    }
    Catch {
        Write-Log "Error in ReRegister-AllServiceDLLs: $_"
        $consoleBox.AppendText("Error in ReRegister-AllServiceDLLs: $_`r`n")
    }
}

# Function to Repair Windows Defender Firewall
Function Repair-WindowsDefenderFirewall {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Repairing Windows Defender Firewall..."
    $consoleBox.AppendText("Repairing Windows Defender Firewall...`r`n")
    Try {
        # Re-register Windows Defender Firewall
        regsvr32.exe /s firewallapi.dll
        Write-Log "Windows Defender Firewall API re-registered."
        $consoleBox.AppendText("Windows Defender Firewall API re-registered.`r`n")

        # Reset Firewall rules to default
        Try {
            netsh advfirewall reset | Out-Null
            Write-Log "Windows Defender Firewall rules reset to default."
            $consoleBox.AppendText("Windows Defender Firewall rules reset to default.`r`n")
        }
        Catch {
            Write-Log "Error resetting Windows Defender Firewall rules: $_"
            $consoleBox.AppendText("Error resetting Windows Defender Firewall rules: $_`r`n")
        }
    }
    Catch {
        Write-Log "Error repairing Windows Defender Firewall: $_"
        $consoleBox.AppendText("Error repairing Windows Defender Firewall: $_`r`n")
    }
}
# Function to Run SFC and DISM Scans
Function Run-SystemScans {
    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Running SFC scan (part 1)..."
    $consoleBox.AppendText("Running SFC scan (part 1)...`r`n")
    Try {
        sfc /scannow | Out-Null
        Write-Log "SFC scan (part 1) completed."
        $consoleBox.AppendText("SFC scan (part 1) completed.`r`n")
    }
    Catch {
        Write-Log "Error running SFC scan (part 1): $_"
        $consoleBox.AppendText("Error running SFC scan (part 1): $_`r`n")
    }

    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Running DISM scan (part 1)..."
    $consoleBox.AppendText("Running DISM scan (part 1)...`r`n")
    Try {
        DISM /Online /Cleanup-Image /ScanHealth | Out-Null
        Write-Log "DISM scan (part 1) completed."
        $consoleBox.AppendText("DISM scan (part 1) completed.`r`n")
    }
    Catch {
        Write-Log "Error running DISM scan (part 1): $_"
        $consoleBox.AppendText("Error running DISM scan (part 1): $_`r`n")
    }

    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Running DISM scan (part 2)..."
    $consoleBox.AppendText("Running DISM scan (part 2)...`r`n")
    Try {
        DISM /Online /Cleanup-Image /RestoreHealth | Out-Null
        Write-Log "DISM scan (part 2) completed."
        $consoleBox.AppendText("DISM scan (part 2) completed.`r`n")
    }
    Catch {
        Write-Log "Error running DISM scan (part 2): $_"
        $consoleBox.AppendText("Error running DISM scan (part 2): $_`r`n")
    }

    Check-Cancellation
    Update-ProgressWindow -StatusMessage "Running SFC scan (part 2)..."
    $consoleBox.AppendText("Running SFC scan (part 2)...`r`n")
    Try {
        sfc /scannow | Out-Null
        Write-Log "SFC scan (part 2) completed."
        $consoleBox.AppendText("SFC scan (part 2) completed.`r`n")
    }
    Catch {
        Write-Log "Error running SFC scan (part 2): $_"
        $consoleBox.AppendText("Error running SFC scan (part 2): $_`r`n")
    }
}

# Function to Enable Script Execution Policy
Function Enable-ScriptExecutionPolicy {
    Update-ProgressWindow -StatusMessage "Setting PowerShell execution policy..."
    $consoleBox.AppendText("Setting PowerShell execution policy...`r`n")
    Try {
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force
        Write-Log "PowerShell execution policy set to Unrestricted for the session."
        $consoleBox.AppendText("PowerShell execution policy set to Unrestricted for the session.`r`n")
    }
    Catch {
        Write-Log "Error setting execution policy: $_"
        $consoleBox.AppendText("Error setting execution policy: $_`r`n")
    }
}

# Function to Cleanup After Process
Function Cleanup-AfterProcess {
    # Re-enable Apply button
    $applyButton.Invoke([action]{ $applyButton.Enabled = $true })
    # Disable Cancel button
    $cancelButton.Invoke([action]{ $cancelButton.Enabled = $false })
}

# Function to Start the Repair Process
Function Start-RepairProcess {
    # Reset cancellation flag
    $script:CancelRequested = $false
    
    # Set Execution Policy
    Enable-ScriptExecutionPolicy
    
    # Backup Critical Files
    Backup-CriticalFiles
    
    # Iterate through selected tasks
    for ($i = 0; $i -lt $checkboxes.Count; $i++) {
        if ($checkboxes[$i].Checked) {
            Check-Cancellation
            $taskName = $checkboxes[$i].Text
            $functionName = $tasks[$taskName]
            if ($functionName -and (Get-Command $functionName -ErrorAction SilentlyContinue)) {
                Try {
                    Write-Log "Executing task: $taskName"
                    $consoleBox.AppendText("Executing task: $taskName...`r`n")
                    & $functionName
                    Write-Log "Task $taskName completed."
                    $consoleBox.AppendText("Task $taskName completed.`r`n")
                }
                Catch {
                    Write-Log "Error executing task ${taskName}: $_"
                    $consoleBox.AppendText("Error executing task ${taskName}: $_`r`n")
                }
            }
            else {
                Write-Log "Function '$functionName' not found for task '$taskName'."
                $consoleBox.AppendText("Function '$functionName' not found for task '$taskName'.`r`n")
            }
        }
    }

    # Inform completion
    Write-Log "All selected repair operations completed."
    $consoleBox.AppendText("All selected repair operations completed.`r`n")

    # Prompt for restart
    [System.Windows.Forms.MessageBox]::Show("System repair operations completed. It is recommended to restart your computer.", "Repair Completed", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $restart = [System.Windows.Forms.MessageBox]::Show("Do you want to restart now?", "Restart", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($restart -eq [System.Windows.Forms.DialogResult]::Yes) {
        Write-Log "User opted to restart the computer."
        Restart-Computer -Force
    }
    else {
        Write-Log "User opted not to restart the computer immediately."
        [System.Windows.Forms.MessageBox]::Show("Please remember to restart your computer later to apply all changes.", "Restart Later", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    
    # Cleanup process after the repair operation is completed
    Cleanup-AfterProcess
}
# Apply Button Event
$applyButton.Add_Click({
    Write-Log "Repair process started by user."
    $consoleBox.AppendText("Repair process started.`r`n")
    
    # Disable the Apply button to prevent multiple clicks
    $applyButton.Enabled = $false
    
    # Enable the Cancel button
    $cancelButton.Enabled = $true
    
    # Execute the repair process
    Start-RepairProcess
})

# Show the form and keep it responsive
[System.Windows.Forms.Application]::Run($form)

# After repairs are done
Write-Log "System repair operations completed. It is recommended to restart your computer."
Write-Log "Windows 11 Repair Script Ended."
