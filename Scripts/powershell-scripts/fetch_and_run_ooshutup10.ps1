# Define the URL for O&O ShutUp10
$url = "https://www.oo-software.com/en/download/current/ooshutup10"

# Get the temporary folder path
$tempFolder = [System.IO.Path]::GetTempPath()

# Define the output file path
$outputPath = Join-Path -Path $tempFolder -ChildPath "OOSU10.exe"

# Download the file
Write-Host "Downloading O&O ShutUp10..."
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Check if the file was downloaded successfully
if (Test-Path $outputPath) {
    Write-Host "Download completed successfully."
    
    # Launch the application
    Write-Host "Launching O&O ShutUp10..."
    Start-Process -FilePath $outputPath
    
    # Wait for a moment to ensure the process starts
    Start-Sleep -Seconds 2
    
    # Close the PowerShell console
    Write-Host "Closing this window in 3 seconds..."
    Start-Sleep -Seconds 3
    [System.Environment]::Exit(0)
} else {
    Write-Host "Failed to download O&O ShutUp10. Please check your internet connection and try again."
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}