Add-Type -AssemblyName PresentationFramework

# Define XAML for the GUI
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="MSIXBundle Installer" Height="200" Width="400">
    <Grid>
        <Label Content="Enter the path to the .msixbundle file:" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="10,10,0,0"/>
        <TextBox Name="PathTextBox" HorizontalAlignment="Left" VerticalAlignment="Top" Width="360" Margin="10,40,0,0"/>
        <Button Content="Browse" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Margin="310,70,0,0" Name="BrowseButton"/>
        <Button Content="Install" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Margin="10,100,0,0" Name="InstallButton"/>
        <Label Name="StatusLabel" Content="" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="10,140,0,0"/>
    </Grid>
</Window>
"@

$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Find controls in the GUI
$pathTextBox = $window.FindName("PathTextBox")
$browseButton = $window.FindName("BrowseButton")
$installButton = $window.FindName("InstallButton")
$statusLabel = $window.FindName("StatusLabel")

# Browse button click event
$browseButton.Add_Click({
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "MSIXBundle files (*.msixbundle)|*.msixbundle"
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $pathTextBox.Text = $dialog.FileName
    }
})

# Install button click event
$installButton.Add_Click({
    $filePath = $pathTextBox.Text
    if (-Not (Test-Path -Path $filePath)) {
        $statusLabel.Content = "Invalid path. Please select a valid .msixbundle file."
        return
    }

    try {
        Add-AppxPackage -Path $filePath
        $statusLabel.Content = "Installation completed successfully."
    } catch {
        $statusLabel.Content = "Failed to install the package. Error: $_"
    }
})

# Show the window
$window.ShowDialog() | Out-Null
