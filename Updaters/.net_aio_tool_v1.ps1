# Function to install .NET SDK versions
function Install-DotnetSDK {
    param (
        [string]$Channel,
        [string]$Quality = ""
    )
    try {
        $command = "./dotnet-install.ps1 -Channel $Channel"
        if ($Quality) {
            $command += " -Quality $Quality"
        }
        Invoke-Expression $command
    } catch {
        Write-Error "Failed to install .NET SDK Channel $Channel $Quality : $_"
        exit 1
    }
}

# Install .NET SDKs with specific channels
$channels = @(
    "1.0", "1.1", "2.0", "2.1",
    "3.0", "3.1", "5.0",
    "6.0 Preview",
    "7.0 Preview",
    "8.0 Preview",
    "9.0 Preview",
    "STS"
)

foreach ($channel in $channels) {
    $parts = $channel.Split(" ")
    $ch = $parts[0]
    $quality = if ($parts.Length -gt 1) { $parts[1] } else { "" }
    Install-DotnetSDK -Channel $ch -Quality $quality
}

pause

# Function to install packages using winget with error handling
function Install-WingetPackage {
    param (
        [string]$PackageId
    )
    try {
        winget install $PackageId
    } catch {
        Write-Error "Failed to install $PackageId : $_"
        exit 1
    }
}

# Install specific .NET SDKs using winget
$packages = @(
    "Microsoft.DotNet.SDK.5",
    "Microsoft.DotNet.SDK.6",
    "Microsoft.DotNet.SDK.7",
    "Microsoft.DotNet.SDK.8",
    "Microsoft.DotNet.SDK.Preview"
)

foreach ($package in $packages) {
    Install-WingetPackage -PackageId $package
}

pause

# Set .NET environment variables
try {
    [System.Environment]::SetEnvironmentVariable("DOTNET_ROOT", "C:\Program Files\dotnet", "Machine")
    $env:PATH += ";C:\Program Files\dotnet"
    [System.Environment]::SetEnvironmentVariable("PATH", $env:PATH, "Machine")
} catch {
    Write-Error "Failed to set environment variables: $_"
    pause
}

# Verify the changes
Write-Output "DOTNET_ROOT=$([System.Environment]::GetEnvironmentVariable('DOTNET_ROOT', 'Machine'))"
Write-Output "PATH=$([System.Environment]::GetEnvironmentVariable('PATH', 'Machine'))"
pause
