@echo off
setlocal
set "target=%1"
set "target=%target:"=%"
if "%target:~-4%"==".exe" (
    PowerShell -Command "$app = Get-StartApps | Where-Object {$_.InstallLocation -like '*%target%*'}; if ($app) {Start-Process -FilePath $target -WindowStyle Hidden; (New-Object -ComObject Shell.Application).NameSpace((Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband').TaskbarPin | Split-Path -Parent).ParseName((Get-Item -Path $target).Name).InvokeVerb('Pin to Tas&kbar')}"
) else (
    echo This option only works for .exe files.
)
endlocal
