# Enhanced Script: Force Kill, Reinstall, and Re-register All AppX Packages with Dependency Checks, Fancy Loading Bar, and Debugging

# Enable detailed error messages and verbose output
$VerbosePreference = "Continue"

Write-Output "=== Starting the AppX Packages Reinstallation and Re-registration Process ==="

# Function to initialize logging
function Initialize-Logging {
    $logFile = "$env:USERPROFILE\Desktop\AppX_Reinstall_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    try {
        Start-Transcript -Path $logFile -Verbose
        Write-Output "Logging initiated. Log file: $logFile"
    }
    catch {
        Write-Warning "Failed to start transcript. Logging will not be recorded. Error: $_"
    }
}

# Function to finalize logging
function Finalize-Logging {
    try {
        Stop-Transcript
        Write-Output "Logging completed."
    }
    catch {
        Write-Warning "Failed to stop transcript. It might not have been started. Error: $_"
    }
}

# Function to terminate AppX related processes
function Terminate-AppXProcesses {
    Write-Output ">> Terminating running AppX-related processes..."

    # Get all AppX packages for all users
    $packages = Get-AppxPackage -AllUsers

    $totalPackages = $packages.Count
    $currentPackage = 0

    foreach ($package in $packages) {
        $currentPackage++
        $percentage = ($currentPackage / $totalPackages) * 100
        $status = "Terminating processes: $currentPackage of $totalPackages packages processed."

        # Update progress bar
        Write-Progress -Activity "Terminating AppX Processes" `
                       -Status $status `
                       -PercentComplete $percentage

        # Attempt to extract a more accurate process name
        # Note: This is a simplistic approach and may not always be accurate
        $processName = $package.Name.Split('.')[0]

        # Attempt to get the process(es)
        $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue

        if ($processes) {
            foreach ($process in $processes) {
                try {
                    Write-Verbose "Attempting to terminate process: $($process.Name) (PID: $($process.Id))"
                    Stop-Process -Id $process.Id -Force -ErrorAction Stop
                    Write-Output "Successfully terminated: $($process.Name) (PID: $($process.Id))"
                }
                catch {
                    Write-Warning "Failed to terminate process: $($process.Name) (PID: $($process.Id)). Error: $_"
                }
            }
        }
        else {
            Write-Verbose "No running process found for package: $($package.Name)"
        }

        # Simulate delay for better visual effect (optional)
        Start-Sleep -Milliseconds 50
    }

    Write-Output ">> Completed terminating AppX-related processes."
    # Clear the progress bar
    Write-Progress -Activity "Terminating AppX Processes" -Completed
}

# Function to re-register AppX packages
function ReRegister-AppXPackages {
    Write-Output ">> Re-registering AppX packages..."

    # Get all AppX packages for all users
    $packages = Get-AppxPackage -AllUsers

    $totalPackages = $packages.Count
    $currentPackage = 0

    foreach ($package in $packages) {
        $currentPackage++
        $percentage = ($currentPackage / $totalPackages) * 100
        $status = "Re-registering packages: $currentPackage of $totalPackages packages processed."

        # Update progress bar
        Write-Progress -Activity "Re-registering AppX Packages" `
                       -Status $status `
                       -PercentComplete $percentage

        try {
            Write-Verbose "Processing package: $($package.Name)"
            $manifestPath = Join-Path $package.InstallLocation "AppXManifest.xml"

            if (Test-Path $manifestPath) {
                Add-AppxPackage -DisableDevelopmentMode -Register $manifestPath -ErrorAction Stop -Verbose
                Write-Output "Successfully re-registered: $($package.Name)"
            }
            else {
                Write-Warning "Manifest file not found for package: $($package.Name). Skipping."
            }
        }
        catch {
            Write-Warning "Failed to re-register: $($package.Name). Error: $_"
        }

        # Simulate delay for better visual effect (optional)
        Start-Sleep -Milliseconds 50
    }

    Write-Output ">> Completed re-registering AppX packages."
    # Clear the progress bar
    Write-Progress -Activity "Re-registering AppX Packages" -Completed
}

# Function to check and reinstall dependencies
function Check-And-ReinstallDependencies {
    Write-Output ">> Checking system dependencies..."

    # Array of dependencies to check
    $dependencies = @(
        @{ Name = "PowerShell"; Command = "powershell.exe"; InstallCommand = "Reinstall PowerShell manually as it is a core component." },
        @{ Name = "Command Prompt (cmd)"; Command = "cmd.exe"; InstallCommand = "Reinstall Command Prompt manually as it is a core component." },
        @{ Name = "Chocolatey (choco)"; Command = "choco"; InstallCommand = "Install Chocolatey from https://chocolatey.org/install" },
        @{ Name = "Winget"; Command = "winget"; InstallCommand = "Install Winget from https://github.com/microsoft/winget-cli/releases" },
        @{ Name = "Python"; Command = "python"; InstallCommand = "Install Python from https://www.python.org/downloads/" }
    )

    foreach ($dep in $dependencies) {
        Write-Output "Checking $($dep.Name)..."

        $command = $dep.Command
        $installInstruction = $dep.InstallCommand

        try {
            if ($dep.Name -eq "PowerShell") {
                # PowerShell is already running; check version
                $version = $PSVersionTable.PSVersion
                Write-Output "PowerShell version: $version"
            }
            elseif ($dep.Name -eq "Command Prompt (cmd)") {
                # Command Prompt is a core component; check existence
                if (Get-Command cmd.exe -ErrorAction SilentlyContinue) {
                    Write-Output "Command Prompt is available."
                }
                else {
                    Write-Warning "Command Prompt is not available."
                    Write-Warning "Please $installInstruction"
                }
            }
            else {
                # For other dependencies, check if the command exists
                if (Get-Command $command -ErrorAction SilentlyContinue) {
                    Write-Output "$($dep.Name) is installed and working."
                }
                else {
                    Write-Warning "$($dep.Name) is not installed or not working."
                    if ($dep.Name -eq "Chocolatey (choco)") {
                        Write-Output "Attempting to install Chocolatey..."
                        Set-ExecutionPolicy Bypass -Scope Process -Force
                        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
                        if (Get-Command choco -ErrorAction SilentlyContinue) {
                            Write-Output "Chocolatey installed successfully."
                        }
                        else {
                            Write-Warning "Failed to install Chocolatey. Please $installInstruction"
                        }
                    }
                    elseif ($dep.Name -eq "Winget") {
                        Write-Output "Attempting to install Winget..."
                        # Winget installation might require downloading the latest installer
                        $wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
                        $wingetInstaller = "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
                        Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetInstaller -UseBasicParsing
                        Add-AppxPackage -Path $wingetInstaller
                        if (Get-Command winget -ErrorAction SilentlyContinue) {
                            Write-Output "Winget installed successfully."
                        }
                        else {
                            Write-Warning "Failed to install Winget. Please $installInstruction"
                        }
                    }
                    elseif ($dep.Name -eq "Python") {
                        Write-Output "Attempting to install Python..."
                        # Download the latest Python installer
                        $pythonUrl = "https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe" # Update to latest version as needed
                        $pythonInstaller = "$env:TEMP\python-installer.exe"
                        Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller -UseBasicParsing
                        Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
                        if (Get-Command python -ErrorAction SilentlyContinue) {
                            Write-Output "Python installed successfully."
                        }
                        else {
                            Write-Warning "Failed to install Python. Please $installInstruction"
                        }
                    }
                }
            }
        }
        catch {
            Write-Warning "Error checking/installing $($dep.Name): $_"
        }

        Write-Output "-----------------------------------------"
    }

    Write-Output ">> Completed checking system dependencies."
}

# Function to check and reinstall PowerShell modules/dependencies
function Check-And-ReinstallModules {
    Write-Output ">> Checking PowerShell modules/dependencies..."

    # Array of modules to check
    $modules = @("PSDesiredStateConfiguration", "PackageManagement", "PowerShellGet") # Add more as needed

    foreach ($module in $modules) {
        Write-Output "Checking module: $module..."

        try {
            if (Get-Module -ListAvailable -Name $module) {
                Write-Output "Module $module is installed."
            }
            else {
                Write-Warning "Module $module is not installed. Attempting to install..."
                Install-Module -Name $module -Force -Scope CurrentUser
                if (Get-Module -ListAvailable -Name $module) {
                    Write-Output "Module $module installed successfully."
                }
                else {
                    Write-Warning "Failed to install module $module."
                }
            }
        }
        catch {
            Write-Warning "Error checking/installing module $module: $_"
        }

        Write-Output "-----------------------------------------"
    }

    Write-Output ">> Completed checking PowerShell modules/dependencies."
}

# Function to display a spinner (optional for added flair)
# Note: Currently unused. Uncomment and integrate as needed.
# function Show-SpinningCursor {
#     param (
#         [int]$Duration = 10
#     )
#
#     $spinner = @("|","/","-","\")
#     $counter = 0
#     $endTime = (Get-Date).AddSeconds($Duration)
#
#     while ((Get-Date) -lt $endTime) {
#         Write-Host -NoNewline "`r$($spinner[$counter % $spinner.Length]) Loading..."
#         Start-Sleep -Milliseconds 250
#         $counter++
#     }
#     Write-Host "`rDone!            "
# }

# Initialize Logging
Initialize-Logging

# Execute main operations within a Try-Catch block
try {
    # Check and reinstall dependencies
    Check-And-ReinstallDependencies

    # Check and reinstall PowerShell modules/dependencies
    Check-And-ReinstallModules

    # Terminate AppX Processes
    Terminate-AppXProcesses

    # Re-register AppX Packages
    ReRegister-AppXPackages

    Write-Output "=== AppX Packages Reinstallation and Re-registration Process Completed ==="
}
catch {
    Write-Warning "An unexpected error occurred: $_"
}
finally {
    # Finalize Logging
    Finalize-Logging

    # Optional: Restart the computer to ensure all changes take effect
    $restart = Read-Host "Do you want to restart the computer now? (Y/N)"
    if ($restart -eq 'Y' -or $restart -eq 'y') {
        Restart-Computer -Force
    }
    else {
        Write-Output "Please remember to restart your computer later to apply all changes."
    }
}
