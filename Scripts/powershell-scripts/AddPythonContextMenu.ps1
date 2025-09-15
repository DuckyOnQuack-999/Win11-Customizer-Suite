# PowerShell script to add context menu for running .py files in Windows Terminal Canary as Admin

$pythonFileKey = "HKCR\Python.File\shell\RunAsAdminWindowsTerminalCanary"
$commandKey = "HKCR\Python.File\shell\RunAsAdminWindowsTerminalCanary\command"

# Path to Windows Terminal Canary (adjust this if needed)
$terminalExe = "$env:LOCALAPPDATA\Microsoft\WindowsApps\Microsoft.WindowsTerminalCanary.exe"

# Command to execute Python scripts in Windows Terminal Canary as Admin
$commandValue = 'powershell.exe -Command "Start-Process wt.exe -ArgumentList ''-d'', ''%V'', ''-NoProfile'', ''python %1'' -Verb RunAs"'

# Add context menu entry
New-Item -Path $pythonFileKey -Force | Out-Null
Set-ItemProperty -Path $pythonFileKey -Name "(Default)" -Value "Run in Windows Terminal Canary as Admin"

# Set icon for context menu entry (Optional)
Set-ItemProperty -Path $pythonFileKey -Name "Icon" -Value $terminalExe

# Add command to execute
New-Item -Path $commandKey -Force | Out-Null
Set-ItemProperty -Path $commandKey -Name "(Default)" -Value $commandValue

Write-Host "Context menu option added successfully!"
