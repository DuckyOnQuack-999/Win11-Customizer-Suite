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
    <Style x:Key="ActionButtonStyle" TargetType="Button">
        <Setter Property="Background" Value="#FF5252"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="0"/>
        <Setter Property="Padding" Value="10,5"/>
        <Setter Property="Margin" Value="0,0,0,10"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border Background="{TemplateBinding Background}" BorderThickness="0" CornerRadius="5">
                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
        <Style.Triggers>
            <Trigger Property="IsMouseOver" Value="True">
                <Setter Property="Background" Value="#FF7070"/>
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
        <Button x:Name="DashboardButton" Content="Dashboard" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="RepairAppsButton" Content="Repair Apps" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="LocalPolicyButton" Content="Local Group Policy" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="InstallersButton" Content="Installers" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="TweaksButton" Content="Tweaks" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="OptimizationButton" Content="Optimization" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="PrivacyButton" Content="Privacy" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="SecurityButton" Content="Security" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="NetworkButton" Content="Network" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="SettingsButton" Content="Settings" Style="{StaticResource MenuButtonStyle}"/>
        <Button x:Name="AboutButton" Content="About" Style="{StaticResource MenuButtonStyle}"/>
    </StackPanel>

    <!-- Main Content Area -->
    <Grid Grid.Column="1" Grid.Row="0" Margin="20">
        <!-- Dashboard Panel -->
        <Grid x:Name="DashboardPanel" Visibility="Visible">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <TextBlock Text="Dashboard" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
            <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                <StackPanel>
                    <GroupBox Header="System Information" Margin="0,0,0,10">
                        <StackPanel Margin="10">
                            <TextBlock x:Name="OSInfoTextBlock" Text="OS: "/>
                            <TextBlock x:Name="CPUInfoTextBlock" Text="CPU: "/>
                            <TextBlock x:Name="RAMInfoTextBlock" Text="RAM: "/>
                            <TextBlock x:Name="DiskInfoTextBlock" Text="Disk: "/>
                        </StackPanel>
                    </GroupBox>
                    <GroupBox Header="Quick Actions" Margin="0,0,0,10">
                        <WrapPanel Margin="10">
                            <Button Content="Check for Updates" Style="{StaticResource ActionButtonStyle}" Margin="0,0,10,10"/>
                            <Button Content="Run Disk Cleanup" Style="{StaticResource ActionButtonStyle}" Margin="0,0,10,10"/>
                            <Button Content="Optimize Drives" Style="{StaticResource ActionButtonStyle}" Margin="0,0,10,10"/>
                            <Button Content="System Scan" Style="{StaticResource ActionButtonStyle}" Margin="0,0,10,10"/>
                        </WrapPanel>
                    </GroupBox>
                    <GroupBox Header="Performance Monitoring" Margin="0,0,0,10">
                        <Grid Margin="10">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0">
                                <TextBlock Text="CPU Usage:" Margin="0,0,0,5"/>
                                <ProgressBar x:Name="CPUUsageBar" Height="20" Maximum="100"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1">
                                <TextBlock Text="Memory Usage:" Margin="0,0,0,5"/>
                                <ProgressBar x:Name="MemoryUsageBar" Height="20" Maximum="100"/>
                            </StackPanel>
                        </Grid>
                    </GroupBox>
                </StackPanel>
            </ScrollViewer>
        </Grid>

        <!-- Repair Apps Panel -->
        <Grid x:Name="RepairAppsPanel" Visibility="Collapsed">
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
                <Button x:Name="UninstallGlobalButton" Content="Uninstall (Global)" Width="150" Height="40" Margin="0,0,10,0" Style="{StaticResource ActionButtonStyle}"/>
                <Button x:Name="UninstallLocalButton" Content="Uninstall (Local)" Width="150" Height="40" Margin="0,0,10,0" Style="{StaticResource ActionButtonStyle}"/>
                <Button x:Name="RepairButton" Content="Repair Selected" Width="150" Height="40" Style="{StaticResource ActionButtonStyle}"/>
            </StackPanel>
        </Grid>

        <!-- Local Group Policy Reset Tool Panel -->
        <Grid x:Name="PolicyPanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <TextBlock Text="Local Group Policy" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>

            <TextBox x:Name="LogsTextBox" Grid.Row="1" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" Background="#424242" Foreground="White"/>

            <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
                <Button x:Name="ResetPolicyButton" Content="Reset Local Group Policy" Width="200" Height="40" Margin="0,0,10,0" Style="{StaticResource ActionButtonStyle}"/>
                <Button x:Name="ClearLogsButton" Content="Clear Logs" Width="150" Height="40" Margin="0,0,10,0" Style="{StaticResource ActionButtonStyle}"/>
                <Button x:Name="RefreshLogsButton" Content="Refresh Logs" Width="150" Height="40" Style="{StaticResource ActionButtonStyle}"/>
            </StackPanel>
        </Grid>

        <!-- Installers Panel -->
        <ScrollViewer x:Name="InstallersPanel" Visibility="Collapsed">
            <StackPanel Margin="0,0,10,0">
                <TextBlock Text="Installers" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <GroupBox Header="Development Tools">
                    <StackPanel Margin="10">
                        <Button x:Name="InstallVisualCppButton" Content="Install Visual C++ Redistributables" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="InstallDirectXButton" Content="Install DirectX" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="InstallDotNetButton" Content="Install .NET SDKs" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="InstallPythonButton" Content="Install Python" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="InstallJavaButton" Content="Install Java Development Kit" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Productivity Tools">
                    <StackPanel Margin="10">
                        <Button x:Name="InstallOfficeButton" Content="Install Microsoft Office" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="InstallLibreOfficeButton" Content="Install LibreOffice" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="InstallAdobeReaderButton" Content="Install Adobe Reader" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Multimedia Tools">
                    <StackPanel Margin="10">
                        <Button x:Name="InstallVLCButton" Content="Install VLC Media Player" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="InstallGIMPButton" Content="Install GIMP" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="InstallAudacityButton" Content="Install Audacity" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
            </StackPanel>
        </ScrollViewer>

        <!-- Tweaks Panel -->
        <ScrollViewer x:Name="TweaksPanel" Visibility="Collapsed">
            <StackPanel Margin="0,0,10,0">
                <TextBlock Text="Tweaks" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <GroupBox Header="Windows Features">
                    <StackPanel Margin="10">
                        <Button x:Name="DisableTelemetryButton" Content="Disable Telemetry" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableDarkModeButton" Content="Enable Dark Mode" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableCortanaButton" Content="Disable Cortana" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableWindowsUpdateButton" Content="Disable Windows Update" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableWindowsUpdateButton" Content="Enable Windows Update" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableDefenderButton" Content="Disable Windows Defender" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableDefenderButton" Content="Enable Windows Defender" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="System Services">
                    <StackPanel Margin="10">
                        <Button x:Name="DisableSuperfetchButton" Content="Disable Superfetch" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableSuperfetchButton" Content="Enable Superfetch" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableIndexingButton" Content="Disable Windows Search Indexing" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableIndexingButton" Content="Enable Windows Search Indexing" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Power Management">
                    <StackPanel Margin="10">
                        <Button x:Name="DisableHibernationButton" Content="Disable Hibernation" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableHibernationButton" Content="Enable Hibernation" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableFastStartupButton" Content="Disable Fast Startup" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableFastStartupButton" Content="Enable Fast Startup" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                
                </GroupBox>
                <GroupBox Header="User Interface">
                    <StackPanel Margin="10">
                        <Button x:Name="DisableAeroShakeButton" Content="Disable Aero Shake" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableAeroShakeButton" Content="Enable Aero Shake" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableActionCenterButton" Content="Disable Action Center" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableActionCenterButton" Content="Enable Action Center" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
            </StackPanel>
        </ScrollViewer>

        <!-- Optimization Panel -->
        <ScrollViewer x:Name="OptimizationPanel" Visibility="Collapsed">
            <StackPanel Margin="0,0,10,0">
                <TextBlock Text="Optimization" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <GroupBox Header="System Cleanup">
                    <StackPanel Margin="10">
                        <Button x:Name="CleanTempFilesButton" Content="Clean Temporary Files" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="ClearSystemRestorePointsButton" Content="Clear System Restore Points" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="CleanWindowsOldButton" Content="Clean Windows.old Folder" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="ClearRecycleBinButton" Content="Clear Recycle Bin" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Disk Optimization">
                    <StackPanel Margin="10">
                        <Button x:Name="DefragmentDrivesButton" Content="Defragment Drives" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="OptimizeSSDButton" Content="Optimize SSD" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="AnalyzeDiskSpaceButton" Content="Analyze Disk Space" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Performance Tweaks">
                    <StackPanel Margin="10">
                        <Button x:Name="OptimizeStartupButton" Content="Optimize Startup" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableVisualEffectsButton" Content="Disable Visual Effects" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableTimerResolutionButton" Content="Enable Timer Resolution Service" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableTimerResolutionButton" Content="Disable Timer Resolution Service" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="System Restore">
                    <StackPanel Margin="10">
                        <Button x:Name="CreateRestorePointButton" Content="Create Restore Point" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableSystemRestoreButton" Content="Disable System Restore" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableSystemRestoreButton" Content="Enable System Restore" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
            </StackPanel>
        </ScrollViewer>

        <!-- Privacy Panel -->
        <ScrollViewer x:Name="PrivacyPanel" Visibility="Collapsed">
            <StackPanel Margin="0,0,10,0">
                <TextBlock Text="Privacy" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <GroupBox Header="Windows Privacy Settings">
                    <StackPanel Margin="10">
                        <Button x:Name="DisableActivityHistoryButton" Content="Disable Activity History" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableLocationTrackingButton" Content="Disable Location Tracking" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableAdvertisingIDButton" Content="Disable Advertising ID" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableWebSearchButton" Content="Disable Web Search in Start Menu" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableWebSearchButton" Content="Enable Web Search in Start Menu" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="App Permissions">
                    <StackPanel Margin="10">
                        <Button x:Name="ManageAppPermissionsButton" Content="Manage App Permissions" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableBackgroundAppsButton" Content="Disable Background Apps" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableStartupAppsButton" Content="Disable Startup Apps" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Data Collection">
                    <StackPanel Margin="10">
                        <Button x:Name="DisableDiagnosticDataButton" Content="Disable Diagnostic Data" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableFeedbackFrequencyButton" Content="Disable Feedback Frequency" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableWindowsExperienceButton" Content="Disable Windows Experience" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Browser Privacy">
                    <StackPanel Margin="10">
                        <Button x:Name="ClearBrowsingDataButton" Content="Clear Browsing Data" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableWebRTCButton" Content="Disable WebRTC" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableDNSOverHTTPSButton" Content="Enable DNS over HTTPS" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
            </StackPanel>
        </ScrollViewer>

        <!-- Security Panel -->
        <ScrollViewer x:Name="SecurityPanel" Visibility="Collapsed">
            <StackPanel Margin="0,0,10,0">
                <TextBlock Text="Security" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <GroupBox Header="Windows Security">
                    <StackPanel Margin="10">
                        <Button x:Name="RunWindowsSecurityScanButton" Content="Run Windows Security Scan" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="UpdateVirusDefinitionsButton" Content="Update Virus Definitions" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="ConfigureFirewallButton" Content="Configure Windows Firewall" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="User Account Control">
                    <StackPanel Margin="10">
                        <Button x:Name="ConfigureUACButton" Content="Configure UAC Settings" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableSecureDesktopButton" Content="Enable Secure Desktop" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Encryption">
                    <StackPanel Margin="10">
                        <Button x:Name="EnableBitLockerButton" Content="Enable BitLocker" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="CreateEncryptedContainerButton" Content="Create Encrypted Container" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Network Security">
                    <StackPanel Margin="10">
                        <Button x:Name="DisableRemoteDesktopButton" Content="Disable Remote Desktop" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableRemoteDesktopButton" Content="Enable Remote Desktop" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableSMBv1Button" Content="Disable SMBv1" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
            </StackPanel>
        </ScrollViewer>

        <!-- Network Panel -->
        <ScrollViewer x:Name="NetworkPanel" Visibility="Collapsed">
            <StackPanel Margin="0,0,10,0">
                <TextBlock Text="Network" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <GroupBox Header="Network Diagnostics">
                    <StackPanel Margin="10">
                        <Button x:Name="RunNetworkDiagnosticsButton" Content="Run Network Diagnostics" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="ResetNetworkStackButton" Content="Reset Network Stack" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="FlushDNSCacheButton" Content="Flush DNS Cache" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Network Configuration">
                    <StackPanel Margin="10">
                        <Button x:Name="ConfigureStaticIPButton" Content="Configure Static IP" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="ConfigureDNSServersButton" Content="Configure DNS Servers" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableNetworkDiscoveryButton" Content="Enable Network Discovery" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableNetworkDiscoveryButton" Content="Disable Network Discovery" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Network Optimization">
                    <StackPanel Margin="10">
                        <Button x:Name="OptimizeTCPSettingsButton" Content="Optimize TCP Settings" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableNetworkThrottlingButton" Content="Disable Network Throttling" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="EnableQoSButton" Content="Enable QoS" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Network Sharing">
                    <StackPanel Margin="10">
                        <Button x:Name="ConfigureNetworkSharingButton" Content="Configure Network Sharing" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="DisableHomeGroupButton" Content="Disable HomeGroup" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </GroupBox>
            </StackPanel>
        </ScrollViewer>

        <!-- Settings Panel -->
        <ScrollViewer x:Name="SettingsPanel" Visibility="Collapsed">
            <StackPanel Margin="0,0,10,0">
                <TextBlock Text="Settings" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
                <GroupBox Header="Application Settings">
                    <StackPanel Margin="10">
                        <CheckBox x:Name="DarkModeCheckBox" Content="Enable Dark Mode" Margin="0,0,0,10" Foreground="White"/>
                        <CheckBox x:Name="RunAtStartupCheckBox" Content="Run at Startup" Margin="0,0,0,10" Foreground="White"/>
                        <CheckBox x:Name="CheckUpdatesCheckBox" Content="Check for Updates Automatically" Margin="0,0,0,10" Foreground="White"/>
                        <TextBlock Text="Language:" Margin="0,0,0,5" Foreground="White"/>
                        <ComboBox x:Name="LanguageComboBox" Width="200" Margin="0,0,0,10" HorizontalAlignment="Left">
                            <ComboBoxItem Content="English" IsSelected="True"/>
                            <ComboBoxItem Content="Spanish"/>
                            <ComboBoxItem Content="French"/>
                            <ComboBoxItem Content="German"/>
                            <ComboBoxItem Content="Chinese"/>
                        </ComboBox>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Backup Settings">
                    <StackPanel Margin="10">
                        <CheckBox x:Name="AutoBackupCheckBox" Content="Enable Automatic Backups" Margin="0,0,0,10" Foreground="White"/>
                        <TextBlock Text="Backup Frequency:" Margin="0,0,0,5" Foreground="White"/>
                        <ComboBox x:Name="BackupFrequencyComboBox" Width="200" Margin="0,0,0,10" HorizontalAlignment="Left">
                            <ComboBoxItem Content="Daily"/>
                            <ComboBoxItem Content="Weekly"/>
                            <ComboBoxItem Content="Monthly"/>
                        </ComboBox>
                        <Button x:Name="ChooseBackupLocationButton" Content="Choose Backup Location" Style="{StaticResource ActionButtonStyle}" HorizontalAlignment="Left"/>
                    </StackPanel>
                </GroupBox>
                <GroupBox Header="Notification Settings">
                    <StackPanel Margin="10">
                        <CheckBox x:Name="EnableNotificationsCheckBox" Content="Enable Notifications" Margin="0,0,0,10" Foreground="White"/>
                        <CheckBox x:Name="ShowPopupsCheckBox" Content="Show Popup Notifications" Margin="0,0,0,10" Foreground="White"/>
                        <CheckBox x:Name="PlaySoundsCheckBox" Content="Play Notification Sounds" Margin="0,0,0,10" Foreground="White"/>
                    </StackPanel>
                </GroupBox>
                <Button x:Name="SaveSettingsButton" Content="Save Settings" Width="200" Height="40" Style="{StaticResource ActionButtonStyle}" HorizontalAlignment="Left" Margin="0,20,0,0"/>
            </StackPanel>
        </ScrollViewer>

        <!-- About Panel -->
        <StackPanel x:Name="AboutPanel" Visibility="Collapsed">
            <TextBlock Text="About WinKit" FontSize="24" FontWeight="Bold" Margin="0,0,0,20"/>
            <TextBlock Text="Version: 2.0.0" Margin="0,0,0,10"/>
            <TextBlock Text="WinKit is a comprehensive Windows utility tool designed to help users manage, optimize, and customize their Windows experience. It provides a wide range of features for system maintenance, privacy protection, and performance optimization." TextWrapping="Wrap" Margin="0,0,0,20"/>
            <TextBlock Text="Features:" FontWeight="Bold" Margin="0,0,0,10"/>
            <TextBlock Text="• System Repair and Optimization" Margin="20,0,0,5"/>
            <TextBlock Text="• Privacy and Security Enhancements" Margin="20,0,0,5"/>
            <TextBlock Text="• Network Diagnostics and Configuration" Margin="20,0,0,5"/>
            <TextBlock Text="• Customizable Windows Tweaks" Margin="20,0,0,5"/>
            <TextBlock Text="• Automated Maintenance Tasks" Margin="20,0,0,20"/>
            <TextBlock Text="Developed by: WinKit Team" Margin="0,0,0,10"/>
            <TextBlock Text="Website: https://www.winkit.com" Margin="0,0,0,20"/>
            <Button x:Name="CheckUpdatesButton" Content="Check for Updates" Width="200" Height="40" Style="{StaticResource ActionButtonStyle}" HorizontalAlignment="Left"/>
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

# Improved function to log messages to the Terminal Window
function Log-Message {
    param (
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error", "Success")]
        [string]$Type = "Info"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Type] $Message"

    switch ($Type) {
        "Info"    { $color = "#E0E0E0" }
        "Warning" { $color = "#FFA500" }
        "Error"   { $color = "#FF0000" }
        "Success" { $color = "#00FF00" }
    }

    $TerminalWindow.AppendText("$logMessage`r`n")
    $TerminalWindow.ScrollToEnd()
}

# Function to populate the ListView with installed apps
function Get-InstalledStoreApps {
    Log-Message "Retrieving installed Store apps..." -Type Info
    try {
        $apps = Get-AppxPackage | Where-Object { $_.IsFramework -eq $false } | Select-Object Name, Version, @{Name="Status";Expression={"Installed"}}
        $AppListView.ItemsSource = $apps
        Log-Message "Retrieved $(($apps | Measure-Object).Count) installed Store apps." -Type Success
    } catch {
        Log-Message "Error retrieving installed Store apps: $($_.Exception.Message)" -Type Error
    }
}

# Function to repair a specific store app
function Repair-StoreApp {
    param ($appName)
    Log-Message "Attempting to repair app: $appName" -Type Info
    try {
        Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction Stop
        Add-AppxPackage -Register -DisableDevelopmentMode (Get-AppxPackage -AllUsers -Name $appName).InstallLocation + "\AppxManifest.xml" -ErrorAction Stop
        Log-Message "Repair process completed for $appName." -Type Success
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
    Log-Message "Attempting to uninstall $appName $scope" -Type Info
    try {
        if ($isGlobal) {
            Get-AppxPackage -Name $appName -AllUsers | Remove-AppxPackage -ErrorAction Stop
        } else {
            Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction Stop
        }
        Log-Message "Successfully uninstalled $appName $scope." -Type Success
        [System.Windows.MessageBox]::Show("Successfully uninstalled $appName.", "Uninstall Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        Get-InstalledStoreApps
    } catch {
        Log-Message "Failed to uninstall $appName $scope. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to uninstall $appName. Error: $($_.Exception.Message)", "Uninstall Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to reset local group policies
function Reset-LocalGroupPolicy {
    Log-Message "Attempting to reset Local Group Policies..." -Type Info
    try {
        $output = secedit /configure /cfg $env:SystemRoot\inf\defltbase.inf /db defltbase.sdb /verbose
        Log-Message "Local Group Policies reset successfully." -Type Success
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
    Log-Message "Attempting to install Visual C++ Redistributables..." -Type Info
    try {
        $url = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        $outPath = "$env:TEMP\vc_redist.x64.exe"
        Invoke-WebRequest -Uri $url -OutFile $outPath
        $installProcess = Start-Process -FilePath $outPath -ArgumentList "/install", "/passive", "/norestart" -Wait -PassThru
        if ($installProcess.ExitCode -ne 0) {
            throw "Installation failed with exit code: $($installProcess.ExitCode)"
        }
        Remove-Item $outPath
        Log-Message "Visual C++ Redistributables installed successfully." -Type Success
        [System.Windows.MessageBox]::Show("Visual C++ Redistributables installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to install Visual C++ Redistributables. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to install Visual C++ Redistributables. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to install DirectX
function Install-DirectX {
    Log-Message "Attempting to install DirectX..." -Type Info
    try {
        $url = "https://download.microsoft.com/download/1/6/4/1644D52A-633F-4C5F-A119-A2EE0D3FA9A6/directx_Jun2010_redist.exe"
        $outPath = "$env:TEMP\directx_redist.exe"
        $extractPath = "$env:TEMP\directx_redist"
        Invoke-WebRequest -Uri $url -OutFile $outPath
        Start-Process -FilePath $outPath -ArgumentList "/Q", "/T:$extractPath" -Wait
        $installProcess = Start-Process -FilePath "$extractPath\DXSETUP.exe" -ArgumentList "/silent" -Wait -PassThru
        if ($installProcess.ExitCode -ne 0) {
            throw "Installation failed with exit code: $($installProcess.ExitCode)"
        }
        Remove-Item $outPath
        Remove-Item $extractPath -Recurse
        Log-Message "DirectX installed successfully." -Type Success
        [System.Windows.MessageBox]::Show("DirectX installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to install DirectX. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to install DirectX. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to install .NET SDKs
function Install-DotNetSDKs {
    Log-Message "Attempting to install .NET SDKs..." -Type Info
    try {
        $channels = @("1.0", "1.1", "2.0", "2.1", "3.0", "3.1", "5.0", "6.0", "7.0", "8.0", "9.0", "STS")
        $scriptUrl = "https://dot.net/v1/dotnet-install.ps1"
        $scriptPath = "$env:TEMP\dotnet-install.ps1"
        Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

        foreach ($channel in $channels) {
            Log-Message "Installing .NET SDK channel $channel..." -Type Info
            $installProcess = Start-Process -FilePath "powershell.exe" -ArgumentList "-File $scriptPath -Channel $channel" -Wait -PassThru
            if ($installProcess.ExitCode -ne 0) {
                throw "Installation failed for channel $channel with exit code: $($installProcess.ExitCode)"
            }
        }

        $packages = @("Microsoft.DotNet.SDK.5", "Microsoft.DotNet.SDK.6", "Microsoft.DotNet.SDK.7", "Microsoft.DotNet.SDK.8", "Microsoft.DotNet.SDK.Preview")
        foreach ($package in $packages) {
            Log-Message "Installing $package..." -Type Info
            $installProcess = Start-Process "winget" -ArgumentList "install --id $package --silent --accept-package-agreements --accept-source-agreements" -Wait -PassThru
            if ($installProcess.ExitCode -ne 0) {
                throw "Installation failed for package $package with exit code: $($installProcess.ExitCode)"
            }
        }

        [Environment]::SetEnvironmentVariable("DOTNET_ROOT", "C:\Program Files\dotnet", "Machine")
        $path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
        if ($path -notlike "*C:\Program Files\dotnet*") {
            [Environment]::SetEnvironmentVariable("PATH", "$path;C:\Program Files\dotnet", "Machine")
        }

        Remove-Item $scriptPath
        Log-Message ".NET SDKs installed successfully." -Type Success
        [System.Windows.MessageBox]::Show(".NET SDKs installed successfully.", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to install .NET SDKs. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to install .NET SDKs. Error: $($_.Exception.Message)", "Installation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Function to switch panels
function Switch-Panel {
    param ($panelName)
    $DashboardPanel.Visibility = "Collapsed"
    $RepairAppsPanel.Visibility = "Collapsed"
    $PolicyPanel.Visibility = "Collapsed"
    $InstallersPanel.Visibility = "Collapsed"
    $TweaksPanel.Visibility = "Collapsed"
    $OptimizationPanel.Visibility = "Collapsed"
    $PrivacyPanel.Visibility = "Collapsed"
    $SecurityPanel.Visibility = "Collapsed"
    $NetworkPanel.Visibility = "Collapsed"
    $SettingsPanel.Visibility = "Collapsed"
    $AboutPanel.Visibility = "Collapsed"

    switch ($panelName) {
        "Dashboard" { $DashboardPanel.Visibility = "Visible"; Log-Message "Switched to Dashboard panel." -Type Info }
        "RepairApps" { $RepairAppsPanel.Visibility = "Visible"; Log-Message "Switched to Repair Apps panel." -Type Info }
        "Policy" { $PolicyPanel.Visibility = "Visible"; Log-Message "Switched to Local Group Policy panel." -Type Info }
        "Installers" { $InstallersPanel.Visibility = "Visible"; Log-Message "Switched to Installers panel." -Type Info }
        "Tweaks" { $TweaksPanel.Visibility = "Visible"; Log-Message "Switched to Tweaks panel." -Type Info }
        "Optimization" { $OptimizationPanel.Visibility = "Visible"; Log-Message "Switched to Optimization panel." -Type Info }
        "Privacy" { $PrivacyPanel.Visibility = "Visible"; Log-Message "Switched to Privacy panel." -Type Info }
        "Security" { $SecurityPanel.Visibility = "Visible"; Log-Message "Switched to Security panel." -Type Info }
        "Network" { $NetworkPanel.Visibility = "Visible"; Log-Message "Switched to Network panel." -Type Info }
        "Settings" { $SettingsPanel.Visibility = "Visible"; Log-Message "Switched to Settings panel." -Type Info }
        "About" { $AboutPanel.Visibility = "Visible"; Log-Message "Switched to About panel." -Type Info }
    }
}

# Event handlers for menu buttons
$DashboardButton.Add_Click({ Switch-Panel -panelName "Dashboard" })
$RepairAppsButton.Add_Click({ Switch-Panel -panelName "RepairApps" })
$LocalPolicyButton.Add_Click({ Switch-Panel -panelName "Policy" })
$InstallersButton.Add_Click({ Switch-Panel -panelName "Installers" })
$TweaksButton.Add_Click({ Switch-Panel -panelName "Tweaks" })
$OptimizationButton.Add_Click({ Switch-Panel -panelName "Optimization" })
$PrivacyButton.Add_Click({ Switch-Panel -panelName "Privacy" })
$SecurityButton.Add_Click({ Switch-Panel -panelName "Security" })
$NetworkButton.Add_Click({ Switch-Panel -panelName "Network" })
$SettingsButton.Add_Click({ Switch-Panel -panelName "Settings" })
$AboutButton.Add_Click({ Switch-Panel -panelName "About" })

# Event handlers for Repair Apps panel
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

# Event handlers for Local Group Policy panel
$ResetPolicyButton.Add_Click({ Reset-LocalGroupPolicy })
$ClearLogsButton.Add_Click({ $LogsTextBox.Clear(); Log-Message "Logs cleared." -Type Info })
$RefreshLogsButton.Add_Click({ $LogsTextBox.AppendText("Logs refreshed. - $(Get-Date)`r`n"); Log-Message "Logs refreshed." -Type Info })

# Event handlers for Installers panel
$InstallVisualCppButton.Add_Click({ Install-VisualCppRedistributable })
$InstallDirectXButton.Add_Click({ Install-DirectX })
$InstallDotNetButton.Add_Click({ Install-DotNetSDKs })

# Event handler for search box
$SearchBox.Add_TextChanged({
    $searchText = $SearchBox.Text.ToLower()
    Log-Message "Searching for apps containing '$searchText'..." -Type Info
    $filteredApps = @(Get-AppxPackage | Where-Object { $_.IsFramework -eq $false -and ($_.Name -like "*$searchText*" -or $_.Version -like "*$searchText*") } | Select-Object Name, Version, @{Name="Status";Expression={"Installed"}})
    $AppListView.ItemsSource = $filteredApps
    Log-Message "Found $($filteredApps.Count) matching apps." -Type Info
})

# Tweak Functions
function Disable-WindowsUpdate {
    Log-Message "Attempting to disable Windows Update..." -Type Info
    try {
        Stop-Service -Name "wuauserv" -Force
        Set-Service -Name "wuauserv" -StartupType Disabled
        Log-Message "Windows Update service disabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Windows Update has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Windows Update. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Windows Update. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-WindowsUpdate {
    Log-Message "Attempting to enable Windows Update..." -Type Info
    try {
        Set-Service -Name "wuauserv" -StartupType Automatic
        Start-Service -Name "wuauserv"
        Log-Message "Windows Update service enabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Windows Update has been enabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Windows Update. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Windows Update. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-WindowsDefender {
    Log-Message "Attempting to disable Windows Defender..." -Type Info
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
        Log-Message "Windows Defender disabled successfully. A system restart may be required for changes to take effect." -Type Success
        [System.Windows.MessageBox]::Show("Windows Defender has been disabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Windows Defender. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Windows Defender. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-WindowsDefender {
    Log-Message "Attempting to enable Windows Defender..." -Type Info
    try {
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
        Log-Message "Windows Defender enabled successfully. A system restart may be required for changes to take effect." -Type Success
        [System.Windows.MessageBox]::Show("Windows Defender has been enabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Windows Defender. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Windows Defender. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-Superfetch {
    Log-Message "Attempting to disable Superfetch..." -Type Info
    try {
        Stop-Service -Name "SysMain" -Force
        Set-Service -Name "SysMain" -StartupType Disabled
        Log-Message "Superfetch (SysMain) service disabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Superfetch has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Superfetch. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Superfetch. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-Superfetch {
    Log-Message "Attempting to enable Superfetch..." -Type Info
    try {
        Set-Service -Name "SysMain" -StartupType Automatic
        Start-Service -Name "SysMain"
        Log-Message "Superfetch (SysMain) service enabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Superfetch has been enabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Superfetch. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Superfetch. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-WindowsSearchIndexing {
    Log-Message "Attempting to disable Windows Search Indexing..." -Type Info
    try {
        Stop-Service -Name "WSearch" -Force
        Set-Service -Name "WSearch" -StartupType Disabled
        Log-Message "Windows Search Indexing service disabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Windows Search Indexing has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Windows Search Indexing. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Windows Search Indexing. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-WindowsSearchIndexing {
    Log-Message "Attempting to enable Windows Search Indexing..." -Type Info
    try {
        Set-Service -Name "WSearch" -StartupType Automatic
        Start-Service -Name "WSearch"
        Log-Message "Windows Search Indexing service enabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Windows Search Indexing has been enabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Windows Search Indexing. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Windows Search Indexing. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-Hibernation {
    Log-Message "Attempting to disable Hibernation..." -Type Info
    try {
        powercfg /h off
        Log-Message "Hibernation disabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Hibernation has been disabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Hibernation. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Hibernation. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-Hibernation {
    Log-Message "Attempting to enable Hibernation..." -Type Info
    try {
        powercfg /h on
        Log-Message "Hibernation enabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Hibernation has been enabled.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Hibernation. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Hibernation. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-FastStartup {
    Log-Message "Attempting to disable Fast Startup..." -Type Info
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0
        Log-Message "Fast Startup disabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Fast Startup has been disabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Fast Startup. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Fast Startup. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-FastStartup {
    Log-Message "Attempting to enable Fast Startup..." -Type Info
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 1
        Log-Message "Fast Startup enabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Fast Startup has been enabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Fast Startup. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Fast Startup. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Optimization Functions
function Clear-SystemRestorePoints {
    Log-Message "Attempting to clear System Restore Points..." -Type Info
    try {
        vssadmin delete shadows /all /quiet
        Log-Message "System Restore Points cleared successfully." -Type Success
        [System.Windows.MessageBox]::Show("System Restore Points have been cleared.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to clear System Restore Points. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to clear System Restore Points. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-SystemRestore {
    Log-Message "Attempting to disable System Restore..." -Type Info
    try {
        Disable-ComputerRestore -Drive "C:\"
        Log-Message "System Restore disabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("System Restore has been disabled for the C: drive.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable System Restore. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable System Restore. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-SystemRestore {
    Log-Message "Attempting to enable System Restore..." -Type Info
    try {
        Enable-ComputerRestore -Drive "C:\"
        Log-Message "System Restore enabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("System Restore has been enabled for the C: drive.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable System Restore. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable System Restore. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-TimerResolutionService {
    Log-Message "Attempting to enable Set Timer Resolution Service..." -Type Info
    try {
        # Create the C# source file
        $csFilePath = "$env:SystemDrive\Windows\SetTimerResolutionService.cs"
        Set-Content -Path $csFilePath -Value $timerResolutionServiceCode -Force

        # Compile the service
        $compileResult = Start-Process -FilePath "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe" -ArgumentList "-out:C:\Windows\SetTimerResolutionService.exe C:\Windows\SetTimerResolutionService.cs" -WindowStyle Hidden -Wait -PassThru

        if ($compile
Result.ExitCode -ne 0) {
            throw "Failed to compile the Set Timer Resolution Service."
        }

        # Remove the C# source file
        Remove-Item $csFilePath -ErrorAction SilentlyContinue

        # Install and start the service
        New-Service -Name "Set Timer Resolution Service" -BinaryPathName "$env:SystemDrive\Windows\SetTimerResolutionService.exe" -ErrorAction Stop
        Set-Service -Name "Set Timer Resolution Service" -StartupType Automatic -ErrorAction Stop
        Start-Service -Name "Set Timer Resolution Service" -ErrorAction Stop

        Log-Message "Set Timer Resolution Service enabled and started successfully." -Type Success
        [System.Windows.MessageBox]::Show("Set Timer Resolution Service has been enabled and started.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Set Timer Resolution Service. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Set Timer Resolution Service. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Disable-TimerResolutionService {
    Log-Message "Attempting to disable Set Timer Resolution Service..." -Type Info
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

        Log-Message "Set Timer Resolution Service disabled and removed successfully." -Type Success
        [System.Windows.MessageBox]::Show("Set Timer Resolution Service has been disabled and removed.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Set Timer Resolution Service. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Set Timer Resolution Service. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Privacy Functions
function Disable-WebSearch {
    Log-Message "Attempting to disable Web Search in Start Menu..." -Type Info
    try {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Value 0
        Log-Message "Web Search in Start Menu disabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Web Search in Start Menu has been disabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to disable Web Search in Start Menu. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to disable Web Search in Start Menu. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

function Enable-WebSearch {
    Log-Message "Attempting to enable Web Search in Start Menu..." -Type Info
    try {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 1
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -ErrorAction SilentlyContinue
        Log-Message "Web Search in Start Menu enabled successfully." -Type Success
        [System.Windows.MessageBox]::Show("Web Search in Start Menu has been enabled. Please restart your computer for the changes to take effect.", "Operation Successful", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        Log-Message "Failed to enable Web Search in Start Menu. Error: $($_.Exception.Message)" -Type Error
        [System.Windows.MessageBox]::Show("Failed to enable Web Search in Start Menu. Error: $($_.Exception.Message)", "Operation Failed", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Event handlers for Tweaks panel
$DisableTelemetryButton.Add_Click({ Log-Message "Disable Telemetry functionality not implemented yet." -Type Warning })
$EnableDarkModeButton.Add_Click({ Log-Message "Enable Dark Mode functionality not implemented yet." -Type Warning })
$DisableCortanaButton.Add_Click({ Log-Message "Disable Cortana functionality not implemented yet." -Type Warning })
$DisableWindowsUpdateButton.Add_Click({ Disable-WindowsUpdate })
$EnableWindowsUpdateButton.Add_Click({ Enable-WindowsUpdate })
$DisableDefenderButton.Add_Click({ Disable-WindowsDefender })
$EnableDefenderButton.Add_Click({ Enable-WindowsDefender })
$DisableSuperfetchButton.Add_Click({ Disable-Superfetch })
$EnableSuperfetchButton.Add_Click({ Enable-Superfetch })
$DisableIndexingButton.Add_Click({ Disable-WindowsSearchIndexing })
$EnableIndexingButton.Add_Click({ Enable-WindowsSearchIndexing })
$DisableHibernationButton.Add_Click({ Disable-Hibernation })
$EnableHibernationButton.Add_Click({ Enable-Hibernation })
$DisableFastStartupButton.Add_Click({ Disable-FastStartup })
$EnableFastStartupButton.Add_Click({ Enable-FastStartup })

# Event handlers for Optimization panel
$CleanTempFilesButton.Add_Click({ Log-Message "Clean Temporary Files functionality not implemented yet." -Type Warning })
$DefragmentDrivesButton.Add_Click({ Log-Message "Defragment Drives functionality not implemented yet." -Type Warning })
$OptimizeStartupButton.Add_Click({ Log-Message "Optimize Startup functionality not implemented yet." -Type Warning })
$ClearSystemRestorePointsButton.Add_Click({ Clear-SystemRestorePoints })
$DisableSystemRestoreButton.Add_Click({ Disable-SystemRestore })
$EnableSystemRestoreButton.Add_Click({ Enable-SystemRestore })
$EnableTimerResolutionButton.Add_Click({ Enable-TimerResolutionService })
$DisableTimerResolutionButton.Add_Click({ Disable-TimerResolutionService })

# Event handlers for Privacy panel
$DisableActivityHistoryButton.Add_Click({ Log-Message "Disable Activity History functionality not implemented yet." -Type Warning })
$ManageAppPermissionsButton.Add_Click({ Log-Message "Manage App Permissions functionality not implemented yet." -Type Warning })
$ClearBrowsingDataButton.Add_Click({ Log-Message "Clear Browsing Data functionality not implemented yet." -Type Warning })
$DisableWebSearchButton.Add_Click({ Disable-WebSearch })
$EnableWebSearchButton.Add_Click({ Enable-WebSearch })

# Event handlers for Settings panel
$SaveSettingsButton.Add_Click({
    $darkMode = $DarkModeCheckBox.IsChecked
    $runAtStartup = $RunAtStartupCheckBox.IsChecked
    $checkUpdates = $CheckUpdatesCheckBox.IsChecked
    $language = $LanguageComboBox.SelectedItem.Content
    Log-Message "Settings saved: Dark Mode: $darkMode, Run at Startup: $runAtStartup, Check Updates: $checkUpdates, Language: $language" -Type Info
})

# Event handlers for About panel
$CheckUpdatesButton.Add_Click({ Log-Message "Check for Updates functionality not implemented yet." -Type Warning })

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
        ServiceInst
aller serviceInstaller = new ServiceInstaller();
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

# Function to update system information on the Dashboard
function Update-SystemInfo {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $cpu = Get-CimInstance -ClassName Win32_Processor
    $ram = Get-CimInstance -ClassName Win32_ComputerSystem
    $disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"

    $OSInfoTextBlock.Text = "OS: $($os.Caption) $($os.Version)"
    $CPUInfoTextBlock.Text = "CPU: $($cpu.Name)"
    $RAMInfoTextBlock.Text = "RAM: $([math]::Round($ram.TotalPhysicalMemory / 1GB, 2)) GB"
    $DiskInfoTextBlock.Text = "Disk (C:): $([math]::Round($disk.Size / 1GB, 2)) GB Total, $([math]::Round($disk.FreeSpace / 1GB, 2)) GB Free"
}

# Function to update performance bars on the Dashboard
function Update-PerformanceBars {
    $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $memory = (Get-Counter '\Memory\% Committed Bytes In Use').CounterSamples.CookedValue

    $CPUUsageBar.Value = $cpu
    $MemoryUsageBar.Value = $memory
}

# Timer to update system information and performance bars
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(5)
$timer.Add_Tick({
    Update-SystemInfo
    Update-PerformanceBars
})
$timer.Start()

# Initial population of the app list and system information
Get-InstalledStoreApps
Update-SystemInfo
Update-PerformanceBars

# Show the window
$window.ShowDialog() | Out-Null