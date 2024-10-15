Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to get the potential installation paths of Edge based on the selected version
function Get-EdgePaths {
	param (
		[string]$edgeVersion
	)
	# Define a dictionary for version paths
	$versionPaths = @{
		'Canary' = @(
			"$env:LOCALAPPDATA\Microsoft\Edge SxS\Application\msedge.exe",
			"C:\Program Files (x86)\Microsoft\Edge SxS\Application\msedge.exe"
		);
		'Dev' = @(
			"$env:LOCALAPPDATA\Microsoft\Edge Dev\Application\msedge.exe",
			"C:\Program Files (x86)\Microsoft\Edge Dev\Application\msedge.exe"
		);
		'Beta' = @(
			"$env:LOCALAPPDATA\Microsoft\Edge Beta\Application\msedge.exe",
			"C:\Program Files (x86)\Microsoft\Edge Beta\Application\msedge.exe"
		);
		'Stable' = @(
			"$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe",
			"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
		)
	}
	
	# Return paths for the selected version if available
	if ($versionPaths.ContainsKey($edgeVersion)) {
		return $versionPaths[$edgeVersion]
	} else {
		# Handle invalid version input
		Write-Host "Invalid version selected."
		exit
	}
}

# Create the form for selecting the Edge version with modern, material-like appearance
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select Edge Version"
# Set the form size to be larger to accommodate content comfortably
$form.Size = New-Object System.Drawing.Size(650, 650)
$form.StartPosition = "CenterScreen"  # Center the form on the screen

# Apply material design styles
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)  # Dark background color for modern look
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.ForeColor = [System.Drawing.Color]::White  # White text color for readability

# Create a label for the dropdown
$label = New-Object System.Windows.Forms.Label
$label.Text = "Select the Edge version you have installed:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20, 20)  # Set the position of the label
$label.ForeColor = [System.Drawing.Color]::White  # White text color
$label.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)  # Use a modern font
$form.Controls.Add($label)

# Create a dropdown list (ComboBox) for Edge version selection
$edgeVersions = @('Canary', 'Dev', 'Beta', 'Stable')
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(20, 60)  # Set the position of the ComboBox
$comboBox.Size = New-Object System.Drawing.Size(600, 40)  # Set the size of the ComboBox to be wider
$comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList  # Set to dropdown list (non-editable)
$comboBox.Items.AddRange($edgeVersions)  # Add the Edge version options to the ComboBox
$comboBox.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)  # Dark background for ComboBox
$comboBox.ForeColor = [System.Drawing.Color]::White  # White text color for ComboBox
$comboBox.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)  # Use a modern font
$form.Controls.Add($comboBox)

# Create OK button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Location = New-Object System.Drawing.Point(100, 500)  # Set the position of the OK button
$okButton.Size = New-Object System.Drawing.Size(150, 50)
$okButton.BackColor = [System.Drawing.Color]::FromArgb(70, 130, 180)  # SteelBlue color for button
$okButton.ForeColor = [System.Drawing.Color]::White  # White text color for button
$okButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$okButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)  # Use a bold modern font
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK  # Set the result when OK is clicked
$form.Controls.Add($okButton)

# Create Cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Location = New-Object System.Drawing.Point(320, 500)  # Set the position of the Cancel button
$cancelButton.Size = New-Object System.Drawing.Size(150, 50)
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb(192, 57, 43)  # Dark red color for button
$cancelButton.ForeColor = [System.Drawing.Color]::White  # White text color for button
$cancelButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$cancelButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)  # Use a bold modern font
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel  # Set the result when Cancel is clicked
$form.Controls.Add($cancelButton)

# Set the form's Accept and Cancel buttons
$form.AcceptButton = $okButton
$form.CancelButton = $cancelButton

# Show the form and get the result
$result = $form.ShowDialog()

# Check if the user clicked OK and made a valid selection
if ($result -ne [System.Windows.Forms.DialogResult]::OK -or [string]::IsNullOrEmpty($comboBox.SelectedItem)) {
	Write-Host "Operation cancelled by user."
	exit
}

# Get the selected Edge version
$edgeVersion = $comboBox.SelectedItem

# Get potential paths using the function
$potentialPaths = Get-EdgePaths -edgeVersion $edgeVersion

# Find the valid path using 'FirstOrDefault' logic
$targetPath = $potentialPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

# If no valid path is found, exit with an error message
if (-not $targetPath) {
	Write-Host "Edge executable not found in the expected locations. Please verify your installation."
	exit
}

# Define the shortcut path, arguments, working directory, and icon location
$shortcutPath = "$env:USERPROFILE\Desktop\Edge $edgeVersion Acrylic.lnk"
$arguments = "--enable-features=msEdgeVisualRejuvAcrylicForNativeSurfaces,msEdgeVisualRejuvAcrylicForWebUi2,msShowRevampedThemesInSettingsAppearance"
$workingDirectory = [System.IO.Path]::GetDirectoryName($targetPath)
$iconLocation = $targetPath

# Create a new WScript.Shell COM object
$shell = New-Object -ComObject WScript.Shell

try {
	# Create a new shortcut object
	if (-not (Test-Path $shortcutPath)) {
		$shortcut = $shell.CreateShortcut($shortcutPath)
	} else {
		throw "Shortcut already exists at $shortcutPath"
	}

	# Set the shortcut properties
	$shortcut.TargetPath = $targetPath
	$shortcut.Arguments = $arguments
	$shortcut.WorkingDirectory = $workingDirectory

	# Validate icon path and set IconLocation
	if (Test-Path $iconLocation) {
		$shortcut.IconLocation = $iconLocation  # Set the icon location if the path is valid
	} else {
		Write-Host "Icon path is invalid. Using default icon."  # Output a message if the icon path is invalid
	}

	# Save the shortcut
	$shortcut.Save()

	# Output success message
	Write-Host "Shortcut created successfully at: $shortcutPath"
} catch {
	Write-Host "An error occurred while creating the shortcut: $_"
}
