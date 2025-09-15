Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Privacy Settings" Height="350" Width="400">
    <StackPanel Margin="10">
        <CheckBox Name="chkPersonalizedAds" Content="Personalized Ads" Margin="5"/>
        <CheckBox Name="chkLocallyRelevantContent" Content="Locally Relevant Content" Margin="5"/>
        <CheckBox Name="chkTrackingAppLaunches" Content="Tracking App Launches" Margin="5"/>
        <CheckBox Name="chkSuggestedContent" Content="Suggested Content in Settings" Margin="5"/>
        <CheckBox Name="chkNotificationsInSettings" Content="Notifications in Settings" Margin="5"/>
        <Button Name="btnApply" Content="Apply" Width="80" Margin="5" HorizontalAlignment="Center"/>
    </StackPanel>
</Window>
"@

# Load XAML
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get UI elements
$chkPersonalizedAds = $window.FindName("chkPersonalizedAds")
$chkLocallyRelevantContent = $window.FindName("chkLocallyRelevantContent")
$chkTrackingAppLaunches = $window.FindName("chkTrackingAppLaunches")
$chkSuggestedContent = $window.FindName("chkSuggestedContent")
$chkNotificationsInSettings = $window.FindName("chkNotificationsInSettings")
$btnApply = $window.FindName("btnApply")

# Event Handler for Apply Button
$btnApply.Add_Click({
    # Personalized Ads
    $adsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    $adsValue = "Enabled"
    Set-ItemProperty -Path $adsPath -Name $adsValue -Value ([int]$chkPersonalizedAds.IsChecked)
    
    # Locally Relevant Content
    $localContentPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    $localContentValue = "ContentDeliveryAllowed"
    Set-ItemProperty -Path $localContentPath -Name $localContentValue -Value ([int]$chkLocallyRelevantContent.IsChecked)

    # Tracking App Launches
    $trackingPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $trackingValue = "Start_TrackProgs"
    Set-ItemProperty -Path $trackingPath -Name $trackingValue -Value ([int]$chkTrackingAppLaunches.IsChecked)

    # Suggested Content in Settings
    $suggestedContentPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    $suggestedContentValue = "SubscribedContent-338388Enabled"
    Set-ItemProperty -Path $suggestedContentPath -Name $suggestedContentValue -Value ([int]$chkSuggestedContent.IsChecked)

    # Notifications in Settings
    $notificationsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings"
    $notificationsValue = "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK"
    Set-ItemProperty -Path $notificationsPath -Name $notificationsValue -Value ([int]$chkNotificationsInSettings.IsChecked)
    
    [System.Windows.MessageBox]::Show("Settings have been applied successfully.", "Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
})

# Show Window
$window.ShowDialog()
