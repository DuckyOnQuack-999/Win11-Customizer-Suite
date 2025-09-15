
# Create a function to set the file association for .ps1 files
Set-PS1FileAssociation
function Set-PS1FileAssociation {
    param (
        [string]$AppPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    )

    $regPath = "HKCU:\Software\Classes\Microsoft.PowerShellScript.1\Shell\Open\Command\"
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "(Default)" -Value "`"$AppPath`" `"%1`""
}

pause