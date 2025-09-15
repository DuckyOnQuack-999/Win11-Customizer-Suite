# Load required .NET namespaces
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define log file path
$logFile = "$env:USERPROFILE\Desktop\LocalPolicyResetLog.txt"

# Define the path to the security policy template (.inf file)
$securityPolicyPath = "C:\Path\To\SecurityPolicy.inf" # <-- Update this path accordingly

# Function to initialize the log file with a header
function Initialize-Log {
    if (!(Test-Path -Path $logFile)) {
        try {
            $header = "Local Policy Reset Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n"
            Set-Content -Path $logFile -Value $header -ErrorAction Stop
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to create log file at '$logFile'. Check permissions.", "Error", `
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            throw
        }
    }
}

# Function to load existing logs into the logBox
function Load-Existing-Logs {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )
    if (Test-Path -Path $logFile) {
        try {
            $existingLogs = Get-Content -Path $logFile -ErrorAction Stop
            foreach ($line in $existingLogs) {
                $logBox.AppendText("$line`r`n")
            }
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to read log file at '$logFile'. Check permissions.", "Error", `
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Function to log messages (writes to file and to the log box)
function Log-Message {
    param (
        [string]$message,
        [System.Windows.Forms.TextBox]$logBox
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"

    try {
        # Log to file
        Add-Content -Path $logFile -Value $logEntry -ErrorAction Stop
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to write to log file. Check file permissions.", "Logging Error", `
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

    try {
        # Log to UI textbox
        $logBox.AppendText("$logEntry`r`n")
        # Auto-scroll to the latest entry
        $logBox.SelectionStart = $logBox.Text.Length
        $logBox.ScrollToCaret()
    } catch {
        # If logging to UI fails, there's not much else to do
    }
}

# Function to reset Group Policy to default using secedit
function Reset-GroupPolicy {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    Log-Message "Initiating Group Policy reset process." $logBox

    # Ensure secedit exists
    $seceditPath = "$env:SystemRoot\System32\secedit.exe"
    if (!(Test-Path -Path $seceditPath)) {
        Log-Message "Error: 'secedit.exe' not found at '$seceditPath'." $logBox
        [System.Windows.Forms.MessageBox]::Show("'secedit.exe' is missing. Cannot proceed with resetting Group Policy.", `
            "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    try {
        # Reset policies to default using defltbase.inf
        Log-Message "Resetting Group Policies to default using defltbase.inf." $logBox
        $resetProcess = Start-Process -FilePath $seceditPath -ArgumentList "/configure /cfg `C:\Windows\inf\defltbase.inf` /db defltbase.sdb /verbose /log `"$logFile`"" `
            -NoNewWindow -Wait -PassThru

        if ($resetProcess.ExitCode -eq 0) {
            Log-Message "Group policies reset to default successfully." $logBox
        } else {
            throw "Failed to reset Group Policy to default. Exit code: $($resetProcess.ExitCode)"
        }

        Log-Message "Group Policy reset process completed." $logBox

    } catch {
        Log-Message "Error: $($_.Exception.Message)" $logBox
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $($_.Exception.Message)", "Error", `
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Function to remove Group Policy registry keys
function Remove-GroupPolicy-RegistryKeys {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    Log-Message "Initiating removal of Group Policy registry keys." $logBox

    # Define the registry paths associated with Group Policies
    $registryPaths = @(
        "HKLM:\SOFTWARE\Policies",
        "HKCU:\SOFTWARE\Policies"
    )

    foreach ($path in $registryPaths) {
        if (Test-Path -Path $path) {
            try {
                Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
                Log-Message "Successfully removed registry path: $path" $logBox
            } catch {
                Log-Message "Failed to remove registry path '$path': $($_.Exception.Message)" $logBox
                [System.Windows.Forms.MessageBox]::Show("Failed to remove registry path '$path'. Check permissions.", `
                    "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        } else {
            Log-Message "Registry path does not exist: $path" $logBox
        }
    }

    Log-Message "Group Policy registry keys removal process completed." $logBox
}

# Function to delete Group Policy directories in Windows directory
function Delete-GroupPolicy-Files {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    Log-Message "Initiating deletion of Group Policy files in Windows directory." $logBox

    # Define the Group Policy directories
    $policyDirs = @(
        "$env:SystemRoot\System32\GroupPolicy",
        "$env:SystemRoot\System32\GroupPolicyUsers"
    )

    foreach ($dir in $policyDirs) {
        if (Test-Path -Path $dir) {
            try {
                Remove-Item -Path $dir -Recurse -Force -ErrorAction Stop
                Log-Message "Successfully deleted directory: $dir" $logBox
            } catch {
                Log-Message "Failed to delete directory '$dir': $($_.Exception.Message)" $logBox
                [System.Windows.Forms.MessageBox]::Show("Failed to delete directory '$dir'. Check permissions.", `
                    "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        } else {
            Log-Message "Directory does not exist: $dir" $logBox
        }
    }

    Log-Message "Group Policy files deletion process completed." $logBox
}

# Function to apply security policies using secedit
function Apply-SecurityPolicy {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    Log-Message "Initiating application of security policies." $logBox

    # Check if the security policy template exists
    if (!(Test-Path -Path $securityPolicyPath)) {
        Log-Message "Error: Security policy template not found at '$securityPolicyPath'." $logBox
        [System.Windows.Forms.MessageBox]::Show("Security policy template not found at '$securityPolicyPath'. Please verify the path.", `
            "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    try {
        # Apply security policies using secedit
        Log-Message "Applying security policies using '$securityPolicyPath'." $logBox
        $seceditPath = "$env:SystemRoot\System32\secedit.exe"
        $applyProcess = Start-Process -FilePath $seceditPath -ArgumentList "/configure /db secedit.sdb /cfg `"$securityPolicyPath`" /overwrite /log `"$logFile`"" `
            -NoNewWindow -Wait -PassThru

        if ($applyProcess.ExitCode -eq 0) {
            Log-Message "Security policies applied successfully." $logBox
        } else {
            throw "Failed to apply security policies. Exit code: $($applyProcess.ExitCode)"
        }

        Log-Message "Security policy application process completed." $logBox

    } catch {
        Log-Message "Error applying security policies: $($_.Exception.Message)" $logBox
        [System.Windows.Forms.MessageBox]::Show("An error occurred while applying security policies: $($_.Exception.Message)", `
            "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Function to reload Group Policy settings
function Reload-GroupPolicy {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    Log-Message "Reloading Group Policy settings with gpupdate /force." $logBox

    try {
        # Start gpupdate process
        $gpupdateProcess = Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -NoNewWindow -Wait -PassThru

        if ($gpupdateProcess.ExitCode -eq 0) {
            Log-Message "Group Policy reloaded successfully." $logBox
        } else {
            throw "gpupdate /force failed with exit code: $($gpupdateProcess.ExitCode)"
        }
    } catch {
        Log-Message "Error reloading Group Policy: $($_.Exception.Message)" $logBox
        [System.Windows.Forms.MessageBox]::Show("Failed to reload Group Policy: $($_.Exception.Message)", "Error", `
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Function to clear logs
function Clear-Logs {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    # Prompt user for confirmation
    $confirmation = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to clear all logs? This action cannot be undone.", `
        "Confirm Clear Logs", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)

    if ($confirmation -eq [System.Windows.Forms.DialogResult]::Yes) {
        try {
            # Clear the logBox
            $logBox.Clear()

            # Truncate the log file by overwriting it with a new header
            $header = "Local Policy Reset Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n"
            Set-Content -Path $logFile -Value $header -ErrorAction Stop

            [System.Windows.Forms.MessageBox]::Show("Logs have been cleared successfully.", "Clear Logs", `
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            Log-Message "Failed to clear logs: $($_.Exception.Message)" $logBox
            [System.Windows.Forms.MessageBox]::Show("Unable to clear logs. Check file permissions.", `
                "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Function to refresh logs in the logBox
function Refresh-Logs {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    try {
        # Clear current logBox content
        $logBox.Clear()

        # Load existing logs
        Load-Existing-Logs -logBox $logBox

        Log-Message "Logs have been refreshed." $logBox
    } catch {
        Log-Message "Failed to refresh logs: $($_.Exception.Message)" $logBox
        [System.Windows.Forms.MessageBox]::Show("Unable to refresh logs. Check file permissions.", `
            "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Function to perform all policy removal steps, apply security policies, and reload policies
function Remove-AllPolicies {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    # Reset Group Policy using secedit
    Reset-GroupPolicy $logBox

    # Remove Group Policy registry keys
    Remove-GroupPolicy-RegistryKeys $logBox

    # Delete Group Policy files in Windows directory
    Delete-GroupPolicy-Files $logBox

    # Apply security policies using secedit
    Apply-SecurityPolicy $logBox

    # Reload Group Policy settings
    Reload-GroupPolicy $logBox
}

# Initialize the log file
Initialize-Log

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 11 Policy Management"
$form.Size = New-Object System.Drawing.Size(800, 750) # Increased size to accommodate larger logBox
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Create a title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Windows 11 Local Policy Manager"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($titleLabel)

# Create a textbox for logging
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.Size = New-Object System.Drawing.Size(760, 550) # Adjusted size for better visibility
$logBox.Location = New-Object System.Drawing.Point(20, 60)
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$form.Controls.Add($logBox)

# Load existing logs into logBox
Load-Existing-Logs -logBox $logBox

# Create Reset Policy Button
$resetButton = New-Object System.Windows.Forms.Button
$resetButton.Text = "Reset Local Group Policy"
$resetButton.Size = New-Object System.Drawing.Size(220, 60)
$resetButton.Location = New-Object System.Drawing.Point(20, 630)
$resetButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$resetButton.ForeColor = [System.Drawing.Color]::White
$resetButton.FlatStyle = 'Flat'
$resetButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$resetButton.Add_Click({
    Log-Message "User initiated Group Policy reset." $logBox
    Remove-AllPolicies $logBox
})
$form.Controls.Add($resetButton)

# Create Clear Logs Button
$clearLogsButton = New-Object System.Windows.Forms.Button
$clearLogsButton.Text = "Clear Logs"
$clearLogsButton.Size = New-Object System.Drawing.Size(180, 60)
$clearLogsButton.Location = New-Object System.Drawing.Point(260, 630)
$clearLogsButton.BackColor = [System.Drawing.Color]::FromArgb(255, 69, 0) # Orange-red color
$clearLogsButton.ForeColor = [System.Drawing.Color]::White
$clearLogsButton.FlatStyle = 'Flat'
$clearLogsButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$clearLogsButton.Add_Click({
    Clear-Logs $logBox
})
$form.Controls.Add($clearLogsButton)

# Create Refresh Logs Button
$refreshLogButton = New-Object System.Windows.Forms.Button
$refreshLogButton.Text = "Refresh Logs"
$refreshLogButton.Size = New-Object System.Drawing.Size(180, 60)
$refreshLogButton.Location = New-Object System.Drawing.Point(460, 630)
$refreshLogButton.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 0) # Green color
$refreshLogButton.ForeColor = [System.Drawing.Color]::White
$refreshLogButton.FlatStyle = 'Flat'
$refreshLogButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$refreshLogButton.Add_Click({
    Log-Message "User refreshed the logs." $logBox
    Refresh-Logs $logBox
})
$form.Controls.Add($refreshLogButton)

# Create Exit Button
$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = "Exit"
$exitButton.Size = New-Object System.Drawing.Size(100, 60)
$exitButton.Location = New-Object System.Drawing.Point(700, 630)
$exitButton.BackColor = [System.Drawing.Color]::FromArgb(200, 35, 51)
$exitButton.ForeColor = [System.Drawing.Color]::White
$exitButton.FlatStyle = 'Flat'
$exitButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$exitButton.Add_Click({
    Log-Message "User exited the application." $logBox
    $form.Close()
})
$form.Controls.Add($exitButton)

# Display the form
[void]$form.ShowDialog()
