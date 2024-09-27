# Manage-LoadingScreen.ps1

# Define a function to start the loading screen
function Start-LoadingScreen {
    $process = Start-Process powershell -ArgumentList "-File `"$PSScriptRoot\Show-LoadingScreen.ps1`"" -NoNewWindow -PassThru
    Start-Sleep -Seconds 1 # Ensure the form is fully loaded
    return $process
}

# Define a function to close the loading screen
function Close-LoadingScreen {
    $formProcess = Get-Process | Where-Object { $_.MainWindowTitle -eq 'Loading...' }
    if ($formProcess) {
        $formProcess | Stop-Process -Force
    }
}

# Define a function to update the loading screen status
function Update-LoadingScreenStatus {
    param ([string]$statusText)
    $scriptPath = "$PSScriptRoot\Update-LoadingScreen.ps1"
    & $scriptPath -StatusText $statusText
}

# Start the loading screen
$loadingScreenProcess = Start-LoadingScreen

# Main script tasks
Update-LoadingScreenStatus -StatusText "Initializing..."
Start-Sleep -Seconds 2 # Simulating initialization
Update-LoadingScreenStatus -StatusText "Loading modules..."
Start-Sleep -Seconds 3 # Simulating module loading
Update-LoadingScreenStatus -StatusText "Finishing up..."
Start-Sleep -Seconds 2 # Simulating final tasks

# Close the loading screen
Close-LoadingScreen
