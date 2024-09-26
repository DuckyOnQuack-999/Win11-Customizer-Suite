# Ensure the script is run as administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $IsAdmin) {
    Write-Error "This script must be run as an Administrator. Please rerun it with elevated privileges."
    exit 1
}

# Define the context menu entries for Install, Start, Stop, and Uninstall Service
$contextMenuPath = "Registry::HKEY_CLASSES_ROOT\exefile\shell"

# Function to find InstallUtil.exe dynamically
function Get-InstallUtilPath {
    $frameworkPaths = @(
        "$env:WinDir\Microsoft.NET\Framework64",
        "$env:WinDir\Microsoft.NET\Framework"
    )

    foreach ($path in $frameworkPaths) {
        if (Test-Path $path) {
            $installUtil = Get-ChildItem -Path $path -Recurse -Filter "InstallUtil.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($installUtil) {
                return $installUtil.FullName
            }
        }
    }
    throw "InstallUtil.exe not found in the expected .NET Framework directories."
}

try {
    $installUtilPath = Get-InstallUtilPath
    Write-Host "Found InstallUtil.exe at: $installUtilPath"
} catch {
    Write-Error $_.Exception.Message
    exit 1
}

# Define context menu entries and their corresponding commands
$contextMenuEntries = @{
    "Install Service" = "`"$installUtilPath`" `"%1`""
    "Start Service" = 'powershell -NoProfile -Command "& {Start-Service -Name (Get-CimInstance -ClassName Win32_Service | Where-Object { $_.PathName -like \"\"%1\"\" }).Name}"'
    "Stop Service" = 'powershell -NoProfile -Command "& {Stop-Service -Name (Get-CimInstance -ClassName Win32_Service | Where-Object { $_.PathName -like \"\"%1\"\" }).Name}"'
    "Uninstall Service" = "`"$installUtilPath`" /u `"%1`""
}

foreach ($entry in $contextMenuEntries.GetEnumerator()) {
    $menuName = $entry.Key
    $command = $entry.Value
    $menuPath = "$contextMenuPath\$menuName"

    try {
        # Create the main context menu key
        if (-not (Test-Path $menuPath)) {
            New-Item -Path $menuPath -Force | Out-Null
            Write-Host "Created registry key: $menuPath"
        } else {
            Write-Host "Registry key already exists: $menuPath"
        }

        # Set the default value for the menu entry
        Set-ItemProperty -Path $menuPath -Name "(Default)" -Value $menuName
        Write-Host "Set default value for: $menuName"

        # Create the 'command' subkey
        $commandPath = "$menuPath\command"
        if (-not (Test-Path $commandPath)) {
            New-Item -Path $commandPath -Force | Out-Null
            Write-Host "Created registry key: $commandPath"
        } else {
            Write-Host "Registry key already exists: $commandPath"
        }

        # Set the default value for the 'command' subkey
        Set-ItemProperty -Path $commandPath -Name "(Default)" -Value $command
        Write-Host "Set command for: $menuName"
    } catch {
        Write-Error "Failed to create or set registry keys for '$menuName': $_"
    }
}

Write-Host "Context menu entries for Install, Start, Stop, and Uninstall Service have been created successfully."
