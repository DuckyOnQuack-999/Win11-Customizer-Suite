# PowerShell script to add registry key if it doesn't exist, otherwise skip

# Define the registry path for the context menu entry
$RegistryPath = "HKCR:\*\shell\Install_MSIX"

# Define the command to execute when the context menu option is selected
$CommandValue = "powershell.exe -ExecutionPolicy Bypass -Command `"& { param([string]$FilePath) }`""
# Parameter validation to check if the provided file path is valid
if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
    # If the file path is not valid or does not exist, output an error and exit
    Write-Error "The provided file path is not valid or does not exist: $FilePath"
    exit 1
}

# Check if AppInstaller exists in the expected location
`$AppInstallerPath = \"C:\Windows\System32\AppInstaller.exe\"
if (-not (Test-Path -Path `$AppInstallerPath)) {
    # If AppInstaller is not found, output an error and exit
    Write-Error \"AppInstaller.exe not found at `$AppInstallerPath. Please ensure AppInstaller is installed.\"
    exit 1
}

try {
    # Try to install the package using AppInstaller
    Write-Output \"Attempting to install MSIX/MSIXBundle using AppInstaller...\"
    Start-Process -FilePath `$AppInstallerPath -ArgumentList `$FilePath -Wait -ErrorAction Stop
} catch {
    # If AppInstaller fails, output a message and fall back to using PowerShell Add-AppxPackage
    Write-Output \"AppInstaller failed. This may be due to an unsupported file type, missing dependencies, or AppInstaller not being configured properly. Falling back to PowerShell Add-AppxPackage...\"
    try {
        # Use Add-AppxPackage to install the MSIX/MSIXBundle
        Add-AppxPackage -Path `$FilePath -ErrorAction Stop
        Write-Output \"Installation completed successfully.\"
    } catch {
        # Output an error if the fallback installation also fails
        Write-Error \"Failed to install MSIX/MSIXBundle: `$($_)\"
    }
} -FilePath '%1'\""

# Check if the registry key for the context menu already exists
if (-not (Test-Path $RegistryPath)) {
    # If the registry key does not exist, create it
    New-Item -Path $RegistryPath -Force | Out-Null
    # Set the display name for the context menu entry
    New-ItemProperty -Path $RegistryPath -Name "" -Value "Install MSIX/MSIXBundle" -Force | Out-Null
    # Set the command to be executed when the context menu entry is selected
    New-ItemProperty -Path "$RegistryPath\command" -Name "" -Value $CommandValue -Force | Out-Null
    Write-Output "Registry key added successfully."
} else {
    # If the registry key already exists, skip the addition
    Write-Output "Registry key already exists. Skipping..."
}