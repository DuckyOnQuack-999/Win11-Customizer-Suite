# Ensure the script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    exit
}

# Disable search highlights
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings"
$regName = "IsDynamicSearchBoxEnabled"

If (Test-Path $regPath) {
    Remove-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue
}

# Remove any Group Policy settings related to search highlights
$gpPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
$gpName = "DisableSearchBoxSuggestions"

If (Test-Path $gpPath) {
    Remove-ItemProperty -Path $gpPath -Name $gpName -ErrorAction SilentlyContinue
}

# Notify the user
Write-Host "Search permissions and highlights settings have been reset. Please restart your computer for the changes to take effect." -ForegroundColor Green
pause
