# Load required assemblies for WPF
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# Define XAML for the WPF window
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Toggle Legacy Context Menu" Height="200" Width="400">
    <Grid>
        <Button Name="ToggleButton" Width="200" Height="50" VerticalAlignment="Center" HorizontalAlignment="Center" Content="Toggle Legacy Context Menu"/>
    </Grid>
</Window>
"@

# Load XAML
$xmlReader = [System.Xml.XmlReader]::Create((New-Object System.IO.StringReader $XAML))
$window = [Windows.Markup.XamlReader]::Load($xmlReader)

# Function to toggle legacy context menu
function Toggle-LegacyContextMenu {
    $regPath = "HKCU:\Software\Classes\CLSID"
    $keyName = "{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
    $subKeyName = "InProcServer32"
    
    # Check if the registry key exists
    if (Test-Path "$regPath\$keyName") {
        # If exists, remove it to disable legacy context menu
        Remove-Item -Path "$regPath\$keyName" -Recurse
        [System.Windows.MessageBox]::Show("Legacy Context Menu Enabled. Please restart your Explorer.", "Info", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } else {
        # If not exists, create it to enable legacy context menu
        New-Item -Path "$regPath\$keyName\$subKeyName" | Out-Null
        [System.Windows.MessageBox]::Show("Legacy Context Menu Disabled. Please restart your Explorer.", "Info", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    }
    
    # Restart Explorer to apply changes
    Stop-Process -Name explorer -Force
}

# Attach click event to the toggle button
$window.FindName("ToggleButton").Add_Click({
    Toggle-LegacyContextMenu
})

# Show the WPF window
$window.ShowDialog()
