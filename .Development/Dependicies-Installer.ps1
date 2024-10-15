# Load .NET assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName WindowsBase

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Fancy Installer GUI"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# Enable acrylic effect (Windows 10 or later)
$form.BackColor = [System.Drawing.Color]::FromArgb(255, 245, 245, 245)
$form.Opacity = 0.85
$form.BackgroundImageLayout = 'Stretch'

# Load Windows API to enable acrylic blur from an external script or module
. "./AcrylicHelper.ps1"

$handle = $form.Handle
$accent = New-Object WinAPI.AcrylicHelper+AccentPolicy
$accent.AccentState = [WinAPI.AcrylicHelper+AccentState]::ACCENT_ENABLE_ACRYLICBLURBEHIND
$accent.AccentFlags = 2
$accent.GradientColor = 0x99FFFFFF # White with opacity
$accentPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal([System.Runtime.InteropServices.Marshal]::SizeOf($accent))
[System.Runtime.InteropServices.Marshal]::StructureToPtr($accent, $accentPtr, $false)
$attributeData = New-Object WinAPI.AcrylicHelper+WindowCompositionAttributeData
$attributeData.Attribute = [WinAPI.AcrylicHelper+WindowCompositionAttribute]::WCA_ACCENT_POLICY
$attributeData.SizeOfData = [System.Runtime.InteropServices.Marshal]::SizeOf($accent)
$attributeData.Data = $accentPtr
[WinAPI.AcrylicHelper]::SetWindowCompositionAttribute($handle, [ref]$attributeData)
[System.Runtime.InteropServices.Marshal]::FreeHGlobal($accentPtr)

# Create a text box to act as a console
$consoleBox = New-Object System.Windows.Forms.TextBox
$consoleBox.Multiline = $true
$consoleBox.ReadOnly = $true
$consoleBox.ScrollBars = "Vertical"
$consoleBox.Size = New-Object System.Drawing.Size(540, 180)
$consoleBox.Location = New-Object System.Drawing.Point(20, 180)
$consoleBox.BackColor = [System.Drawing.Color]::Black
$consoleBox.ForeColor = [System.Drawing.Color]::Lime
$form.Controls.Add($consoleBox)

# Create buttons for each option
$dotNetButton = New-Object System.Windows.Forms.Button
$dotNetButton.Text = ".NET Framework"
$dotNetButton.Size = New-Object System.Drawing.Size(160, 50)
$dotNetButton.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($dotNetButton)

$cPlusPlusButton = New-Object System.Windows.Forms.Button
$cPlusPlusButton.Text = "C++ Redistributable"
$cPlusPlusButton.Size = New-Object System.Drawing.Size(160, 50)
$cPlusPlusButton.Location = New-Object System.Drawing.Point(20, 80)
$form.Controls.Add($cPlusPlusButton)

$directXButton = New-Object System.Windows.Forms.Button
$directXButton.Text = "DirectX"
$directXButton.Size = New-Object System.Drawing.Size(160, 50)
$directXButton.Location = New-Object System.Drawing.Point(20, 140)
$form.Controls.Add($directXButton)

# Error handler function
function Handle-Error {
	param ($message)
	[System.Windows.Forms.MessageBox]::Show($message, "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
	$consoleBox.AppendText("Error: $message`r`n")
}

# Button click event handlers
$dotNetButton.Add_Click({
	try {
		$consoleBox.AppendText("Checking .NET Framework...`r`n")
		# Logic to check if .NET Framework installer is online
		$netInstaller = "https://dotnet.microsoft.com/download/dotnet-framework/thank-you/net48-web-installer"
		$response = Invoke-WebRequest -Uri $netInstaller -Method Head -ErrorAction Stop
		if ($response.StatusCode -eq 200) {
			$output = "C:\Temp\net-framework-installer.exe"
			Invoke-WebRequest -Uri $netInstaller -OutFile $output
			Start-Process -FilePath $output -ArgumentList "/quiet /norestart" -Wait
			$consoleBox.AppendText(".NET Framework is up to date or has been updated.`r`n")
		} else {
			Handle-Error "Failed to locate .NET Framework installer online."
		}
	} catch {
		Handle-Error "Failed to update .NET Framework: $($_.Exception.Message)"
	}
})

$cPlusPlusButton.Add_Click({
	try {
		$consoleBox.AppendText("Checking C++ Redistributable...`r`n")
		# Logic to check if C++ Redistributable installer is online
		$cPlusPlusInstaller = "https://aka.ms/vs/16/release/vc_redist.x64.exe"
		$response = Invoke-WebRequest -Uri $cPlusPlusInstaller -Method Head -ErrorAction Stop
		if ($response.StatusCode -eq 200) {
			$output = "C:\Temp\vc_redist.x64.exe"
			Invoke-WebRequest -Uri $cPlusPlusInstaller -OutFile $output
			Start-Process -FilePath $output -ArgumentList "/quiet /norestart" -Wait
			$consoleBox.AppendText("C++ Redistributable is up to date or has been updated.`r`n")
		} else {
			Handle-Error "Failed to locate C++ Redistributable installer online."
		}
	} catch {
		Handle-Error "Failed to update C++ Redistributable: $($_.Exception.Message)"
	}
})

$directXButton.Add_Click({
	try {
		$consoleBox.AppendText("Checking DirectX...`r`n")
		# Logic to check if DirectX installer is online
		$directXInstaller = "https://download.microsoft.com/download/9/3/7/937FE885-9AFA-40AB-A35E-4E850F3972D3/directx_Jun2010_redist.exe"
		$response = Invoke-WebRequest -Uri $directXInstaller -Method Head -ErrorAction Stop
		if ($response.StatusCode -eq 200) {
			$output = "C:\Temp\directx_installer.exe"
			Invoke-WebRequest -Uri $directXInstaller -OutFile $output
			Start-Process -FilePath $output -ArgumentList "/quiet" -Wait
			$consoleBox.AppendText("DirectX is up to date or has been updated.`r`n")
		} else {
			Handle-Error "Failed to locate DirectX installer online."
		}
	} catch {
		Handle-Error "Failed to update DirectX: $($_.Exception.Message)"
	}
})

# Show the form
[void]$form.ShowDialog()