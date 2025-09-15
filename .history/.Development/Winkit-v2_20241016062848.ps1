<# 
.DESCRIPTION
This script creates a Windows Forms application using PowerShell for enhanced design aesthetics. The application is designed to repair and manage Windows Store apps, maintain local group policies, and provide scalability, modularity, and a dark-mode default interface. Additional functionalities include app backup, advanced logging, and scheduling features.
#>

# Load Required Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define Form
$form               = New-Object Windows.Forms.Form
$form.Text          = "Windows Store Apps Repair Tools"  # Set the title of the form to reflect its purpose
$form.Size          = New-Object Drawing.Size(900, 700)  # Set the form size to 900x700 pixels for more space
$form.StartPosition = "CenterScreen"  # Center the form on the screen
$form.BackColor     = [System.Drawing.Color]::FromArgb(45, 45, 48)  # Set a dark background color for the form
$form.ForeColor     = [System.Drawing.Color]::White  # Set the text color to white for better contrast

# Define Controls
# Create a side panel for navigation
$sidePanel           = New-Object Windows.Forms.Panel
$sidePanel.Dock      = [System.Windows.Forms.DockStyle]::Left  # Dock the side panel to the left of the form
$sidePanel.Width     = 200  # Set the width of the side panel
$sidePanel.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)  # Set a darker background for the side panel
$form.Controls.Add($sidePanel)

# Add a label to the side panel
$menuLabel           = New-Object Windows.Forms.Label
$menuLabel.Text      = "Menu"  # Set the label text
$menuLabel.ForeColor = [System.Drawing.Color]::White  # Set the text color to white
$menuLabel.Font      = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)  # Set font style for the label
$menuLabel.Location  = New-Object Drawing.Point(10, 10)  # Set the label position within the side panel
$sidePanel.Controls.Add($menuLabel)

# Add buttons to the side panel for navigation
$repairButtonMenu           = New-Object Windows.Forms.Button
$repairButtonMenu.Text      = "Repair Apps"  # Button to navigate to the repair tools section
$repairButtonMenu.Size      = New-Object Drawing.Size(180, 30)  # Set button size
$repairButtonMenu.Location  = New-Object Drawing.Point(10, 50)  # Set button position within the side panel
$repairButtonMenu.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)  # Set a distinct background color for the button
$repairButtonMenu.ForeColor = [System.Drawing.Color]::White  # Set the text color to white
$sidePanel.Controls.Add($repairButtonMenu)

$localPolicyButton           = New-Object Windows.Forms.Button
$localPolicyButton.Text      = "Local Group Policy Reset Tool"  # Button to navigate to the Local Group Policy reset tool
$localPolicyButton.Size      = New-Object Drawing.Size(180, 30)  # Set button size
$localPolicyButton.Location  = New-Object Drawing.Point(10, 90)  # Set button position within the side panel
$localPolicyButton.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)  # Set a distinct background color for the button
$localPolicyButton.ForeColor = [System.Drawing.Color]::White  # Set the text color to white
$sidePanel.Controls.Add($localPolicyButton)

$installersButton           = New-Object Windows.Forms.Button
$installersButton.Text      = "Installers"  # Button to navigate to the Installers section
$installersButton.Size      = New-Object Drawing.Size(180, 30)  # Set button size
$installersButton.Location  = New-Object Drawing.Point(10, 130)  # Set button position within the side panel
$installersButton.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)  # Set a distinct background color for the button
$installersButton.ForeColor = [System.Drawing.Color]::White  # Set the text color to white
$sidePanel.Controls.Add($installersButton)

# Define the data grid to display installed apps
$dataGrid          = New-Object Windows.Forms.ListView
$dataGrid.Size     = New-Object Drawing.Size(660, 400)  # Increase the size of the data grid for better visibility
$dataGrid.Location = New-Object Drawing.Point(220, 60)  # Set the position of the data grid
$dataGrid.View     = [System.Windows.Forms.View]::Details  # Set the view to Details for better display of columns
$dataGrid.Columns.Add("App Name", 300)  # Increase width of the app name column
$dataGrid.Columns.Add("Version", 150)  # Increase width of the version column
$dataGrid.Columns.Add("Status", 200)  # Increase width of the status column
$dataGrid.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)  # Set background color to match form
$dataGrid.ForeColor = [System.Drawing.Color]::White  # Set text color to white for better visibility
$form.Controls.Add($dataGrid)

# Define Installers Panel
$installersPanel           = New-Object Windows.Forms.Panel
$installersPanel.Size      = New-Object Drawing.Size(660, 500)
$installersPanel.Location  = New-Object Drawing.Point(220, 60)
$installersPanel.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$installersPanel.Visible   = $false
$form.Controls.Add($installersPanel)

# Define Installer Buttons
$installVisualCppButton           = New-Object Windows.Forms.Button
$installVisualCppButton.Text      = "Install Visual C++ Redistributables"
$installVisualCppButton.Size      = New-Object Drawing.Size(300, 40)
$installVisualCppButton.Location  = New-Object Drawing.Point(180, 100)
$installVisualCppButton.BackColor = [System.Drawing.Color]::FromArgb(30, 120, 180)
$installVisualCppButton.ForeColor = [System.Drawing.Color]::White
$installVisualCppButton.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$installersPanel.Controls.Add($installVisualCppButton)

$installDirectXButton           = New-Object Windows.Forms.Button
$installDirectXButton.Text      = "Install DirectX"
$installDirectXButton.Size      = New-Object Drawing.Size(300, 40)
$installDirectXButton.Location  = New-Object Drawing.Point(180, 160)
$installDirectXButton.BackColor = [System.Drawing.Color]::FromArgb(30, 120, 180)
$installDirectXButton.ForeColor = [System.Drawing.Color]::White
$installDirectXButton.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$installersPanel.Controls.Add($installDirectXButton)

# Add .NET SDK Installer Button
$installDotNetButton           = New-Object Windows.Forms.Button
$installDotNetButton.Text      = "Install .NET SDKs"
$installDotNetButton.Size      = New-Object Drawing.Size(300, 40)
$installDotNetButton.Location  = New-Object Drawing.Point(180, 220)
$installDotNetButton.BackColor = [System.Drawing.Color]::FromArgb(30, 120, 180)
$installDotNetButton.ForeColor = [System.Drawing.Color]::White
$installDotNetButton.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$installersPanel.Controls.Add($installDotNetButton)

# Define Local Group Policy Reset Tool UI and Logic
$policyPanel           = New-Object Windows.Forms.Panel
$policyPanel.Size      = New-Object Drawing.Size(660, 500)
$policyPanel.Location  = New-Object Drawing.Point(220, 60)
$policyPanel.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$policyPanel.Visible   = $false  # Initially hidden
$form.Controls.Add($policyPanel)

$resetPolicyButton           = New-Object Windows.Forms.Button
$resetPolicyButton.Text      = "Reset Local Group Policy"
$resetPolicyButton.Size      = New-Object Drawing.Size(200, 40)
$resetPolicyButton.Location  = New-Object Drawing.Point(50, 400)
$resetPolicyButton.BackColor = [System.Drawing.Color]::FromArgb(30, 120, 180)
$resetPolicyButton.ForeColor = [System.Drawing.Color]::White
$resetPolicyButton.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$policyPanel.Controls.Add($resetPolicyButton)

$clearLogsButton           = New-Object Windows.Forms.Button
$clearLogsButton.Text      = "Clear Logs"
$clearLogsButton.Size      = New-Object Drawing.Size(150, 40)
$clearLogsButton.Location  = New-Object Drawing.Point(270, 400)
$clearLogsButton.BackColor = [System.Drawing.Color]::FromArgb(255, 120, 0)
$clearLogsButton.ForeColor = [System.Drawing.Color]::White
$clearLogsButton.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$policyPanel.Controls.Add($clearLogsButton)

$refreshLogsButton           = New-Object Windows.Forms.Button
$refreshLogsButton.Text      = "Refresh Logs"
$refreshLogsButton.Size      = New-Object Drawing.Size(150, 40)
$refreshLogsButton.Location  = New-Object Drawing.Point(450, 400)
$refreshLogsButton.BackColor = [System.Drawing.Color]::FromArgb(50, 150, 50)
$refreshLogsButton.ForeColor = [System.Drawing.Color]::White
$refreshLogsButton.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$policyPanel.Controls.Add($refreshLogsButton)

$exitButton           = New-Object Windows.Forms.Button
$exitButton.Text      = "Exit"
$exitButton.Size      = New-Object Drawing.Size(150, 40)
$exitButton.Location  = New-Object Drawing.Point(620, 400)
$exitButton.BackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)
$exitButton.ForeColor = [System.Drawing.Color]::White
$exitButton.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$policyPanel.Controls.Add($exitButton)

$logsTextBox            = New-Object Windows.Forms.TextBox
$logsTextBox.Multiline  = $true
$logsTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$logsTextBox.Size       = New-Object Drawing.Size(600, 300)
$logsTextBox.Location   = New-Object Drawing.Point(30, 50)
$logsTextBox.BackColor  = [System.Drawing.Color]::FromArgb(45, 45, 48)
$logsTextBox.ForeColor  = [System.Drawing.Color]::White
$logsTextBox.Font       = New-Object System.Drawing.Font("Segoe UI", 10)
$policyPanel.Controls.Add($logsTextBox)

# Function to populate the data grid with installed apps
function Get-InstalledStoreApps {
    try {
        # Retrieve all installed non-framework Store apps
        $apps = Get-AppxPackage | Where-Object { $_.IsFramework -eq $false }
        if ($apps.Count -eq 0) {
            Write-Output "No apps found to display."  # Log message if no apps are found
        }
        foreach ($app in $apps) {
            # Create a new list view item for each app
            $item = New-Object Windows.Forms.ListViewItem($app.Name)
            $item.SubItems.Add($app.Version)  # Add version as a sub-item to the list view item
            $item.SubItems.Add("Installed")  # Add status as a sub-item to the list view item
            $dataGrid.Items.Add($item)  # Add the item to the data grid
        }
    } catch {
        Write-Error "Failed to retrieve installed apps. Please ensure you have the necessary permissions."  # Error handling for failed command execution
    }
}

# Function to repair a specific store app
function Repair-StoreApp {
    param ($appName)  # Take the app name as a parameter

    # Backup app data (implementation would go here)
    Write-Output "Backing up app data for $appName..."
    Backup-AppData -appName $appName  # Call the backup function

    # Remove and reinstall the app
    Write-Output "Repairing $appName..."
    try {
        # Remove the selected app
        Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction Stop
        # Reinstall the app
        Add-AppxPackage -Register -DisableDevelopmentMode (Get-AppxPackage -AllUsers -Name $appName).InstallLocation + "\AppxManifest.xml" -ErrorAction Stop
    } catch {
        Write-Error "Failed to repair the app $appName. Please check for missing dependencies or permissions."  # Error handling for missing dependencies or failed reinstall
    }

    # Restore app data (implementation would go here)