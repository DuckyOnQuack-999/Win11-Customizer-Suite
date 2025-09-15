# Ensure the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You need to run this script as an administrator."
    exit
}

# Set up error logging
$errorLog = "$env:TEMP\Set-ExecutionPolicy-GPO_ErrorLog.txt"
Remove-Item -Path $errorLog -ErrorAction Ignore

# Function to write errors to log
function Log-Error {
    param ([string]$message)
    $message | Out-File -FilePath $errorLog -Append
}

# Function to install RSAT Group Policy Management Tools
function Install-RSATGroupPolicy {
    Write-Output "Installing RSAT Group Policy Management Tools..."
    $featureName = "RSAT: Group Policy Management Tools"
    
    try {
        if (Get-WindowsCapability -Online | Where-Object { $_.Name -like "Rsat.GroupPolicy.ManagementTools*" }) {
            Add-WindowsCapability -Online -Name "Rsat.GroupPolicy.ManagementTools~~~~0.0.1.0"
            Write-Output "$featureName installed successfully."
        } else {
            Write-Error "$featureName is not available on this version of Windows."
            exit
        }
    } catch {
        Log-Error "Failed to install $featureName : $_"
        Write-Error "Failed to install $featureName. Check the log for details: $errorLog"
        exit
    }
}

# Check if the GroupPolicy module is available, install RSAT if not
try {
    if (-not (Get-Module -ListAvailable -Name GroupPolicy)) {
        Install-RSATGroupPolicy
    }

    # Import the Group Policy module
    Import-Module GroupPolicy
} catch {
    Log-Error "Failed to load GroupPolicy module : $_"
    Write-Error "Failed to load GroupPolicy module. Check the log for details: $errorLog"
    exit
}

# Set the Group Policy path for PowerShell script execution
$GPOName = "Default Domain Policy" # You can change this to your specific GPO
try {
    $GPO = Get-GPO -Name $GPOName
} catch {
    Log-Error "Failed to get GPO $GPOName : $_"
    Write-Error "Failed to get GPO $GPOName. Check the log for details: $errorLog"
    exit
}

# Set the execution policy to RemoteSigned for both Computer and User configuration
try {
    # Computer Configuration
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell" -ValueName "EnableScripts" -Type DWord -Value 1
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell" -ValueName "ExecutionPolicy" -Type String -Value "RemoteSigned"

    # User Configuration
    Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Policies\Microsoft\Windows\PowerShell" -ValueName "EnableScripts" -Type DWord -Value 1
    Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Policies\Microsoft\Windows\PowerShell" -ValueName "ExecutionPolicy" -Type String -Value "RemoteSigned"
} catch {
    Log-Error "Failed to set execution policy : $_"
    Write-Error "Failed to set execution policy. Check the log for details: $errorLog"
    exit
}

Write-Output "Execution policy has been set to RemoteSigned for both Computer and User configuration in the $GPOName."
