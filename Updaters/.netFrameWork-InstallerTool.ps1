# Ensure the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script.`nPlease re-run this script as an Administrator."
    exit 1
}

# Function to download dotnet-install.ps1
function Download-DotnetInstallScript {
    param (
        [string]$DestinationPath
    )
    $dotnetInstallUrl = "https://dot.net/v1/dotnet-install.ps1"
    
    try {
        Write-Output "Downloading dotnet-install.ps1 from $dotnetInstallUrl..."
        
        # Download the script using Invoke-WebRequest
        Invoke-WebRequest -Uri $dotnetInstallUrl -OutFile $DestinationPath -UseBasicParsing -ErrorAction Stop
        
        Write-Output "Successfully downloaded dotnet-install.ps1 to $DestinationPath"
    } catch {
        Write-Error "Failed to download dotnet-install.ps1: $_"
        throw $_  # Propagate the error
    }
}

# Function to install .NET SDK versions
function Install-DotnetSDK {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Channel,  # The .NET SDK channel to install

        [string]$Quality = ""  # Optional quality parameter (e.g., Preview)
    )
    try {
        Write-Output "Starting installation of .NET SDK Channel: $Channel, Quality: $Quality"
        
        # Construct the script path to the dotnet-install.ps1 script
        $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "dotnet-install.ps1"
        
        # Check if the script path is valid and accessible
        if (-not (Test-Path -Path $scriptPath)) {
            throw "The script path '$scriptPath' is not valid or accessible."
        }

        Write-Output "Using dotnet-install.ps1 script at: $scriptPath"
        
        # Prepare the command arguments for the installation script
        $commandArgs = @("-Channel", $Channel)

        # Add quality argument if specified
        if ($Quality) {
            $commandArgs += "-Quality", $Quality
        }

        # Optional: Specify installation path or other parameters as needed
        # Example: $commandArgs += "-InstallDir", "C:\Program Files\dotnet"

        Write-Output "Running command: & $scriptPath @commandArgs"
        
        # Execute the installation script with the specified arguments
        & $scriptPath @commandArgs
        Write-Output "Successfully installed .NET SDK Channel: $Channel, Quality: $Quality"
    } catch {
        Write-Error "Failed to install .NET SDK Channel $Channel $Quality: $_"
        throw $_  # Propagate the error
    }
}

# Function to install packages using winget with error handling
function Install-WingetPackage {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PackageId  # The package ID to install using winget
    )
    try {
        Write-Output "Installing package: $PackageId..."
        
        # Run the winget command to install the package silently
        winget install --id $PackageId --silent --accept-source-agreements --accept-package-agreements
        if ($LASTEXITCODE -ne 0) {
            throw "Installation of $PackageId failed with exit code $LASTEXITCODE."
        }
        
        Write-Output "Successfully installed package: $PackageId"
    } catch {
        Write-Error "Failed to install $PackageId: $_"
        throw $_  # Propagate the error
    }
}

# Function to set environment variables
function Set-DotnetEnvironmentVariables {
    try {
        Write-Output "Setting DOTNET_ROOT environment variable"
        
        # Set the DOTNET_ROOT environment variable to point to the installation directory
        $dotnetRoot = "C:\Program Files\dotnet"
        [System.Environment]::SetEnvironmentVariable("DOTNET_ROOT", $dotnetRoot, "Machine")
        
        # Add the dotnet root directory to the system PATH if it is not already present
        $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
        if (-not ($currentPath -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ieq $dotnetRoot })) {
            Write-Output "Adding $dotnetRoot to PATH"
            [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$dotnetRoot", "Machine")
            # Update the current session's PATH
            $env:PATH += ";$dotnetRoot"
        } else {
            Write-Output "$dotnetRoot is already in PATH"
        }
        
        Write-Output "Environment variables set successfully"
    } catch {
        Write-Error "Failed to set environment variables: $_"
        throw $_  # Propagate the error
    }
}

# Function to verify installed .NET SDKs
function Verify-DotnetSDKInstallation {
    try {
        Write-Output "Verifying installed .NET SDKs..."
        $sdks = & dotnet --list-sdks
        Write-Output "Installed .NET SDKs:"
        Write-Output $sdks
    } catch {
        Write-Error "Failed to verify .NET SDK installations: $_"
        throw $_
    }
}

# Function to verify environment variables
function Verify-EnvironmentVariables {
    try {
        Write-Output "Verifying environment variables..."
        $dotnetRoot = [System.Environment]::GetEnvironmentVariable("DOTNET_ROOT", "Machine")
        $path = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
        Write-Output "DOTNET_ROOT: $dotnetRoot"
        Write-Output "PATH: $path"
    } catch {
        Write-Error "Failed to verify environment variables: $_"
        throw $_
    }
}

# Main Script Execution Starts Here

# Start transcript for logging (optional)
$logFile = Join-Path -Path $PSScriptRoot -ChildPath "install-log.txt"
Write-Output "Starting transcript. Logging to $logFile"
Start-Transcript -Path $logFile -Append

try {
    # Step 1: Download dotnet-install.ps1
    $dotnetInstallScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "dotnet-install.ps1"
    Download-DotnetInstallScript -DestinationPath $dotnetInstallScriptPath

    # Step 2: Define a list of channels and their respective quality levels
    $channels = @(
        @{ Channel = "3.1"; Quality = "" },
        @{ Channel = "5.0"; Quality = "" },
        @{ Channel = "6.0"; Quality = "Preview" },
        @{ Channel = "7.0"; Quality = "Preview" },
        @{ Channel = "8.0"; Quality = "Preview" },
        @{ Channel = "9.0"; Quality = "Preview" }
        # Add or remove channels as necessary
    )
    
    # Step 3: Iterate over each channel and install the corresponding SDK
    foreach ($channelInfo in $channels) {
        Write-Output "Processing channel: $($channelInfo.Channel) with quality: $($channelInfo.Quality)"
        Install-DotnetSDK -Channel $channelInfo.Channel -Quality $channelInfo.Quality
    }
    
    # Optional: Verify installations
    Verify-DotnetSDKInstallation

    # Pause to allow user to review SDK installations
    Read-Host -Prompt "Press Enter to continue to package installations"
    
    # Step 4: Define the list of .NET SDK packages to install using winget
    $packages = @(
        "Microsoft.DotNet.SDK.5",
        "Microsoft.DotNet.SDK.6",
        "Microsoft.DotNet.SDK.7",
        "Microsoft.DotNet.SDK.8",
        "Microsoft.DotNet.SDK.Preview"
    )
    
    # Step 5: Iterate over each package and install it using winget
    foreach ($package in $packages) {
        Write-Output "Processing package: $package"
        Install-WingetPackage -PackageId $package
    }
    
    # Pause to allow user to review package installations
    Read-Host -Prompt "Press Enter to continue to environment variable setup"
    
    # Step 6: Set .NET environment variables
    Write-Output "Starting to set environment variables"
    Set-DotnetEnvironmentVariables
    
    # Step 7: Verify environment variables
    Verify-EnvironmentVariables
    
    # Final Pause before exiting
    Read-Host -Prompt "Installation and setup complete. Press Enter to exit"
    
} catch {
    Write-Error "An error occurred during the installation process: $_"
    # Optionally, you can decide whether to exit or continue
    exit 1
} finally {
    # Stop transcript
    Stop-Transcript
    Write-Output "Transcript stopped. Log saved to $logFile"
}

