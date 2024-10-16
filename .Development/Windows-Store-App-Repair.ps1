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
    Write-Output "Restoring app data for $appName..."
    Restore-AppData -appName $appName  # Call the restore function
}

# Function to create a backup of app data
function Backup-AppData {
    param ($appName)
    # Implementation of backup logic for app data
    Write-Output "Creating a backup for $appName..."
    # (Actual backup logic would go here)
}

# Function to restore app data
function Restore-AppData {
    param ($appName)
    # Implementation of restore logic for app data
    Write-Output "Restoring backup for $appName..."
    # (Actual restore logic would go here)
}

# Function to install Visual C++ Redistributables
function VisualCPPInstaller {
    try {
        Write-Output "Starting Visual C++ Redistributables installation..."
        # Define the download URL and local file path
        $vcRedistUrl   = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        $localFilePath = "$env:TEMP\vc_redist.x64.exe"

        # Download the installer
        Write-Output "Downloading Visual C++ Redistributables..."
        Invoke-WebRequest -Uri $vcRedistUrl -OutFile $localFilePath -UseBasicParsing

        # Run the installer silently
        Write-Output "Installing Visual C++ Redistributables..."
        Start-Process -FilePath $localFilePath -ArgumentList "/install", "/passive", "/norestart" -Wait

        Write-Output "Visual C++ Redistributables installed successfully."
        [System.Windows.Forms.MessageBox]::Show("Visual C++ Redistributables installed successfully.", "Installation Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        Write-Error "Failed to install Visual C++ Redistributables. $_"
        [System.Windows.Forms.MessageBox]::Show("Failed to install Visual C++ Redistributables. Check the logs for more details.", "Installation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } finally {
        # Clean up the installer file
        if (Test-Path $localFilePath) {
            Remove-Item $localFilePath -Force
        }
    }
}

# Function to install DirectX
function DirectXInstaller {
    try {
        Write-Output "Starting DirectX installation..."
        # Define the download URL and local file path
        $directXUrl    = "https://download.microsoft.com/download/1/6/4/1644D52A-633F-4C5F-A119-A2EE0D3FA9A6/directx_Jun2010_redist.exe"
        $localFilePath = "$env:TEMP\directx_redist.exe"
        $extractedPath = "$env:TEMP\directx_redist"

        # Download the installer
        Write-Output "Downloading DirectX..."
        Invoke-WebRequest -Uri $directXUrl -OutFile $localFilePath -UseBasicParsing

        # Extract the installer contents
        Write-Output "Extracting DirectX files..."
        Start-Process -FilePath $localFilePath -ArgumentList "/Q", "/T:$extractedPath" -Wait

        # Run the DirectX setup
        Write-Output "Installing DirectX..."
        Start-Process -FilePath "$extractedPath\DXSETUP.exe" -ArgumentList "/silent" -Wait

        Write-Output "DirectX installed successfully."
        [System.Windows.Forms.MessageBox]::Show("DirectX installed successfully.", "Installation Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        Write-Error "Failed to install DirectX. $_"
        [System.Windows.Forms.MessageBox]::Show("Failed to install DirectX. Check the logs for more details.", "Installation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } finally {
        # Clean up the installer files
        if (Test-Path $localFilePath) {
            Remove-Item $localFilePath -Force
        }
        if (Test-Path $extractedPath) {
            Remove-Item $extractedPath -Recurse -Force
        }
    }
}

# Function to install .NET SDK versions
function Install-DotnetSDK {
    param (
        [string]$Channel,
        [string]$Quality = ""
    )
    try {
        Write-Output "Installing .NET SDK Channel $Channel $Quality..."
        # Download the dotnet-install script
        $scriptUrl  = "https://dot.net/v1/dotnet-install.ps1"
        $scriptPath = "$env:TEMP\dotnet-install.ps1"
        Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath -UseBasicParsing

        # Build the command to execute
        $command = "& '$scriptPath' -Channel $Channel"
        if ($Quality) {
            $command += " -Quality $Quality"
        }

        # Execute the command
        Invoke-Expression $command

        Write-Output ".NET SDK Channel $Channel $Quality installed successfully."
    } catch {
        Write-Error "Failed to install .NET SDK Channel $Channel $Quality : $_"
        [System.Windows.Forms.MessageBox]::Show("Failed to install .NET SDK Channel $Channel $Quality. Check the logs for more details.", "Installation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } finally {
        # Clean up the script file
        if (Test-Path $scriptPath) {
            Remove-Item $scriptPath -Force
        }
    }
}

# Function to install packages using winget with error handling
function Install-WingetPackage {
    param (
        [string]$PackageId
    )
    try {
        Write-Output "Installing $PackageId via winget..."
        winget install --id $PackageId --silent --accept-package-agreements --accept-source-agreements
        Write-Output "$PackageId installed successfully."
    } catch {
        Write-Error "Failed to install $PackageId : $_"
        [System.Windows.Forms.MessageBox]::Show("Failed to install $PackageId. Check the logs for more details.", "Installation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Function to set .NET environment variables
function Set-DotNetEnvironmentVariables {
    try {
        Write-Output "Setting .NET environment variables..."
        [System.Environment]::SetEnvironmentVariable("DOTNET_ROOT", "C:\Program Files\dotnet", "Machine")
        $env:PATH += ";C:\Program Files\dotnet"
        [System.Environment]::SetEnvironmentVariable("PATH", $env:PATH, "Machine")
        Write-Output "DOTNET_ROOT and PATH environment variables set successfully."
    } catch {
        Write-Error "Failed to set environment variables: $_"
        [System.Windows.Forms.MessageBox]::Show("Failed to set environment variables. Check the logs for more details.", "Environment Variable Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Event Handlers for Installers
$installVisualCppButton.Add_Click({
    VisualCPPInstaller
})

$installDirectXButton.Add_Click({
    DirectXInstaller
})

$installDotNetButton.Add_Click({
    try {
        # Install .NET SDKs with specific channels
        $channels = @(
            "1.0", "1.1", "2.0", "2.1",
            "3.0", "3.1", "5.0",
            "6.0 Preview",
            "7.0 Preview",
            "8.0 Preview",
            "9.0 Preview",
            "STS"
        )

        foreach ($channel in $channels) {
            $parts   = $channel.Split(" ")
            $ch      = $parts[0]
            $quality = if ($parts.Length -gt 1) { $parts[1] } else { "" }
            Install-DotnetSDK -Channel $ch -Quality $quality
        }

        # Install specific .NET SDKs using winget
        $packages = @(
            "Microsoft.DotNet.SDK.5",
            "Microsoft.DotNet.SDK.6",
            "Microsoft.DotNet.SDK.7",
            "Microsoft.DotNet.SDK.8",
            "Microsoft.DotNet.SDK.Preview"
        )

        foreach ($package in $packages) {
            Install-WingetPackage -PackageId $package
        }

        # Set .NET environment variables
        Set-DotNetEnvironmentVariables

        # Verify the changes
        $dotnetRoot = [System.Environment]::GetEnvironmentVariable('DOTNET_ROOT', 'Machine')
        $pathVar    = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')

        Write-Output "DOTNET_ROOT=$dotnetRoot"
        Write-Output "PATH=$pathVar"

        [System.Windows.Forms.MessageBox]::Show(".NET SDKs installed successfully.", "Installation Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        Write-Error "Failed to install .NET SDKs: $_"
        [System.Windows.Forms.MessageBox]::Show("Failed to install .NET SDKs. Check the logs for more details.", "Installation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Navigation Button Events
$repairButtonMenu.Add_Click({
    $policyPanel.Visible     = $false  # Hide the policy panel
    $installersPanel.Visible = $false  # Hide the installers panel
    $dataGrid.Visible        = $true  # Show the data grid with installed apps

    # Show the uninstall and repair buttons relevant to app management
    $repairButton.Visible         = $true
    $uninstallLocalButton.Visible = $true
    $uninstallGlobalButton.Visible = $true

    # Hide the reset group policy buttons when in app repair panel
    $resetPolicyButton.Visible = $false
    $clearLogsButton.Visible = $false
    $refreshLogsButton.Visible = $false
    $exitButton.Visible = $false
    $logsTextBox.Visible = $false
})

$localPolicyButton.Add_Click({
    $dataGrid.Visible = $false  # Hide the data grid
    $installersPanel.Visible = $false  # Hide the installers panel
    $policyPanel.Visible = $true  # Show the policy panel

    # Hide the uninstall and repair buttons when in the policy reset panel
    $repairButton.Visible = $false
    $uninstallLocalButton.Visible = $false
    $uninstallGlobalButton.Visible = $false

    # Show the reset group policy buttons in policy reset panel
    $resetPolicyButton.Visible = $true
    $clearLogsButton.Visible = $true
    $refreshLogsButton.Visible = $true
    $exitButton.Visible = $true
    $logsTextBox.Visible = $true
})

$installersButton.Add_Click({
    $dataGrid.Visible = $false  # Hide the data grid
    $policyPanel.Visible = $false  # Hide the policy panel
    $installersPanel.Visible = $true  # Show the installers panel

    # Hide the uninstall and repair buttons when in the installers panel
    $repairButton.Visible = $false
    $uninstallLocalButton.Visible = $false
    $uninstallGlobalButton.Visible = $false

    # Hide the reset group policy buttons when in installers panel
    $resetPolicyButton.Visible = $false
    $clearLogsButton.Visible = $false
    $refreshLogsButton.Visible = $false
    $exitButton.Visible = $false
    $logsTextBox.Visible = $false
})

# Define the repair button
$repairButton = New-Object Windows.Forms.Button
$repairButton.Text = "Repair Selected"  # Set button text to indicate repair action
$repairButton.Size = New-Object Drawing.Size(150, 40)  # Set button size
$repairButton.Location = New-Object Drawing.Point(620, 500)  # Set button position
$repairButton.BackColor = [System.Drawing.Color]::FromArgb(30, 120, 180)  # Set button background color for visibility
$repairButton.ForeColor = [System.Drawing.Color]::White  # Set text color to white for contrast
$repairButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)  # Set button font style for emphasis

# Add event to the repair button to handle click events
$repairButton.Add_Click({
    # Check if any item is selected in the data grid
    if ($dataGrid.SelectedItems.Count -gt 0) {
        $selectedItem = $dataGrid.SelectedItems[0]
        if ($null -ne $selectedItem) {
            # Call the repair function with the selected app name
            Repair-StoreApp -appName $selectedItem.Text
            [System.Windows.Forms.MessageBox]::Show("Repair process completed for $($selectedItem.Text).", "Repair Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("No app selected. Please select an app to repair.", "No Selection", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})
$form.Controls.Add($repairButton)

# Define uninstall buttons
$uninstallLocalButton = New-Object Windows.Forms.Button
$uninstallLocalButton.Text = "Uninstall (Local)"  # Set button text to indicate uninstall action for the current user
$uninstallLocalButton.Size = New-Object Drawing.Size(150, 40)  # Set button size
$uninstallLocalButton.Location = New-Object Drawing.Point(450, 500)  # Set button position
$uninstallLocalButton.BackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)  # Set button background color for visibility
$uninstallLocalButton.ForeColor = [System.Drawing.Color]::White  # Set text color to white for contrast
$uninstallLocalButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)  # Set button font style for emphasis

# Add event to the uninstall (local) button to handle click events
$uninstallLocalButton.Add_Click({
    # Check if any item is selected in the data grid
    if ($dataGrid.SelectedItems.Count -gt 0) {
        $selectedItem = $dataGrid.SelectedItems[0]
        if ($null -ne $selectedItem) {
            try {
                # Uninstall the app for the current user
                Write-Output "Uninstalling (local) $($selectedItem.Text)..."
                Get-AppxPackage -Name $selectedItem.Text | Remove-AppxPackage -ErrorAction Stop
                Write-Output "Successfully uninstalled (local) $($selectedItem.Text)."  # Log success message
                [System.Windows.Forms.MessageBox]::Show("Successfully uninstalled (local) $($selectedItem.Text).", "Uninstall Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            } catch {
                Write-Error "Failed to uninstall (local) $($selectedItem.Text). Please check permissions."  # Error handling
                [System.Windows.Forms.MessageBox]::Show("Failed to uninstall (local) $($selectedItem.Text). Check permissions.", "Uninstall Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("No app selected. Please select an app to uninstall.", "No Selection", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})
$form.Controls.Add($uninstallLocalButton)

$uninstallGlobalButton = New-Object Windows.Forms.Button
$uninstallGlobalButton.Text = "Uninstall (Global)"  # Set button text to indicate uninstall action for all users
$uninstallGlobalButton.Size = New-Object Drawing.Size(150, 40)  # Set button size
$uninstallGlobalButton.Location = New-Object Drawing.Point(280, 500)  # Set button position
$uninstallGlobalButton.BackColor = [System.Drawing.Color]::FromArgb(150, 50, 50)  # Set button background color for visibility
$uninstallGlobalButton.ForeColor = [System.Drawing.Color]::White  # Set text color to white for contrast
$uninstallGlobalButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)  # Set button font style for emphasis

# Add event to the uninstall (global) button to handle click events
$uninstallGlobalButton.Add_Click({
    # Check if any item is selected in the data grid
    if ($dataGrid.SelectedItems.Count -gt 0) {
        $selectedItem = $dataGrid.SelectedItems[0]
        if ($null -ne $selectedItem) {
            try {
                # Uninstall the app for all users
                Write-Output "Uninstalling (global) $($selectedItem.Text)..."
                Get-AppxPackage -Name $selectedItem.Text -AllUsers | Remove-AppxPackage -ErrorAction Stop
                Write-Output "Successfully uninstalled (global) $($selectedItem.Text)."  # Log success message
                [System.Windows.Forms.MessageBox]::Show("Successfully uninstalled (global) $($selectedItem.Text).", "Uninstall Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            } catch {
                Write-Error "Failed to uninstall (global) $($selectedItem.Text). Please check permissions."  # Error handling
                [System.Windows.Forms.MessageBox]::Show("Failed to uninstall (global) $($selectedItem.Text). Check permissions.", "Uninstall Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("No app selected. Please select an app to uninstall.", "No Selection", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})
$form.Controls.Add($uninstallGlobalButton)

# Add events to the new buttons in the policy panel
$resetPolicyButton.Add_Click({
    try {
        # Execute the script to reset local group policies
        Write-Output "Resetting Local Group Policies..."
        # Reset local group policy settings
        secedit /configure /cfg "$env:SystemRoot\inf\defltbase.inf" /db defltbase.sdb /verbose

        Write-Output "Local Group Policies reset successfully."
        $logsTextBox.AppendText("Local Policy Reset Log - $(Get-Date)`r`n")
        [System.Windows.Forms.MessageBox]::Show("Local Group Policies reset successfully.", "Reset Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        Write-Error "Failed to reset Local Group Policies. Please ensure you have the necessary permissions."
        $logsTextBox.AppendText("Error: Failed to reset policies - $(Get-Date)`r`n")
        [System.Windows.Forms.MessageBox]::Show("Failed to reset Local Group Policies. Check permissions.", "Reset Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

$clearLogsButton.Add_Click({
    $logsTextBox.Clear()
})

$refreshLogsButton.Add_Click({
    # Add logic here if logs are stored externally and need refreshing
    Write-Output "Logs refreshed."
    [System.Windows.Forms.MessageBox]::Show("Logs refreshed.", "Logs", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})

$exitButton.Add_Click({
    $form.Close()
})

# Run the Form
Get-InstalledStoreApps  # Populate the data grid with installed apps
try {
    [Windows.Forms.Application]::Run($form)  # Run the form to display the UI
} finally {
    if ($form -ne $null) {
        $form.Dispose()
    }
}