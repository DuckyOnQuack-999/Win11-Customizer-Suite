Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="WinKit" Height="700" Width="900"
    Background="#121212" Foreground="White">
    <Window.Resources>
        <Style x:Key="MenuButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Height" Value="40"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderThickness="0">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="20,0,0,0"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#FF424242"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="220"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- Side Panel -->
        <StackPanel Grid.Column="0" Background="#212121">
            <TextBlock Text="WinKit" FontSize="24" FontWeight="Bold" Margin="20,20,0,30" Foreground="#FF5252"/>
            <Button x:Name="RepairAppsButton" Content="Repair Apps" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="LocalPolicyButton" Content="Local Group Policy" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="InstallersButton" Content="Installers" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="TweaksButton" Content="Tweaks" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="OptimizationButton" Content="Optimization" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="PrivacyButton" Content="Privacy" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="SettingsButton" Content="Settings" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="AboutButton" Content="About" Style="{StaticResource MenuButtonStyle}"/>
        </StackPanel>

        <!-- Main Content Area -->
        <Grid Grid.Column="1" Margin="20">
            <!-- Repair Apps Panel -->
            <Grid x:Name="RepairAppsPanel" Visibility="Visible">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <TextBox x:Name="SearchBox" Grid.Row="0" Margin="0,0,0,10" Background="#424242" Foreground="White" BorderBrush="#FF5252"/>

                <ListView x:Name="AppListView" Grid.Row="1" Background="#424242" Foreground="White" BorderBrush="#FF5252">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn Header="App Name" Width="300" DisplayMemberBinding="{Binding Name}"/>
                            <GridViewColumn Header="Version" Width="150" DisplayMemberBinding="{Binding Version}"/>
                            <GridViewColumn Header="Status" Width="200" DisplayMemberBinding="{Binding Status}"/>
                        </GridView>
                    </ListView.View>
                </ListView>

                <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
                    <Button x:Name="UninstallGlobalButton" Content="Uninstall (Global)" Width="150" Height="40" Margin="0,0,10,0" Background="#FF5252" Foreground="White"/>
                    <Button x:Name="UninstallLocalButton" Content="Uninstall (Local)" Width="150" Height="40" Margin="0,0,10,0" Background="#FF5252" Foreground="White"/>
                    <Button x:Name="RepairButton" Content="Repair Selected" Width="150" Height="40" Background="#FF5252" Foreground="White"/>
                </StackPanel>
            </Grid>

            <!-- Local Group Policy Reset Tool Panel -->
            <Grid x:Name="PolicyPanel" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <TextBox x:Name="LogsTextBox" Grid.Row="0" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" Background="#424242" Foreground="White"/>

                <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
                    <Button x:Name="ResetPolicyButton" Content="Reset Local Group Policy" Width="200" Height="40" Margin="0,0,10,0" Background="#FF5252" Foreground="White"/>
                    <Button x:Name="ClearLogsButton" Content="Clear Logs" Width="150" Height="40" Margin="0,0,10,0" Background="#FF5252" Foreground="White"/>
                    <Button x:Name="RefreshLogsButton" Content="Refresh Logs" Width="150" Height="40" Background="#FF5252" Foreground="White"/>
                </StackPanel>
            </Grid>

            <!-- Installers Panel -->
            <StackPanel x:Name="InstallersPanel" Visibility="Collapsed">
                <Button x:Name="InstallVisualCppButton" Content="Install Visual C++ Redistributables" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="InstallDirectXButton" Content="Install DirectX" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="InstallDotNetButton" Content="Install .NET SDKs" Width="300" Height="40" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Tweaks Panel -->
            <StackPanel x:Name="TweaksPanel" Visibility="Collapsed">
                <TextBlock Text="Tweaks" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <Button Content="Disable Telemetry" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button Content="Enable Dark Mode" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button Content="Disable Cortana" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Optimization Panel -->
            <StackPanel x:Name="OptimizationPanel" Visibility="Collapsed">
                <TextBlock Text="Optimization" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <Button Content="Clean Temporary Files" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button Content="Defragment Drives" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button Content="Optimize Startup" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Privacy Panel -->
            <StackPanel x:Name="PrivacyPanel" Visibility="Collapsed">
                <TextBlock Text="Privacy" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <Button Content="Disable Activity History" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button Content="Manage App Permissions" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button Content="Clear Browsing Data" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Settings Panel -->
            <StackPanel x:Name="SettingsPanel" Visibility="Collapsed">
                <TextBlock Text="Settings" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <CheckBox Content="Enable Dark Mode" Margin="0,0,0,10" Foreground="White"/>
                <CheckBox Content="Run at Startup" Margin="0,0,0,10" Foreground="White"/>
                <CheckBox Content="Check for Updates Automatically" Margin="0,0,0,10" Foreground="White"/>
                <ComboBox Width="300" Margin="0,0,0,10">
                    <ComboBoxItem Content="English" IsSelected="True"/>
                    <ComboBoxItem Content="Spanish"/>
                    <ComboBoxItem Content="French"/>
                </ComboBox>
                <Button Content="Save Settings" Width="300" Height="40" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- About Panel -->
            <StackPanel x:Name="AboutPanel" Visibility="Collapsed">
                <TextBlock Text="About WinKit" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <TextBlock Text="Version: 1.0.0" Margin="0,0,0,10"/>
                <TextBlock Text="WinKit is a comprehensive Windows utility tool designed to help users manage, optimize, and customize their Windows experience." TextWrapping="Wrap" Margin="0,0,0,10"/>
                <Button Content="Check for Updates" Width="300" Height="40" Background="#FF5252" Foreground="White"/>
            </StackPanel>
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

# Function to populate the ListView with installed apps
function Get-InstalledStoreApps {
    $apps = Get-AppxPackage | Where-Object { $_.IsFramework -eq $false } | Select-Object Name, Version, @{Name="Status";Expression={"Installed"}}
    $AppListView.ItemsSource = $apps
}

# Function to repair a specific store app
function Repair-StoreApp {
    param ($appName)
    try {
        Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction Stop
        Add-AppxPackage -Register -DisableDevelopmentMode (Get-AppxPackage -AllUsers -Name $appName).InstallLocation + "\AppxManifest.xml" -ErrorAction Stop
        [System.Windows.MessageBox]::Show("Repair process completed for $appName.", "Repair Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        [System.Windows.MessageBox]::Show("Failed to repair the app $appName. Error: $($_.Exception.Message)", "Repair Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to uninstall an app
function Uninstall-App {
    param ($appName, $isGlobal)
    try {
        if ($isGlobal) {
            Get-AppxPackage -Name $appName -AllUsers | Remove-AppxPackage -ErrorAction Stop
        } else {
            Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction Stop
        }
        [System.Windows.MessageBox]::Show("Successfully uninstalled $appName.", "Uninstall Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        Get-InstalledStoreApps
    } catch {
        [System.Windows.MessageBox]::Show("Failed to uninstall $appName. Error: $($_.Exception.Message)", "Uninstall Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to reset local group policies
function Reset-LocalGroupPolicy {
    try {
        secedit /configure /cfg $env:SystemRoot\inf\defltbase.inf /db defltbase.sdb /verbose
        $LogsTextBox.AppendText("Local Group Policies reset successfully. - $(Get-Date)`r`n")
        [System.Windows.MessageBox]::Show("Local Group Policies reset successfully.", "Reset Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        $LogsTextBox.AppendText("Error: Failed to reset policies - $(Get-Date)`r`n$($_.Exception.Message)`r`n")
        [System.Windows.MessageBox]::Show("Failed to reset Local Group Policies. Check permissions.", "Reset Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to install Visual C++ Redistributables
function Install-VisualCppRedistributable {
    try {
        $url = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        $outPath = "$env:TEMP\vc_redist.x64.exe"
        Invoke-WebRequest -Uri $url -OutFile $outPath
        Start-Process -FilePath $outPath -ArgumentList "/install", "/passive", "/norestart" -Wait
        Remove-Item $outPath
        [System.Windows.MessageBox]::Show("Visual C++ Redistributables installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch  {
        [System.Windows.MessageBox]::Show("Failed to install Visual C++ Redistributables. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to install DirectX
function Install-DirectX {
    try {
        $url = "https://download.microsoft.com/download/1/6/4/1644D52A-633F-4C5F-A119-A2EE0D3FA9A6/directx_Jun2010_redist.exe"
        $outPath = "$env:TEMP\directx_redist.exe"
        $extractPath = "$env:TEMP\directx_redist"
        Invoke-WebRequest -Uri $url -OutFile $outPath
        Start-Process -FilePath $outPath -ArgumentList "/Q", "/T:$extractPath" -Wait
        Start-Process -FilePath "$extractPath\DXSETUP.exe" -ArgumentList "/silent" -Wait
        Remove-Item $outPath
        Remove-Item $extractPath -Recurse
        [System.Windows.MessageBox]::Show("DirectX installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        [System.Windows.MessageBox]::Show("Failed to install DirectX. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to install .NET SDKs
function Install-DotNetSDKs {
    try {
        $channels = @("1.0", "1.1", "2.0", "2.1", "3.0", "3.1", "5.0", "6.0", "7.0", "8.0", "9.0", "STS")
        $scriptUrl = "https://dot.net/v1/dotnet-install.ps1"
        $scriptPath = "$env:TEMP\dotnet-install.ps1"
        Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

        foreach ($channel in $channels) {
            & $scriptPath -Channel $channel
        }

        $packages = @("Microsoft.DotNet.SDK.5", "Microsoft.DotNet.SDK.6", "Microsoft.DotNet.SDK.7", "Microsoft.DotNet.SDK.8", "Microsoft.DotNet.SDK.Preview")
        foreach ($package in $packages) {
            Start-Process "winget" -ArgumentList "install --id $package --silent --accept-package-agreements --accept-source-agreements" -Wait
        }

        [Environment]::SetEnvironmentVariable("DOTNET_ROOT", "C:\Program Files\dotnet", "Machine")
        $path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
        if ($path -notlike "*C:\Program Files\dotnet*") {
            [Environment]::SetEnvironmentVariable("PATH", "$path;C:\Program Files\dotnet", "Machine")
        }

        Remove-Item $scriptPath
        [System.Windows.MessageBox]::Show(".NET SDKs installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        [System.Windows.MessageBox]::Show("Failed to install .NET SDKs. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to switch panels
function Switch-Panel {
    param ($panelName)
    $RepairAppsPanel.Visibility   = "Collapsed"
    $PolicyPanel.Visibility       = "Collapsed"
    $InstallersPanel.Visibility   = "Collapsed"
    $TweaksPanel.Visibility       = "Collapsed"
    $OptimizationPanel.Visibility = "Collapsed"
    $PrivacyPanel.Visibility      = "Collapsed"
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="WinKit" Height="700" Width="1000"
    Background="#121212" Foreground="White">
    <Window.Resources>
        <Style x:Key="MenuButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Height" Value="40"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderThickness="0">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="20,0,0,0"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#FF424242"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="220"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
            <RowDefinition Height="200"/>
        </Grid.RowDefinitions>

        <!-- Side Panel -->
        <StackPanel Grid.Column="0" Grid.RowSpan="2" Background="#212121">
            <TextBlock Text="WinKit" FontSize="24" FontWeight="Bold" Margin="20,20,0,30" Foreground="#FF5252"/>
            <Button x:Name="RepairAppsButton" Content="Repair Apps" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="LocalPolicyButton" Content="Local Group Policy" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="InstallersButton" Content="Installers" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="TweaksButton" Content="Tweaks" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="OptimizationButton" Content="Optimization" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="PrivacyButton" Content="Privacy" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="SettingsButton" Content="Settings" Style="{StaticResource MenuButtonStyle}"/>
            <Button x:Name="AboutButton" Content="About" Style="{StaticResource MenuButtonStyle}"/>
        </StackPanel>

        <!-- Main Content Area -->
        <Grid Grid.Column="1" Grid.Row="0" Margin="20">
            <!-- Repair Apps Panel -->
            <Grid x:Name="RepairAppsPanel" Visibility="Visible">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <TextBox x:Name="SearchBox" Grid.Row="0" Margin="0,0,0,10" Background="#424242" Foreground="White" BorderBrush="#FF5252"/>

                <ListView x:Name="AppListView" Grid.Row="1" Background="#424242" Foreground="White" BorderBrush="#FF5252">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn Header="App Name" Width="300" DisplayMemberBinding="{Binding Name}"/>
                            <GridViewColumn Header="Version" Width="150" DisplayMemberBinding="{Binding Version}"/>
                            <GridViewColumn Header="Status" Width="200" DisplayMemberBinding="{Binding Status}"/>
                        </GridView>
                    </ListView.View>
                </ListView>

                <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
                    <Button x:Name="UninstallGlobalButton" Content="Uninstall (Global)" Width="150" Height="40" Margin="0,0,10,0" Background="#FF5252" Foreground="White"/>
                    <Button x:Name="UninstallLocalButton" Content="Uninstall (Local)" Width="150" Height="40" Margin="0,0,10,0" Background="#FF5252" Foreground="White"/>
                    <Button x:Name="RepairButton" Content="Repair Selected" Width="150" Height="40" Background="#FF5252" Foreground="White"/>
                </StackPanel>
            </Grid>

            <!-- Local Group Policy Reset Tool Panel -->
            <Grid x:Name="PolicyPanel" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <TextBox x:Name="LogsTextBox" Grid.Row="0" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" Background="#424242" Foreground="White"/>

                <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
                    <Button x:Name="ResetPolicyButton" Content="Reset Local Group Policy" Width="200" Height="40" Margin="0,0,10,0" Background="#FF5252" Foreground="White"/>
                    <Button x:Name="ClearLogsButton" Content="Clear Logs" Width="150" Height="40" Margin="0,0,10,0" Background="#FF5252" Foreground="White"/>
                    <Button x:Name="RefreshLogsButton" Content="Refresh Logs" Width="150" Height="40" Background="#FF5252" Foreground="White"/>
                </StackPanel>
            </Grid>

            <!-- Installers Panel -->
            <StackPanel x:Name="InstallersPanel" Visibility="Collapsed">
                <Button x:Name="InstallVisualCppButton" Content="Install Visual C++ Redistributables" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="InstallDirectXButton" Content="Install DirectX" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="InstallDotNetButton" Content="Install .NET SDKs" Width="300" Height="40" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Tweaks Panel -->
            <StackPanel x:Name="TweaksPanel" Visibility="Collapsed">
                <TextBlock Text="Tweaks" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <Button x:Name="DisableTelemetryButton" Content="Disable Telemetry" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableDarkModeButton" Content="Enable Dark Mode" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableCortanaButton" Content="Disable Cortana" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Optimization Panel -->
            <StackPanel x:Name="OptimizationPanel" Visibility="Collapsed">
                <TextBlock Text="Optimization" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <Button x:Name="CleanTempFilesButton" Content="Clean Temporary Files" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DefragmentDrivesButton" Content="Defragment Drives" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="OptimizeStartupButton" Content="Optimize Startup" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Privacy Panel -->
            <StackPanel x:Name="PrivacyPanel" Visibility="Collapsed">
                <TextBlock Text="Privacy" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <Button x:Name="DisableActivityHistoryButton" Content="Disable Activity History" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="ManageAppPermissionsButton" Content="Manage App Permissions" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="ClearBrowsingDataButton" Content="Clear Browsing Data" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Settings Panel -->
            <StackPanel x:Name="SettingsPanel" Visibility="Collapsed">
                <TextBlock Text="Settings" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <CheckBox x:Name="DarkModeCheckBox" Content="Enable Dark Mode" Margin="0,0,0,10" Foreground="White"/>
                <CheckBox x:Name="RunAtStartupCheckBox" Content="Run at Startup" Margin="0,0,0,10" Foreground="White"/>
                <CheckBox x:Name="CheckUpdatesCheckBox" Content="Check for Updates Automatically" Margin="0,0,0,10" Foreground="White"/>
                <ComboBox x:Name="LanguageComboBox" Width="300" Margin="0,0,0,10">
                    <ComboBoxItem Content="English" IsSelected="True"/>
                    <ComboBoxItem Content="Spanish"/>
                    <ComboBoxItem Content="French"/>
                </ComboBox>
                <Button x:Name="SaveSettingsButton" Content="Save Settings" Width="300" Height="40" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- About Panel -->
            <StackPanel x:Name="AboutPanel" Visibility="Collapsed">
                <TextBlock Text="About WinKit" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <TextBlock Text="Version: 1.0.0" Margin="0,0,0,10"/>
                <TextBlock Text="WinKit is a comprehensive Windows utility tool designed to help users manage, optimize, and customize their Windows experience." TextWrapping="Wrap" Margin="0,0,0,10"/>
                <Button x:Name="CheckUpdatesButton" Content="Check for Updates" Width="300" Height="40" Background="#FF5252" Foreground="White"/>
            </StackPanel>
        </Grid>

        <!-- Terminal Window -->
        <TextBox x:Name="TerminalWindow" Grid.Column="1" Grid.Row="1" Margin="20,10,20,20"
                 Background="#1E1E1E" Foreground="#E0E0E0" FontFamily="Consolas"
                 IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"
                 HorizontalScrollBarVisibility="Auto"/>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get all named elements
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
    New-Variable -Name $_.Name -Value $window.FindName($_.Name) -Force
}

# Function to log messages to the Terminal Window
function Log-Message {
    param (
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error")]
        [string]$Type = "Info"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Type] $Message"
    $TerminalWindow.AppendText("$logMessage`r`n")
    $TerminalWindow.ScrollToEnd()
}

# Function to populate the ListView with installed apps
function Get-InstalledStoreApps {
    Log-Message "Retrieving installed Store apps..."
    try {
        $apps = Get-AppxPackage | Where-Object { $_.IsFramework -eq $false } | Select-Object Name, Version, @{Name="Status";Expression={"Installed"}}
        $AppListView.ItemsSource = $apps
        Log-Message "Retrieved $(($apps | Measure-Object).Count) installed Store apps."
    } catch {
        Log-Message "Error retrieving installed Store apps: $($_.Exception.Message)" -Type Error
    }
}

# Function to repair a specific store app
function Repair-StoreApp {
    param ($appName)
    Log-Message "Attempting to repair app: $appName"
    try {
        Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction Stop
        Add-AppxPackage -Register -DisableDevelopmentMode (Get-AppxPackage -AllUsers -Name $appName).InstallLocation + "\AppxManifest.xml" -ErrorAction Stop
        Log-Message "Repair process completed for $appName."
        [System.Windows.MessageBox]::Show("Repair process completed for $appName.", "Repair Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to repair the app $appName. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to repair the app $appName. Error: $($_.Exception.Message)", "Repair Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to uninstall an app
function Uninstall-App {
    param ($appName, $isGlobal)
    $scope = if ($isGlobal) { "globally" } else { "for current user" }
    Log-Message "Attempting to uninstall $appName $scope"
    try {
        if ($isGlobal) {
            
            Get-AppxPackage -Name $appName -AllUsers | Remove-AppxPackage -ErrorAction Stop
        } else {
            Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction Stop
        }
        Log-Message "Successfully uninstalled $appName $scope."
        [System.Windows.MessageBox]::Show("Successfully uninstalled $appName.", "Uninstall Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        Get-InstalledStoreApps
    } catch {
        Log-Message "Failed to uninstall $appName $scope. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to uninstall $appName. Error: $($_.Exception.Message)", "Uninstall Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to reset local group policies
function Reset-LocalGroupPolicy {
    Log-Message "Attempting to reset Local Group Policies..."
    try {
        secedit /configure /cfg $env:SystemRoot\inf\defltbase.inf /db defltbase.sdb /verbose
        Log-Message "Local Group Policies reset successfully."
        $LogsTextBox.AppendText("Local Group Policies reset successfully. - $(Get-Date)`r`n")
        [System.Windows.MessageBox]::Show("Local Group Policies reset successfully.", "Reset Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to reset Local Group Policies. Error: $($_.Exception.Message)" -Type Error
        $LogsTextBox.AppendText("Error: Failed to reset policies - $(Get-Date)`r`n$($_.Exception.Message)`r`n")
        [System.Windows.MessageBox]::Show("Failed to reset Local Group Policies. Check permissions.", "Reset Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to install Visual C++ Redistributables
function Install-VisualCppRedistributable {
    Log-Message "Attempting to install Visual C++ Redistributables..."
    try {
        $url = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        $outPath = "$env:TEMP\vc_redist.x64.exe"
        Invoke-WebRequest -Uri $url -OutFile $outPath
        Start-Process -FilePath $outPath -ArgumentList "/install", "/passive", "/norestart" -Wait
        Remove-Item $outPath
        Log-Message "Visual C++ Redistributables installed successfully."
        [System.Windows.MessageBox]::Show("Visual C++ Redistributables installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to install Visual C++ Redistributables. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to install Visual C++ Redistributables. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to install DirectX
function Install-DirectX {
    Log-Message "Attempting to install DirectX..."
    try {
        $url = "https://download.microsoft.com/download/1/6/4/1644D52A-633F-4C5F-A119-A2EE0D3FA9A6/directx_Jun2010_redist.exe"
        $outPath = "$env:TEMP\directx_redist.exe"
        $extractPath = "$env:TEMP\directx_redist"
        Invoke-WebRequest -Uri $url -OutFile $outPath
        Start-Process -FilePath $outPath -ArgumentList "/Q", "/T:$extractPath" -Wait
        Start-Process -FilePath "$extractPath\DXSETUP.exe" -ArgumentList "/silent" -Wait
        Remove-Item $outPath
        Remove-Item $extractPath -Recurse
        Log-Message "DirectX installed successfully."
        [System.Windows.MessageBox]::Show("DirectX installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to install DirectX. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to install DirectX. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to install .NET SDKs
function Install-DotNetSDKs {
    Log-Message "Attempting to install .NET SDKs..."
    try {
        $channels = @("1.0", "1.1", "2.0", "2.1", "3.0", "3.1", "5.0", "6.0", "7.0", "8.0", "9.0", "STS")
        $scriptUrl = "https://dot.net/v1/dotnet-install.ps1"
        $scriptPath = "$env:TEMP\dotnet-install.ps1"
        Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

        foreach ($channel in $channels) {
            Log-Message "Installing .NET SDK channel $channel..."
            & $scriptPath -Channel $channel
        }

        $packages = @("Microsoft.DotNet.SDK.5", "Microsoft.DotNet.SDK.6", "Microsoft.DotNet.SDK.7", "Microsoft.DotNet.SDK.8", "Microsoft.DotNet.SDK.Preview")
        foreach ($package in $packages) {
            Log-Message "Installing $package..."
            Start-Process "winget" -ArgumentList "install --id $package --silent --accept-package-agreements --accept-source-agreements" -Wait
        }

        [Environment]::SetEnvironmentVariable("DOTNET_ROOT", "C:\Program Files\dotnet", "Machine")
        $path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
        if ($path -notlike "*C:\Program Files\dotnet*") {
            [Environment]::SetEnvironmentVariable("PATH", "$path;C:\Program Files\dotnet", "Machine")
        }

        Remove-Item $scriptPath
        Log-Message ".NET SDKs installed successfully."
        [System.Windows.MessageBox]::Show(".NET SDKs installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to install .NET SDKs. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to install .NET SDKs. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to switch panels
function Switch-Panel {
    param ($panelName)
    $RepairAppsPanel.Visibility = "Collapsed"
    $PolicyPanel.Visibility = "Collapsed"
    $InstallersPanel.Visibility = "Collapsed"
    $TweaksPanel.Visibility = "Collapsed"
    $OptimizationPanel.Visibility = "Collapsed"
    $PrivacyPanel.Visibility = "Collapsed"
    $SettingsPanel.Visibility = "Collapsed"
    $AboutPanel.Visibility = "Collapsed"
    
    switch ($panelName) {
        "RepairApps" { $RepairAppsPanel.Visibility = "Visible"; Log-Message "Switched to Repair Apps panel." }
        "Policy" { $PolicyPanel.Visibility = "Visible"; Log-Message "Switched to Local Group Policy panel." }
        "Installers" { $InstallersPanel.Visibility = "Visible"; Log-Message "Switched to Installers panel." }
        "Tweaks" { $TweaksPanel.Visibility = "Visible"; Log-Message "Switched to Tweaks panel." }
        "Optimization" { $OptimizationPanel.Visibility = "Visible"; Log-Message "Switched to Optimization panel." }
        "Privacy" { $PrivacyPanel.Visibility = "Visible"; Log-Message "Switched to Privacy panel." }
        "Settings" { $SettingsPanel.Visibility = "Visible"; Log-Message "Switched to Settings panel." }
        "About" { $AboutPanel.Visibility = "Visible"; Log-Message "Switched to About panel." }
    }
}

# Event handlers
$RepairAppsButton.Add_Click({ Switch-Panel -panelName "RepairApps" })
$LocalPolicyButton.Add_Click({ Switch-Panel -panelName "Policy" })
$InstallersButton.Add_Click({ Switch-Panel -panelName "Installers" })
$TweaksButton.Add_Click({ Switch-Panel -panelName "Tweaks" })
$OptimizationButton.Add_Click({ Switch-Panel -panelName "Optimization" })
$PrivacyButton.Add_Click({ Switch-Panel -panelName "Privacy" })
$SettingsButton.Add_Click({ Switch-Panel -panelName "Settings" })
$AboutButton.Add_Click({ Switch-Panel -panelName "About" })

$RepairButton.Add_Click({
    $selectedItem = $AppListView.SelectedItem
    if ($selectedItem) {
        Repair-StoreApp -appName $selectedItem.Name
    } else {
        Log-Message "No app selected for repair." -Type Warning
        [System.Windows.MessageBox]::Show("No app selected. Please select an app to repair.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$UninstallLocalButton.Add_Click({
    $selectedItem = $AppListView.SelectedItem
    if ($selectedItem) {
        Uninstall-App -appName $selectedItem.Name -isGlobal $false
    } else {
        Log-Message "No app selected for local uninstallation." -Type Warning
        [System.Windows.MessageBox]::Show("No app selected. Please select an app to uninstall.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$UninstallGlobalButton.Add_Click({
    $selectedItem = $AppListView.SelectedItem
    if ($selectedItem) {
        Uninstall-App -appName $selectedItem.Name -isGlobal $true
    } else {
        Log-Message "No app selected for global uninstallation." -Type Warning
        [System.Windows.MessageBox]::Show("No app selected. Please select an app to uninstall.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$ResetPolicyButton.Add_Click({ Reset-LocalGroupPolicy })
$ClearLogsButton.Add_Click({ $LogsTextBox.Clear(); Log-Message "Logs cleared." })
$RefreshLogsButton.Add_Click({ $LogsTextBox.AppendText("Logs refreshed. - $(Get-Date)`r`n"); Log-Message "Logs refreshed." })
$InstallVisualCppButton.Add_Click({ Install-VisualCppRedistributable })
$InstallDirectXButton.Add_Click({ Install-DirectX })
$InstallDotNetButton.Add_Click({ Install-DotNetSDKs })

$SearchBox.Add_TextChanged({
    $searchText = $SearchBox.Text.ToLower()
    Log-Message "Searching for apps containing '$searchText'..."
    $filteredApps = @(Get-AppxPackage | Where-Object { $_.IsFramework -eq $false -and ($_.Name -like "*$searchText*" -or $_.Version -like "*$searchText*") } | Select-Object Name, Version, @{Name="Status";Expression={"Installed"}})
    $AppListView.ItemsSource = $filteredApps
    Log-Message "Found $($filteredApps.Count) matching apps."
})

# Tweaks Panel Event Handlers
$DisableTelemetryButton.Add_Click({ Log-Message "Disable Telemetry functionality not implemented yet." -Type Warning })
$EnableDarkModeButton.Add_Click({ Log-Message "Enable Dark Mode functionality not implemented yet." -Type Warning })
$DisableCortanaButton.Add_Click({ Log-Message "Disable Cortana functionality not implemented yet." -Type Warning })

# Optimization Panel Event Handlers
$CleanTempFilesButton.Add_Click({ Log-Message "Clean Temporary Files functionality not implemented yet." -Type Warning })
$DefragmentDrivesButton.Add_Click({ Log-Message "Defragment Drives functionality not implemented yet." -Type Warning })
$OptimizeStartupButton.Add_Click({ Log-Message "Optimize Startup functionality not implemented yet." -Type Warning })

# Privacy Panel Event Handlers
$DisableActivityHistoryButton.Add_Click({ Log-Message "Disable Activity History functionality not implemented yet." -Type Warning })
$ManageAppPermissionsButton.Add_Click({ Log-Message "Manage App Permissions functionality not implemented yet." -Type Warning })
$ClearBrowsingDataButton.Add_Click({ Log-Message "Clear Browsing Data functionality not implemented yet." -Type Warning })

# Settings Panel Event Handlers
$SaveSettingsButton.Add_Click({
    $darkMode = $DarkModeCheckBox.IsChecked
    $runAtStartup = $RunAtStartupCheckBox.IsChecked
    $checkUpdates = $CheckUpdatesCheckBox.IsChecked
    $language = $LanguageComboBox.SelectedItem.Content
    Log-Message "Settings saved: Dark Mode: $darkMode, Run at Startup: $runAtStartup, Check Updates: $checkUpdates, Language: $language"
})

# About Panel Event Handlers
$CheckUpdatesButton.Add_Click({ Log-Message "Check for Updates functionality not implemented yet." -Type Warning })

# Initial population of the app list
Get-InstalledStoreApps

# Show the window
$window.ShowDialog() | Out-Null     = "Collapsed"
    $AboutPanel.Visibility        = "Collapsed"
    
    switch ($panelName) {
        "RepairApps" { $RepairAppsPanel.Visibility = "Visible" }
        "Policy" { $PolicyPanel.Visibility = "Visible" }
        "Installers" { $InstallersPanel.Visibility = "Visible" }
        "Tweaks" { $TweaksPanel.Visibility = "Visible" }
        "Optimization" { $OptimizationPanel.Visibility = "Visible" }
        "Privacy" { $PrivacyPanel.Visibility = "Visible" }
        "Settings" { $SettingsPanel.Visibility = "Visible" }
        "About" { $AboutPanel.Visibility = "Visible" }
    }
}

# Event handlers
$RepairAppsButton.Add_Click({ Switch-Panel -panelName "RepairApps" })
$LocalPolicyButton.Add_Click({ Switch-Panel -panelName "Policy" })
$InstallersButton.Add_Click({ Switch-Panel -panelName "Installers" })
$TweaksButton.Add_Click({ Switch-Panel -panelName "Tweaks" })
$OptimizationButton.Add_Click({ Switch-Panel -panelName "Optimization" })
$PrivacyButton.Add_Click({ Switch-Panel -panelName "Privacy" })
$SettingsButton.Add_Click({ Switch-Panel -panelName "Settings" })
$AboutButton.Add_Click({ Switch-Panel -panelName "About" })

$RepairButton.Add_Click({
    $selectedItem = $AppListView.SelectedItem
    if ($selectedItem) {
        Repair-StoreApp -appName $selectedItem.Name
    } else {
        [System.Windows.MessageBox]::Show("No app selected. Please select an app to repair.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$UninstallLocalButton.Add_Click({
    $selectedItem = $AppListView.SelectedItem
    if ($selectedItem) {
        Uninstall-App -appName $selectedItem.Name -isGlobal $false
    } else {
        [System.Windows.MessageBox]::Show("No app selected. Please select an app to uninstall.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$UninstallGlobalButton.Add_Click({
    $selectedItem = $AppListView.SelectedItem
    if ($selectedItem) {
        Uninstall-App -appName $selectedItem.Name -isGlobal $true
    } else {
        [System.Windows.MessageBox]::Show("No app selected. Please select an app to uninstall.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$ResetPolicyButton.Add_Click({ Reset-LocalGroupPolicy })
$ClearLogsButton.Add_Click({ $LogsTextBox.Clear() })
$RefreshLogsButton.Add_Click({ $LogsTextBox.AppendText("Logs refreshed. - $(Get-Date)`r`n") })
$InstallVisualCppButton.Add_Click({ Install-VisualCppRedistributable })
$InstallDirectXButton.Add_Click({ Install-DirectX })
$InstallDotNetButton.Add_Click({ Install-DotNetSDKs })

$SearchBox.Add_TextChanged({
    $searchText = $SearchBox.Text.ToLower()
    $filteredApps = @(Get-AppxPackage | Where-Object { $_.IsFramework -eq $false -and ($_.Name -like "*$searchText*" -or $_.Version -like "*$searchText*") } | Select-Object Name, Version, @{Name="Status";Expression={"Installed"}})
    $AppListView.ItemsSource = $filteredApps
})

# Initial population of the app list
Get-InstalledStoreApps

# Show the window
$window.ShowDialog() | Out-Null