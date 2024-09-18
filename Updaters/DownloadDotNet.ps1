# Function to find the dotnet executable
function Get-DotnetPath {
    $dotnetPaths = $env:Path -split ';' | Where-Object { Test-Path "$_\dotnet.exe" }
    if ($dotnetPaths.Count -gt 0) {
        return "$dotnetPaths[0]\dotnet.exe"
    }
    return $null
}

# Get the path of the dotnet executable
$dotnetExe = Get-DotnetPath
if (-not $dotnetExe) {
    Write-Host "dotnet command not found. Please ensure .NET SDK is installed and added to the system's PATH."
    exit
}

# Define the .NET releases API URL
$apiUrl = "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json"

# Download and parse the JSON from the .NET releases API
$releasesJson = Invoke-RestMethod -Uri $apiUrl

# Function to get all .NET versions including preview versions
function Get-NetVersions {
    $versions = @()
    foreach ($channel in $releasesJson.channels) {
        $channelJson = Invoke-RestMethod -Uri $channel.releases.json
        foreach ($release in $channelJson.releases) {
            $versions += $release
        }
    }
    return $versions
}

# Get all available .NET versions
$allVersions = Get-NetVersions

# Function to download .NET SDK or runtime
function Download-NetSdk {
    param (
        [string]$url,
        [string]$output
    )
    Write-Host "Downloading: $url"
    Invoke-WebRequest -Uri $url -OutFile $output
}

# Get the installed .NET SDKs
$installedSdks = & "$dotnetExe" --list-sdks
$installedVersions = $installedSdks -split "`n" | ForEach-Object { $_.Split()[0] }

# Directory to download .NET installers
$downloadDir = "C:\DotNetDownloads"
if (-Not (Test-Path -Path $downloadDir)) {
    New-Item -Path $downloadDir -ItemType Directory
}

# Loop through all available versions and download if not installed or if update available
foreach ($version in $allVersions) {
    $versionNumber = $version.version
    if ($installedVersions -notcontains $versionNumber) {
        $sdkUrl = $version.sdk.download.url
        $sdkFileName = "$downloadDir\dotnet-sdk-$versionNumber.exe"
        Download-NetSdk -url $sdkUrl -output $sdkFileName
    }
}

Write-Host "All .NET SDKs downloaded successfully."
