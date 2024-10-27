# Define the path to the PowerShell script that will install the certificate
# Check if running with admin privileges, if not, elevate
Write-Host "Checking for admin privileges..."
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Attempt to elevate to admin privileges
    Write-Host "Admin privileges not found, attempting to elevate..."
    try {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `$PSCommandPath" -Verb RunAs -ErrorAction Stop
    } catch {
        # Handle failure to elevate privileges
        Write-Host "Failed to elevate privileges. Please run the script as an administrator." -ForegroundColor Red
        exit 1
    }
    exit
}
Write-Host "Admin privileges confirmed."

# Define the path for the InstallCert.ps1 script
$scriptPath = "$env:USERPROFILE\Documents\PowerShell\Scripts\InstallCert.ps1"
Write-Host "Script path defined as: $scriptPath"

# Ensure the directory for the script exists
$scriptDir = Split-Path -Parent $scriptPath
if (-not (Test-Path $scriptDir)) {
    Write-Host "Directory does not exist. Creating directory: $scriptDir"
    New-Item -ItemType Directory -Path $scriptDir -Force | Out-Null
} else {
    Write-Host "Directory already exists: $scriptDir"
}

# Check if the InstallCert.ps1 script already exists
Add-Type -AssemblyName System.Windows.Forms
$SuppressPrompts = $false

# Check for a command-line flag to suppress prompts
param(
    [switch]$SuppressPrompts
)

if (Test-Path $scriptPath) {
    Write-Host "InstallCert.ps1 script already exists at: $scriptPath"
    if (-not $SuppressPrompts) {
        # Prompt user for overwrite confirmation
        $overwrite = [System.Windows.Forms.MessageBox]::Show("The script $scriptPath already exists. Do you want to overwrite it?", "Confirm Overwrite", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
        if ($overwrite -ne [System.Windows.Forms.DialogResult]::Yes) {
            Write-Output "Operation cancelled by the user."
            exit
        }
    } else {
        Write-Host "Suppressing prompt and overwriting script as per command-line flag."
    }
}

# Create the InstallCert.ps1 script
$scriptContent = @'
# Check if running with admin privileges, if not, elevate
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    try {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `$PSCommandPath" -Verb RunAs -ErrorAction Stop
    } catch {
        Write-Host "Failed to elevate privileges. Please run the script as an administrator." -ForegroundColor Red
        exit 1
    }
    exit
}

param([string]$filePath)
Write-Host "Installing certificate from: $filePath"

# Check if the specified file exists
if (-not (Test-Path $filePath)) {
    Write-Host "The specified file does not exist: $filePath"
    if (-not $SuppressPrompts) {
        [System.Windows.Forms.MessageBox]::Show("The specified file does not exist: $filePath", "File Not Found", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    exit 1
}

try {
    Write-Host "Loading certificate from file..."
    # Load the certificate from the specified file
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($filePath)

    Write-Host "Adding certificate to the local machine's trusted root store..."
    # Add the certificate to the local machine's trusted root store
    $store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "LocalMachine")
    $store.Open("ReadWrite")
    $store.Add($cert)
    $store.Close()

    Write-Host "Certificate installed successfully."
    if (-not $SuppressPrompts) {
        [System.Windows.Forms.MessageBox]::Show("Certificate installed successfully.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
}
catch {
    # Handle errors during certificate installation
    Write-Host "An error occurred while installing the certificate: $_"
    if (-not $SuppressPrompts) {
        [System.Windows.Forms.MessageBox]::Show("An error occurred while installing the certificate: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    exit 1
}
'@

try {
    Write-Host "Creating InstallCert.ps1 script..."
    # Write the script content to the specified path
    $scriptContent | Out-File -FilePath $scriptPath -Encoding UTF8
    Write-Host "InstallCert.ps1 script has been created at: $scriptPath"
    if (-not $SuppressPrompts) {
        [System.Windows.Forms.MessageBox]::Show("InstallCert.ps1 script has been created at $scriptPath", "Script Created", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
} catch {
    # Handle errors during script creation
    Write-Host "Failed to create the InstallCert.ps1 script: $_"
    if (-not $SuppressPrompts) {
        [System.Windows.Forms.MessageBox]::Show("Failed to create the InstallCert.ps1 script: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    exit 1
}

# Use HKLM:\Software\Classes instead of HKCR for registry paths
$baseRegistryPath = "HKLM:\Software\Classes"
Write-Host "Using base registry path: $baseRegistryPath"

# Define the registry paths for .exe, .msix, and .msixbundle files
$fileTypes = @("exefile", "msix", "msixbundle")
foreach ($fileType in $fileTypes) {
    $registryPath = "$baseRegistryPath\$fileType\shell\Install Certificate"
    $commandPath = "$registryPath\command"

    try {
        Write-Host "Processing registry path for file type: .$fileType"
        # Check if the context menu entry already exists
        if (Test-Path $registryPath) {
            Write-Host "Context menu entry already exists for .$fileType files. Asking user for confirmation to overwrite..."
            if (-not $SuppressPrompts) {
                $overwrite = [System.Windows.Forms.MessageBox]::Show("The context menu entry for .$fileType files already exists. Do you want to overwrite it?", "Confirm Overwrite", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
                if ($overwrite -ne [System.Windows.Forms.DialogResult]::Yes) {
                    Write-Output "Operation cancelled by the user for .$fileType files."
                    continue
                }
            } else {
                Write-Host "Suppressing prompt and overwriting registry entry as per command-line flag."
            }
        } else {
            Write-Host "Creating new registry path: $registryPath"
            New-Item -Path $registryPath -Force | Out-Null
        }

        # Set properties for the context menu entry
        Write-Host "Setting registry properties for: $registryPath"
        Set-ItemProperty -Path $registryPath -Name "(Default)" -Value "Install Certificate"
        Set-ItemProperty -Path $registryPath -Name "Icon" -Value "shell32.dll,23"

        # Create the command that runs the PowerShell script
        if (-not (Test-Path $commandPath)) {
            Write-Host "Creating command registry path: $commandPath"
            New-Item -Path $commandPath -Force | Out-Null
        }
        Write-Host "Setting command to run PowerShell script for: $commandPath"
        Set-ItemProperty -Path $commandPath -Name "(Default)" -Value "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `$scriptPath -filePath `"%1`""

        Write-Output "Registry entries successfully created for .$fileType files. The context menu option 'Install Certificate' is now available."

    } catch {
        # Handle errors during registry operations
        Write-Host "Failed to create registry entries for .$fileType files: $_"
        if (-not $SuppressPrompts) {
            [System.Windows.Forms.MessageBox]::Show("Failed to create registry entries for .$fileType files: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

Write-Host "Operation completed."
if (-not $SuppressPrompts) {
    [System.Windows.Forms.MessageBox]::Show("Operation completed. Press OK to exit.", "Completed", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}