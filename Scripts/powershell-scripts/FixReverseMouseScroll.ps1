# Get all PnP devices of the class 'Mouse'
$mouseDevices = Get-PnpDevice -Class Mouse

# Loop through each device and set the FlipFlopWheel value to 0
foreach ($device in $mouseDevices) {
    $deviceId = $device.InstanceId
    $keyPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$deviceId\Device Parameters"
    
    # Check if the registry path exists
    if (Test-Path $keyPath) {
        # Set the FlipFlopWheel value to 0
        Set-ItemProperty -Path $keyPath -Name "FlipFlopWheel" -Value 0 -ErrorAction SilentlyContinue
        Write-Host "Set FlipFlopWheel to 0 for device: $deviceId"
    } else {
        Write-Host "Registry path not found for device: $deviceId"
    }
}

Write-Host "All FlipFlopWheel values have been set to 0."
Pause