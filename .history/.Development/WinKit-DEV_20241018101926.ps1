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
                <Button x:Name="DisableWindowsUpdateButton" Content="Disable Windows Update" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableWindowsUpdateButton" Content="Enable Windows Update" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableDefenderButton" Content="Disable Windows Defender" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableDefenderButton" Content="Enable Windows Defender" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableOneDriveButton" Content="Disable OneDrive" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="UninstallOneDriveButton" Content="Uninstall OneDrive" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableSuperfetchButton" Content="Disable Superfetch" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableSuperfetchButton" Content="Enable Superfetch" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableIndexingButton" Content="Disable Windows Search Indexing" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableIndexingButton" Content="Enable Windows Search Indexing" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableHibernationButton" Content="Disable Hibernation" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableHibernationButton" Content="Enable Hibernation" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableFastStartupButton" Content="Disable Fast Startup" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableFastStartupButton" Content="Enable Fast Startup" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Optimization Panel -->
            <StackPanel x:Name="OptimizationPanel" Visibility="Collapsed">
                <TextBlock Text="Optimization" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <Button x:Name="CleanTempFilesButton" Content="Clean Temporary Files" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DefragmentDrivesButton" Content="Defragment Drives" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="OptimizeStartupButton" Content="Optimize Startup" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="ClearSystemRestorePointsButton" Content="Clear System Restore Points" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableSystemRestoreButton" Content="Disable System Restore" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableSystemRestoreButton" Content="Enable System Restore" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableTimerResolutionButton" Content="Enable Timer Resolution Service" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableTimerResolutionButton" Content="Disable Timer Resolution Service" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
            </StackPanel>

            <!-- Privacy Panel -->
            <StackPanel x:Name="PrivacyPanel" Visibility="Collapsed">
                <TextBlock Text="Privacy" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <Button x:Name="DisableActivityHistoryButton" Content="Disable Activity History" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="ManageAppPermissionsButton" Content="Manage App Permissions" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="ClearBrowsingDataButton" Content="Clear Browsing Data" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="DisableWebSearchButton" Content="Disable Web Search in Start Menu" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
                <Button x:Name="EnableWebSearchButton" Content="Enable Web Search in Start Menu" Width="300" Height="40" Margin="0,0,0,10" Background="#FF5252" Foreground="White"/>
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

$DisableWindowsUpdateButton.Add_Click({ Disable-WindowsUpdate })
$EnableWindowsUpdateButton.Add_Click({ Enable-WindowsUpdate })
$DisableDefenderButton.Add_Click({ Disable-WindowsDefender })
$EnableDefenderButton.Add_Click({ Enable-WindowsDefender })
$DisableOneDriveButton.Add_Click({ Disable-OneDrive })
$UninstallOneDriveButton.Add_Click({ Uninstall-OneDrive })
$DisableSuperfetchButton.Add_Click({ Disable-Superfetch })
$EnableSuperfetchButton.Add_Click({ Enable-Superfetch })
$DisableIndexingButton.Add_Click({ Disable-WindowsSearchIndexing })
$EnableIndexingButton.Add_Click({ Enable-WindowsSearchIndexing })
$DisableHibernationButton.Add_Click({ Disable-Hibernation })
$EnableHibernationButton.Add_Click({ Enable-Hibernation })
$DisableFastStartupButton.Add_Click({ Disable-FastStartup })
$EnableFastStartupButton.Add_Click({ Enable-FastStartup })

# Optimization Panel Event Handlers
$CleanTempFilesButton.Add_Click({ Log-Message "Clean Temporary Files functionality not implemented yet." -Type Warning })
$DefragmentDrivesButton.Add_Click({ Log-Message "Defragment Drives functionality not implemented yet." -Type Warning })
$OptimizeStartupButton.Add_Click({ Log-Message "Optimize Startup functionality not implemented yet." -Type Warning })
$ClearSystemRestorePointsButton.Add_Click({ Clear-SystemRestorePoints })
$DisableSystemRestoreButton.Add_Click({ Disable-SystemRestore })
$EnableSystemRestoreButton.Add_Click({ Enable-SystemRestore })
$EnableTimerResolutionButton.Add_Click({ Enable-TimerResolutionService })
$DisableTimerResolutionButton.Add_Click({ Disable-TimerResolutionService })

# Privacy Panel Event Handlers
$DisableActivityHistoryButton.Add_Click({ Log-Message "Disable Activity History functionality not implemented yet." -Type Warning })
$ManageAppPermissionsButton.Add_Click({ Log-Message "Manage App Permissions functionality not implemented yet." -Type Warning })
$ClearBrowsingDataButton.Add_Click({ Log-Message "Clear Browsing Data functionality not implemented yet." -Type Warning })
$DisableWebSearchButton.Add_Click({ Disable-WebSearch })
$EnableWebSearchButton.Add_Click({ Enable-WebSearch })

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

# Tweak Functions
function Disable-WindowsUpdate {
    Log-Message "Attempting to disable Windows Update..."
    try {
        Stop-Service -Name "wuauserv" -Force
        Set-Service -Name "wuauserv" -StartupType Disabled
        Log-Message "Windows Update service disabled successfully."
        [System.Windows.MessageBox]::Show("Windows Update has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Windows Update. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Windows Update. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-WindowsUpdate {
    Log-Message "Attempting to enable Windows Update..."
    try {
        Set-Service -Name "wuauserv" -StartupType Automatic
        Start-Service -Name "wuauserv"
        Log-Message "Windows Update service enabled successfully."
        [System.Windows.MessageBox]::Show("Windows Update has been enabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Windows Update. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Windows Update. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-WindowsDefender {
    Log-Message "Attempting to disable Windows Defender..."
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
        Log-Message "Windows Defender disabled successfully. A system restart may be required for changes to take effect."
        [System.Windows.MessageBox]::Show("Windows Defender has been disabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Windows Defender. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Windows Defender. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-WindowsDefender {
    Log-Message "Attempting to enable Windows Defender..."
    try {
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
        Log-Message "Windows Defender enabled successfully. A system restart may be required for changes to take effect."
        [System.Windows.MessageBox]::Show("Windows Defender has been enabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Windows Defender. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Windows Defender. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-OneDrive {
    Log-Message "Attempting to disable OneDrive..."
    try {
        Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        $oneDrivePath = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        if (!(Test-Path $oneDrivePath)) {
            $oneDrivePath = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $oneDrivePath "/unlink /ui=false" -NoNewWindow -Wait
        Log-Message "OneDrive disabled successfully."
        [System.Windows.MessageBox]::Show("OneDrive has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable OneDrive. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable OneDrive. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Uninstall-OneDrive {
    Log-Message "Attempting to uninstall OneDrive..."
    try {
        Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        $oneDrivePath = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        if (!(Test-Path $oneDrivePath)) {
            $oneDrivePath = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $oneDrivePath "/uninstall" -NoNewWindow -Wait
        Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\OneDriveTemp" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Log-Message "OneDrive uninstalled successfully."
        [System.Windows.MessageBox]::Show("OneDrive has been uninstalled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to uninstall OneDrive. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to uninstall OneDrive. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-Superfetch {
    Log-Message "Attempting to disable Superfetch..."
    try {
        Stop-Service -Name "SysMain" -Force
        Set-Service -Name "SysMain" -StartupType Disabled
        Log-Message "Superfetch (SysMain) service disabled successfully."
        [System.Windows.MessageBox]::Show("Superfetch has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Superfetch. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Superfetch. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-Superfetch {
    Log-Message "Attempting to enable Superfetch..."
    try {
        Set-Service -Name "SysMain" -StartupType Automatic
        Start-Service -Name "SysMain"
        Log-Message "Superfetch (SysMain) service enabled successfully."
        [System.Windows.MessageBox]::Show("Superfetch has been enabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Superfetch. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Superfetch. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-WindowsSearchIndexing {
    Log-Message "Attempting to disable Windows Search Indexing..."
    try {
        Stop-Service -Name "WSearch" -Force
        Set-Service -Name "WSearch" -StartupType Disabled
        Log-Message "Windows Search Indexing service disabled successfully."
        [System.Windows.MessageBox]::Show("Windows Search Indexing has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Windows Search Indexing. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Windows Search Indexing. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-WindowsSearchIndexing {
    Log-Message "Attempting to enable Windows Search Indexing..."
    try {
        Set-Service -Name "WSearch" -StartupType Automatic
        Start-Service -Name "WSearch"
        Log-Message "Windows Search Indexing service enabled successfully."
        [System.Windows.MessageBox]::Show("Windows Search Indexing has been enabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Windows Search Indexing. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Windows Search Indexing. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-Hibernation {
    Log-Message "Attempting to disable Hibernation..."
    try {
        powercfg /h off
        Log-Message "Hibernation disabled successfully."
        [System.Windows.MessageBox]::Show("Hibernation has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Hibernation. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Hibernation. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-Hibernation {
    Log-Message "Attempting to enable Hibernation..."
    try {
        powercfg /h on
        Log-Message "Hibernation enabled successfully."
        [System.Windows.MessageBox]::Show("Hibernation has been enabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Hibernation. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Hibernation. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-FastStartup {
    Log-Message "Attempting to disable Fast Startup..."
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0
        Log-Message "Fast Startup disabled successfully."
        [System.Windows.MessageBox]::Show("Fast Startup has been disabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Fast Startup. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Fast Startup. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-FastStartup {
    Log-Message "Attempting to enable Fast Startup..."
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 1
        Log-Message "Fast Startup enabled successfully."
        [System.Windows.MessageBox]::Show("Fast Startup has been enabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Fast Startup. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Fast Startup. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Clear-SystemRestorePoints {
    Log-Message "Attempting to clear System Restore Points..."
    try {
        vssadmin delete shadows /all /quiet
        Log-Message "System Restore Points cleared successfully."
        [System.Windows.MessageBox]::Show("System Restore Points have been cleared.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to clear System Restore Points. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to clear System Restore Points. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-SystemRestore {
    Log-Message "Attempting to disable System Restore..."
    try {
        Disable-ComputerRestore -Drive "C:\"
        Log-Message "System Restore disabled successfully."
        [System.Windows.MessageBox]::Show("System Restore has been disabled for the C: drive.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable System Restore. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable System Restore. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-SystemRestore {
    Log-Message "Attempting to enable System Restore..."
    try {
        Enable-ComputerRestore -Drive "C:\"
        Log-Message "System Restore enabled successfully."
        [System.Windows.MessageBox]::Show("System Restore has been enabled for the C: drive.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable System Restore. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable System Restore. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-WebSearch {
    Log-Message "Attempting to disable Web Search in Start Menu..."
    try {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Value 0
        Log-Message "Web Search in Start Menu disabled successfully."
        [System.Windows.MessageBox]::Show("Web Search in Start Menu has been disabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Web Search in Start Menu. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Web Search in Start Menu. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-WebSearch {
    Log-Message "Attempting to enable Web Search in Start Menu..."
    try {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 1
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -ErrorAction SilentlyContinue
        Log-Message "Web Search in Start Menu enabled successfully."
        [System.Windows.MessageBox]::Show("Web Search in Start Menu has been enabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Web Search in Start Menu. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Web Search in Start Menu. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-TimerResolutionService {
    Log-Message "Attempting to enable Set Timer Resolution Service..."
    try {
        # Create the C# source file
        $csFilePath = "$env:SystemDrive\Windows\SetTimerResolutionService.cs"
        Set-Content -Path $csFilePath -Value $timerResolutionServiceCode -Force

        # Compile the service
        $compileResult = Start-Process -FilePath "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe" -ArgumentList "-out:C:\Windows\SetTimerResolutionService.exe C:\Windows\SetTimerResolutionService.cs" -WindowStyle Hidden -Wait -PassThru

        if ($compileResult.ExitCode -ne 0) {
            throw "Failed to compile the Set Timer Resolution Service."
        }

        # Remove the C# source file
        Remove-Item $csFilePath -ErrorAction SilentlyContinue

        # Install and start the service
        New-Service -Name "Set Timer Resolution Service" -BinaryPathName "$env:SystemDrive\Windows\SetTimerResolutionService.exe" -ErrorAction Stop
        Set-Service -Name "Set Timer Resolution Service" -StartupType Automatic -ErrorAction Stop
        Start-Service -Name "Set Timer Resolution Service" -ErrorAction Stop

        Log-Message "Set Timer Resolution Service enabled and started successfully."
        [System.Windows.MessageBox]::Show("Set Timer Resolution Service has been enabled and started.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Set Timer Resolution Service. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Set Timer Resolution Service. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-TimerResolutionService {
    Log-Message "Attempting to disable Set Timer Resolution Service..."
    try {
        # Stop and disable the service
        Stop-Service -Name "Set Timer Resolution Service" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "Set Timer Resolution Service" -StartupType Disabled -ErrorAction SilentlyContinue

        # Delete the service
        $deleteResult = Start-Process -FilePath "sc.exe" -ArgumentList "delete `"Set Timer Resolution Service`"" -WindowStyle Hidden -Wait -PassThru

        if ($deleteResult.ExitCode -ne 0) {
            throw "Failed to delete the Set Timer Resolution Service."
        }

        # Delete the service executable
        Remove-Item "$env:SystemDrive\Windows\SetTimerResolutionService.exe" -Force -ErrorAction SilentlyContinue

        Log-Message "Set Timer Resolution Service disabled and removed successfully."
        [System.Windows.MessageBox]::Show("Set Timer Resolution Service has been disabled and removed.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Set Timer Resolution Service. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Set Timer Resolution Service. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Add this variable to store the C# code for the Timer Resolution Service
$timerResolutionServiceCode = @"
using System;
using System.Runtime.InteropServices;
using System.ServiceProcess;
using System.ComponentModel;
using System.Configuration.Install;
using System.Collections.Generic;
using System.Reflection;
using System.IO;
using System.Management;
using System.Threading;
using System.Diagnostics;
[assembly: AssemblyVersion("2.1")]
[assembly: AssemblyProduct("Set Timer Resolution service")]
namespace WindowsService
{
    class WindowsService : ServiceBase
    {
        public WindowsService()
        {
            this.ServiceName = "STR";
            this.EventLog.Log = "Application";
            this.CanStop = true;
            this.CanHandlePowerEvent = false;
            this.CanHandleSessionChangeEvent = false;
            this.CanPauseAndContinue = false;
            this.CanShutdown = false;
        }
        static void Main()
        {
            ServiceBase.Run(new WindowsService());
        }
        protected override void OnStart(string[] args)
        {
            base.OnStart(args);
            ReadProcessList();
            NtQueryTimerResolution(out this.MininumResolution, out this.MaximumResolution, out this.DefaultResolution);
            if(null != this.EventLog)
                try { this.EventLog.WriteEntry(String.Format("Minimum={0}; Maximum={1}; Default={2}; Processes='{3}'", this.MininumResolution, this.MaximumResolution, this.DefaultResolution, null != this.ProcessesNames ? String.Join("','", this.ProcessesNames) : "")); }
                catch {}
            if(null == this.ProcessesNames)
            {
                SetMaximumResolution();
                return;
            }
            if(0 == this.ProcessesNames.Count)
            {
                return;
            }
            this.ProcessStartDelegate = new OnProcessStart(this.ProcessStarted);
            try
            {
                String query = String.Format("SELECT * FROM __InstanceCreationEvent WITHIN 0.5 WHERE (TargetInstance isa \"Win32_Process\") AND (TargetInstance.Name=\"{0}\")", String.Join("\" OR TargetInstance.Name=\"", this.ProcessesNames));
                this.startWatch = new ManagementEventWatcher(query);
                this.startWatch.EventArrived += this.startWatch_EventArrived;
                this.startWatch.Start();
            }
            catch(Exception ee)
            {
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Error); }
                    catch {}
            }
        }
        protected override void OnStop()
        {
            if(null != this.startWatch)
            {
                this.startWatch.Stop();
            }

            base.OnStop();
        }
        ManagementEventWatcher startWatch;
        void startWatch_EventArrived(object sender, EventArrivedEventArgs e) 
        {
            try
            {
                ManagementBaseObject process = (ManagementBaseObject)e.NewEvent.Properties["TargetInstance"].Value;
                UInt32 processId = (UInt32)process.Properties["ProcessId"].Value;
                this.ProcessStartDelegate.BeginInvoke(processId, null, null);
            } 
            catch(Exception ee) 
            {
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Warning); }
                    catch {}

            }
        }
        [DllImport("kernel32.dll", SetLastError=true)]
        static extern Int32 WaitForSingleObject(IntPtr Handle, Int32 Milliseconds);
        [DllImport("kernel32.dll", SetLastError=true)]
        static extern IntPtr OpenProcess(UInt32 DesiredAccess, Int32 InheritHandle, UInt32 ProcessId);
        [DllImport("kernel32.dll", SetLastError=true)]
        static extern Int32 CloseHandle(IntPtr Handle);
        const UInt32 SYNCHRONIZE = 0x00100000;
        delegate void OnProcessStart(UInt32 processId);
        OnProcessStart ProcessStartDelegate = null;
        void ProcessStarted(UInt32 processId)
        {
            SetMaximumResolution();
            IntPtr processHandle = IntPtr.Zero;
            try
            {
                processHandle = OpenProcess(SYNCHRONIZE, 0, processId);
                if(processHandle != IntPtr.Zero)
                    WaitForSingleObject(processHandle, -1);
            } 
            catch(Exception ee) 
            {
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Warning); }
                    catch {}
            }
            finally
            {
                if(processHandle != IntPtr.Zero)
                    CloseHandle(processHandle); 
            }
            SetDefaultResolution();
        }
        List<String> ProcessesNames = null;
        void ReadProcessList()
        {
            String iniFilePath = Assembly.GetExecutingAssembly().Location + ".ini";
            if(File.Exists(iniFilePath))
            {
                this.ProcessesNames = new List<String>();
                String[] iniFileLines = File.ReadAllLines(iniFilePath);
                foreach(var line in iniFileLines)
                {
                    String[] names = line.Split(new char[] {',', ' ', ';'} , StringSplitOptions.RemoveEmptyEntries);
                    foreach(var name in names)
                    {
                        String lwr_name = name.ToLower();
                        if(!lwr_name.EndsWith(".exe"))
                            lwr_name += ".exe";
                        if(!this.ProcessesNames.Contains(lwr_name))
                            this.ProcessesNames.Add(lwr_name);
                    }
                }
            }
        }
        [DllImport("ntdll.dll", SetLastError=true)]
        static extern int NtSetTimerResolution(uint DesiredResolution, bool SetResolution, out uint CurrentResolution);
        [DllImport("ntdll.dll", SetLastError=true)]
        static extern int NtQueryTimerResolution(out uint MinimumResolution, out uint MaximumResolution, out uint ActualResolution);
        uint DefaultResolution = 0;
        uint MininumResolution = 0;
        uint MaximumResolution = 0;
        long processCounter = 0;
        void SetMaximumResolution()
        {
            long counter = Interlocked.Increment(ref this.processCounter);
            if(counter <= 1)
            {
                uint actual = 0;
                NtSetTimerResolution(this.MaximumResolution, true, out actual);
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(String.Format("Actual resolution = {0}", actual)); }
                    catch {}
            }
        }
        void SetDefaultResolution()
        {
            long counter = Interlocked.Decrement(ref this.processCounter);
            if(counter < 1)
            {
                uint actual = 0;
                NtSetTimerResolution(this.DefaultResolution, true, out actual);
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(String.Format("Actual resolution = {0}", actual)); }
                    catch {}
            }
        }
    }
    [RunInstaller(true)]
    public class WindowsServiceInstaller : Installer
    {
        public WindowsServiceInstaller()
        {
            ServiceProcessInstaller serviceProcessInstaller = 
                               new ServiceProcessInstaller();
            ServiceInstaller serviceInstaller = new ServiceInstaller();
            serviceProcessInstaller.Account = ServiceAccount.LocalSystem;
            serviceProcessInstaller.Username = null;
            serviceProcessInstaller.Password = null;
            serviceInstaller.DisplayName = "Set Timer Resolution Service";
            serviceInstaller.StartType = ServiceStartMode.Automatic;
            serviceInstaller.ServiceName = "STR";
            this.Installers.Add(serviceProcessInstaller);
            this.Installers.Add(serviceInstaller);
        }
    }
}
"@

# Show the window
$window.ShowDialog() | Out-Null