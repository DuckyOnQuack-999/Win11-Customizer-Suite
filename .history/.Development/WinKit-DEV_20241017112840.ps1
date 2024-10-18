Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="WinKit - Windows Maintenance Toolkit" Height="800" Width="1200"
    Background="#FF121212" Foreground="White">
    <Window.Resources>
        <Style x:Key="MaterialButton" TargetType="Button">
            <Setter Property="Background" Value="#FF1E1E1E"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="16,8"/>
            <Setter Property="Margin" Value="0,0,0,8"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#FF2A2A2A"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="250"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="250"/>
        </Grid.RowDefinitions>

        <!-- App Bar -->
        <Border Grid.ColumnSpan="2" Background="#FFD32F2F" Padding="16">
            <TextBlock Text="WinKit" FontSize="24" FontWeight="Bold" Foreground="White"/>
        </Border>

        <!-- Side Panel -->
        <StackPanel Grid.Column="0" Grid.Row="1" Grid.RowSpan="2" Background="#FF1E1E1E" Margin="0,16,0,0">
            <Button x:Name="SystemOptimizationButton" Content="System Optimization" Style="{StaticResource MaterialButton}"/>
            <Button x:Name="CleanupButton" Content="Cleanup" Style="{StaticResource MaterialButton}"/>
            <Button x:Name="SecurityButton" Content="Security" Style="{StaticResource MaterialButton}"/>
            <Button x:Name="UpdatesButton" Content="Updates" Style="{StaticResource MaterialButton}"/>
            <Button x:Name="SettingsButton" Content="Settings" Style="{StaticResource MaterialButton}"/>
            <Button x:Name="AboutButton" Content="About" Style="{StaticResource MaterialButton}"/>
            <Separator Margin="16,16,16,16" Background="#FF333333"/>
            <Button x:Name="RepairAppsButton" Content="Repair Apps" Style="{StaticResource MaterialButton}"/>
            <Button x:Name="LocalPolicyButton" Content="Local Group Policy" Style="{StaticResource MaterialButton}"/>
            <Button x:Name="InstallersButton" Content="Installers" Style="{StaticResource MaterialButton}"/>
        </StackPanel>

        <!-- Main Content Area -->
        <Grid Grid.Column="1" Grid.Row="1" Margin="16">
            <!-- Existing panels go here (SystemOptimizationPanel, CleanupPanel, etc.) -->
            <!-- ... (keep all existing panels) ... -->
        </Grid>

        <!-- Windows Terminal-like Component -->
        <Grid Grid.Column="1" Grid.Row="2" Margin="16,0,16,16">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <StackPanel Orientation="Horizontal" Grid.Row="0" Margin="0,0,0,8">
                <TextBlock Text="Terminal Output" FontWeight="Bold" VerticalAlignment="Center" Margin="0,0,16,0"/>
                <ComboBox x:Name="LogLevelComboBox" Width="120" SelectedIndex="0" Margin="0,0,16,0">
                    <ComboBoxItem Content="All"/>
                    <ComboBoxItem Content="Error"/>
                    <ComboBoxItem Content="Debug"/>
                    <ComboBoxItem Content="Status"/>
                    <ComboBoxItem Content="Verbose"/>
                </ComboBox>
                <Button x:Name="ClearTerminalButton" Content="Clear" Width="80" Style="{StaticResource MaterialButton}" Background="#FFD32F2F"/>
            </StackPanel>
            <RichTextBox x:Name="TerminalOutput" Grid.Row="1" Background="#FF0A0A0A" Foreground="#FFF1F1F1" FontFamily="Consolas" IsReadOnly="True" VerticalScrollBarVisibility="Auto" Padding="8">
                <RichTextBox.Resources>
                    <Style TargetType="{x:Type Paragraph}">
                        <Setter Property="Margin" Value="0"/>
                    </Style>
                </RichTextBox.Resources>
            </RichTextBox>
        </Grid>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get all named elements
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
    New-Variable -Name $_.Name -Value $window.FindName($_.Name) -Force
}

# Terminal output function with syntax highlighting
function Write-TerminalOutput {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet("Error", "Debug", "Status", "Verbose")]
        [string]$LogLevel,

        [Parameter(Mandatory=$false)]
        [switch]$Syntax
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $paragraph = New-Object System.Windows.Documents.Paragraph

    $levelRun = New-Object System.Windows.Documents.Run
    $levelRun.Text = "[$timestamp] [$LogLevel] "
    $levelRun.Foreground = switch ($LogLevel) {
        "Error"   { "#FFFF5252" }
        "Debug"   { "#FFFFAB40" }
        "Status"  { "#FF69F0AE" }
        "Verbose" { "#FF40C4FF" }
    }
    $paragraph.Inlines.Add($levelRun)

    if ($Syntax) {
        # Simple syntax highlighting (can be expanded for more complex highlighting)
        $words = $Message -split ' '
        foreach ($word in $words) {
            $run = New-Object System.Windows.Documents.Run
            $run.Text = "$word "
            
            if ($word -match '^(function|param|if|else|foreach|switch)$') {
                $run.Foreground = "#FF9C27B0"  # Purple for keywords
            }
            elseif ($word -match '^\$') {
                $run.Foreground = "#FFFFEB3B"  # Yellow for variables
            }
            elseif ($word -match '^".*"$') {
                $run.Foreground = "#FF4CAF50"  # Green for strings
            }
            else {
                $run.Foreground = "#FFF1F1F1"  # Default color
            }
            
            $paragraph.Inlines.Add($run)
        }
    }
    else {
        $messageRun = New-Object System.Windows.Documents.Run
        $messageRun.Text = $Message
        $messageRun.Foreground = "#FFF1F1F1"
        $paragraph.Inlines.Add($messageRun)
    }

    $paragraph.Inlines.Add((New-Object System.Windows.Documents.LineBreak))

    $dispatcher = $TerminalOutput.Dispatcher
    $dispatcher.Invoke([Action]{
        $TerminalOutput.Document.Blocks.Add($paragraph)
        $TerminalOutput.ScrollToEnd()
    })
}

# Modify existing functions to use the new terminal output
function Get-InstalledStoreApps {
    Write-TerminalOutput -Message "Fetching installed Store apps..." -LogLevel Status
    $apps = Get-AppxPackage | Where-Object { $_.IsFramework -eq $false } | Select-Object Name, Version, @{Name="Status";Expression={"Installed"}}
    $AppListView.ItemsSource = $apps
    Write-TerminalOutput -Message "Fetched $(($apps | Measure-Object).Count) installed Store apps." -LogLevel Verbose
    Write-TerminalOutput -Message "function Get-InstalledStoreApps { `$apps = Get-AppxPackage | Where-Object { `$_.IsFramework -eq `$false } }" -LogLevel Debug -Syntax
}

function Repair-StoreApp {
    param ($appName)
    try {
        Write-TerminalOutput -Message "Attempting to repair app: $appName" -LogLevel Status
        Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction Stop
        Add-AppxPackage -Register -DisableDevelopmentMode (Get-AppxPackage -AllUsers -Name $appName).InstallLocation + "\AppxManifest.xml" -ErrorAction Stop
        Write-TerminalOutput -Message "Repair process completed for $appName." -LogLevel Status
        [System.Windows.MessageBox]::Show("Repair process completed for $appName.", "Repair Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Write-TerminalOutput -Message "Failed to repair the app $appName. Error: $($_.Exception.Message)" -LogLevel Error
        [System.Windows.MessageBox]::Show("Failed to repair the app $appName. Error: $($_.Exception.Message)", "Repair Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# ... (modify other existing functions to use Write-TerminalOutput) ...

# Event handler for log level filter
$LogLevelComboBox.Add_SelectionChanged({
    $selectedLevel = $LogLevelComboBox.SelectedItem.Content
    $TerminalOutput.Document.Blocks.Clear()
    # Re-populate with filtered logs (implementation depends on how you want to store/retrieve past logs)
})

# Event handler for clear terminal button
$ClearTerminalButton.Add_Click({
    $TerminalOutput.Document.Blocks.Clear()
})

# ... (keep all other existing event handlers) ...

# Initial terminal message
Write-TerminalOutput -Message "WinKit initialized. Ready for operations." -LogLevel Status
Write-TerminalOutput -Message "`$winkit = New-Object WinKit" -LogLevel Debug -Syntax

# Show the window
$window.ShowDialog() | Out-Null