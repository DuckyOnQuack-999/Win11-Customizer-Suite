# Load required .NET namespaces
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define log file path
$logFile = "$env:USERPROFILE\Desktop\LocalPolicyResetLog.txt"

# Function to initialize the log file with a header
function Initialize-Log {
    if (!(Test-Path -Path $logFile)) {
        try {
            $header = "Local Policy Reset Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n"
            Set-Content -Path $logFile -Value $header -ErrorAction Stop
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to create log file at '$logFile'. Check permissions.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
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
            [System.Windows.Forms.MessageBox]::Show("Failed to read log file at '$logFile'. Check permissions.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
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
        [System.Windows.Forms.MessageBox]::Show("Failed to write to log file. Check file permissions.", "Logging Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
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

# Function to reset Group Policy to default
function Reset-GroupPolicy {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    Log-Message "Initiating Group Policy reset process." $logBox

    # Ensure secedit exists
    $seceditPath = "$env:SystemRoot\System32\secedit.exe"
    if (!(Test-Path -Path $seceditPath)) {
        Log-Message "Error: 'secedit.exe' not found at '$seceditPath'." $logBox
        [System.Windows.Forms.MessageBox]::Show("'secedit.exe' is missing. Cannot proceed with resetting Group Policy.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    try {
        # Reset policies to default using defltbase.inf
        Log-Message "Resetting Group Policies to default using defltbase.inf." $logBox
        $resetProcess = Start-Process -FilePath $seceditPath -ArgumentList "/configure /cfg `C:\Windows\inf\defltbase.inf` /db defltbase.sdb /verbose /log `"$logFile`"" -NoNewWindow -Wait -PassThru

        if ($resetProcess.ExitCode -eq 0) {
            Log-Message "Group policies reset to default successfully." $logBox
        } else {
            throw "Failed to reset Group Policy to default. Exit code: $($resetProcess.ExitCode)"
        }

        # Refresh Group Policy
        Log-Message "Refreshing Group Policy settings." $logBox
        gpupdate /force | Out-String | ForEach-Object { Log-Message $_ $logBox }

        Log-Message "Group Policy reset process completed." $logBox

    } catch {
        Log-Message "Error: $($_.Exception.Message)" $logBox
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Function to clear logs
function Clear-Logs {
    param (
        [System.Windows.Forms.TextBox]$logBox
    )

    # Prompt user for confirmation
    $confirmation = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to clear all logs? This action cannot be undone.", "Confirm Clear Logs", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)

    if ($confirmation -eq [System.Windows.Forms.DialogResult]::Yes) {
        try {
            # Clear the logBox
            $logBox.Clear()

            # Truncate the log file by overwriting it with a new header
            $header = "Local Policy Reset Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n"
            Set-Content -Path $logFile -Value $header -ErrorAction Stop

            [System.Windows.Forms.MessageBox]::Show("Logs have been cleared successfully.", "Clear Logs", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            Log-Message "Failed to clear logs: $($_.Exception.Message)" $logBox
            [System.Windows.Forms.MessageBox]::Show("Unable to clear logs. Check file permissions.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
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
        [System.Windows.Forms.MessageBox]::Show("Unable to refresh logs. Check file permissions.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Initialize the log file
Initialize-Log

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 11 Policy Management"
$form.Size = New-Object System.Drawing.Size(700, 600) # Increased size to accommodate larger logBox
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Create a title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Windows 11 Local Policy Manager"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($titleLabel)

# Create a textbox for logging
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.Size = New-Object System.Drawing.Size(660, 400) # Adjusted size for better visibility
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
$resetButton.Size = New-Object System.Drawing.Size(200, 50)
$resetButton.Location = New-Object System.Drawing.Point(20, 480)
$resetButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$resetButton.ForeColor = [System.Drawing.Color]::White
$resetButton.FlatStyle = 'Flat'
$resetButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$resetButton.Add_Click({
    Log-Message "User initiated Group Policy reset." $logBox
    Reset-GroupPolicy $logBox
})
$form.Controls.Add($resetButton)

# Create Clear Logs Button
$clearLogsButton = New-Object System.Windows.Forms.Button
$clearLogsButton.Text = "Clear Logs"
$clearLogsButton.Size = New-Object System.Drawing.Size(150, 50)
$clearLogsButton.Location = New-Object System.Drawing.Point(240, 480)
$clearLogsButton.BackColor = [System.Drawing.Color]::FromArgb(255, 69, 0) # Orange-red color
$clearLogsButton.ForeColor = [System.Drawing.Color]::White
$clearLogsButton.FlatStyle = 'Flat'
$clearLogsButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$clearLogsButton.Add_Click({
    Clear-Logs $logBox
})
$form.Controls.Add($clearLogsButton)

# Create View Logs Button (now acts as a Refresh Logs button)
$viewLogButton = New-Object System.Windows.Forms.Button
$viewLogButton.Text = "Refresh Logs"
$viewLogButton.Size = New-Object System.Drawing.Size(150, 50)
$viewLogButton.Location = New-Object System.Drawing.Point(420, 480)
$viewLogButton.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 0) # Green color
$viewLogButton.ForeColor = [System.Drawing.Color]::White
$viewLogButton.FlatStyle = 'Flat'
$viewLogButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$viewLogButton.Add_Click({
    Log-Message "User refreshed the logs." $logBox
    Refresh-Logs $logBox
})
$form.Controls.Add($viewLogButton)

# Create Exit Button
$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = "Exit"
$exitButton.Size = New-Object System.Drawing.Size(100, 50)
$exitButton.Location = New-Object System.Drawing.Point(600, 480)
$exitButton.BackColor = [System.Drawing.Color]::FromArgb(200, 35, 51)
$exitButton.ForeColor = [System.Drawing.Color]::White
$exitButton.FlatStyle = 'Flat'
$exitButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$exitButton.Add_Click({
    Log-Message "User exited the application." $logBox
    $form.Close()
})
$form.Controls.Add($exitButton)

# Display the form
[void]$form.ShowDialog()
