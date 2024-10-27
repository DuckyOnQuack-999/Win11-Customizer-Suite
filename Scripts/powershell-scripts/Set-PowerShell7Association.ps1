Add-Type -AssemblyName PresentationFramework
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if ($elevated) {
        Write-Host "Elevation attempt failed. Aborting."
        exit
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -ExecutionPolicy Bypass -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
        exit
    }
}
# Function to create the WPF window
function Create-WpfWindow {
    $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Select PowerShell 7 Executable" Height="150" Width="400">
    <Grid>
        <TextBox Name="PwshPath" Width="300" Height="25" Margin="10,10,10,0" VerticalAlignment="Top" HorizontalAlignment="Left"/>
        <Button Name="BrowseButton" Width="75" Height="25" Margin="320,10,10,0" VerticalAlignment="Top" HorizontalAlignment="Left" Content="Browse"/>
        <Button Name="OkButton" Width="75" Height="25" Margin="10,50,0,0" VerticalAlignment="Top" HorizontalAlignment="Left" Content="OK"/>
        <Button Name="CancelButton" Width="75" Height="25" Margin="90,50,0,0" VerticalAlignment="Top" HorizontalAlignment="Left" Content="Cancel"/>
    </Grid>
</Window>
"@

    $stringReader = New-Object System.IO.StringReader $xaml
    $xmlReader = [System.Xml.XmlReader]::Create($stringReader)
    $window = [Windows.Markup.XamlReader]::Load($xmlReader)
    return $window
}

# Show the OpenFileDialog
function Show-OpenFileDialog {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.InitialDirectory = "C:\"
    $openFileDialog.Filter = "Executable files (*.exe)|*.exe|All files (*.*)|*.*"
    $openFileDialog.FilterIndex = 1
    $openFileDialog.Multiselect = $false

    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $openFileDialog.FileName
    } else {
        return $null
    }
}

# Create the WPF window
$window = Create-WpfWindow

# Get UI elements
$pwshPathTextBox = $window.FindName("PwshPath")
$browseButton = $window.FindName("BrowseButton")
$okButton = $window.FindName("OkButton")
$cancelButton = $window.FindName("CancelButton")

# Browse button click event
$browseButton.Add_Click({
    $selectedPath = Show-OpenFileDialog
    if ($selectedPath) {
        $pwshPathTextBox.Text = $selectedPath
    }
})

# OK button click event
$okButton.Add_Click({
    if ($pwshPathTextBox.Text -and (Test-Path $pwshPathTextBox.Text)) {
        $global:pwshPath = $pwshPathTextBox.Text
        $window.Close()
    } else {
        [System.Windows.MessageBox]::Show("Please select a valid PowerShell 7 executable.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
})

# Cancel button click event
$cancelButton.Add_Click({
    $window.Close()
})

# Show the window
$window.ShowDialog()

# Proceed if a valid path was selected
if ($global:pwshPath) {
    # Update .ps1 default association
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\.ps1" -Name "(Default)" -Value "Microsoft.PowerShellScript.7" -Force

    # Create new registry key for Microsoft.PowerShellScript.7
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.7" -Force

    # Set the default value for Microsoft.PowerShellScript.7
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.7" -Name "(Default)" -Value "Windows PowerShell 7 Script" -Force

    # Create and set the DefaultIcon subkey
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.7\DefaultIcon" -Force
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.7\DefaultIcon" -Name "(Default)" -Value "$global:pwshPath,-1" -Force

    # Create and set the Shell\open\command subkey
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.7\Shell\open\command" -Force
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.7\Shell\open\command" -Name "(Default)" -Value "`"$global:pwshPath`" `"%1`"" -Force

    # Create and set the Shell\edit\command subkey
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.7\Shell\edit\command" -Force
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.7\Shell\edit\command" -Name "(Default)" -Value "`"C:\Windows\System32\notepad.exe`" `"%1`"" -Force

    [System.Windows.MessageBox]::Show("Registry settings updated to associate .ps1 files with PowerShell 7.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
} else {
    [System.Windows.MessageBox]::Show("No valid PowerShell 7 executable selected. Script will exit.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
}



pause