Add-Type -AssemblyName PresentationFramework

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if ($elevated) {
        Write-Host "Elevation attempt failed. Aborting."
        exit
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -ExecutionPolicy Bypass -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
        exit
    }
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

# Check if winget is installed
$wingetPath = (Get-Command winget -ErrorAction SilentlyContinue).Path

if ($null -eq $wingetPath) {
    Write-Output "winget is not installed. Installing winget..."

    # URL to the App Installer package
    $appInstallerUrl = "https://aka.ms/getwinget"

    # Path to save the downloaded App Installer package
    $installerPath = "$env:TEMP\AppInstaller.msi"

    # Download the App Installer package
    Invoke-WebRequest -Uri $appInstallerUrl -OutFile $installerPath

    # Install the App Installer package
    Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$installerPath`" /quiet /norestart" -Wait

    # Clean up the downloaded installer
    Remove-Item -Path $installerPath

    # Check if winget is installed successfully
    $wingetPath = (Get-Command winget -ErrorAction SilentlyContinue).Path
    if ($null -eq $wingetPath) {
        Write-Output "Failed to install winget."
    } else {
        Write-Output "winget installed successfully."
    }
} else {
    Write-Output "winget is already installed."
}

function Update-AppXPackagesWinGet {
    if ($null -ne $wingetPath) {
        try {
            & winget settings --enable InstallerHashOverride --disable-interactivity --nowarn --ignore-warnings --verbose --verbose-logs
            & winget upgrade --all --include-unknown --force --accept-package-agreements --accept-source-agreements --silent --ignore-security-hash --nowarn --ignore-warnings --include-pinned
            $wshell = New-Object -ComObject Wscript.Shell
            $wshell.Popup("Operation Completed", 0, "Done", 0x1)
        } catch {
            Write-Error "Error updating AppX packages with WinGet: $_"
        }
    } else {
        Write-Host "winget is not available on this system."
    }
}

function Reset-AppXPackages {
    try {
        Get-AppxPackage -AllUsers | ForEach-Object {
            Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ForceApplicationShutdown -Verbose
        }
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Operation Completed", 0, "Done", 0x1)
    } catch {
        Write-Error "Error resetting AppX packages: $_"
    }
}

function Update-AllAppXPackages {
    try {
        Get-AppxPackage | ForEach-Object {
            $PackageName = $_.Name
            Write-Host "Checking for updates for $PackageName"
            $UpdateAvailable = (Get-AppxPackage -Name $PackageName).IsUpdateAvailable
            if ($UpdateAvailable) {
                Write-Host "Update available for $PackageName. Updating..."
                $PackageFullName = $_.PackageFullName
                Add-AppxPackage -Path $PackageFullName -Update
            } else {
                Write-Host "No update available for $PackageName."
            }
        }
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Operation Completed", 0, "Done", 0x1)
    } catch {
        Write-Error "Error updating all AppX packages: $_"
    }
}

function TimerResolution {
    Clear-Host
    Write-Host "1. Timer Resolution: On (Recommended)"
    Write-Host "2. Timer Resolution: Default"
    while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
            switch ($choice) {
                1 {
                    try {
                        Clear-Host
                        Write-Host "Installing: Set Timer Resolution Service . . ."
                        $MultilineComment = @"
using System;
using System.Runtime.InteropServices;
using System.ServiceProcess;
using System.ComponentModel;
using System.Configuration.Install;
using System.Collections.Generic;
using System.Reflection;
using System.IO;
using System.Management;
using System.Threading;
using System.Diagnostics;
[assembly: AssemblyVersion("2.1")]
[assembly: AssemblyProduct("Set Timer Resolution service")]
namespace WindowsService
{
    class WindowsService : ServiceBase
    {
        public WindowsService()
        {
            this.ServiceName = "STR";
            this.EventLog.Log = "Application";
            this.CanStop = true;
            this.CanHandlePowerEvent = false;
            this.CanHandleSessionChangeEvent = false;
            this.CanPauseAndContinue = false;
            this.CanShutdown = false;
        }
        static void Main()
        {
            ServiceBase.Run(new WindowsService());
        }
        protected override void OnStart(string[] args)
        {
            base.OnStart(args);
            ReadProcessList();
            NtQueryTimerResolution(out this.MininumResolution, out this.MaximumResolution, out this.DefaultResolution);
            if(null != this.EventLog)
                try { this.EventLog.WriteEntry(String.Format("Minimum={0}; Maximum={1}; Default={2}; Processes='{3}'", this.MininumResolution, this.MaximumResolution, this.DefaultResolution, null != this.ProcessesNames ? String.Join("','", this.ProcessesNames) : "")); }
                catch {}
            if(null == this.ProcessesNames)
            {
                SetMaximumResolution();
                return;
            }
            if(0 == this.ProcessesNames.Count)
            {
                return;
            }
            this.ProcessStartDelegate = new OnProcessStart(this.ProcessStarted);
            try
            {
                String query = String.Format("SELECT * FROM __InstanceCreationEvent WITHIN 0.5 WHERE (TargetInstance isa \"Win32_Process\") AND (TargetInstance.Name=\"{0}\")", String.Join("\" OR TargetInstance.Name=\"", this.ProcessesNames));
                this.startWatch = new ManagementEventWatcher(query);
                this.startWatch.EventArrived += this.startWatch_EventArrived;
                this.startWatch.Start();
            }
            catch(Exception ee)
            {
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Error); }
                    catch {}
            }
        }
        protected override void OnStop()
        {
            if(null != this.startWatch)
            {
                this.startWatch.Stop();
            }

            base.OnStop();
        }
        ManagementEventWatcher startWatch;
        void startWatch_EventArrived(object sender, EventArrivedEventArgs e)
        {
            try
            {
                ManagementBaseObject process = (ManagementBaseObject)e.NewEvent.Properties["TargetInstance"].Value;
                UInt32 processId = (UInt32)process.Properties["ProcessId"].Value;
                this.ProcessStartDelegate.BeginInvoke(processId, null, null);
            }
            catch(Exception ee)
            {
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Warning); }
                    catch {}

            }
        }
        [DllImport("kernel32.dll", SetLastError=true)]
        static extern Int32 WaitForSingleObject(IntPtr Handle, Int32 Milliseconds);
        [DllImport("kernel32.dll", SetLastError=true)]
        static extern IntPtr OpenProcess(UInt32 DesiredAccess, Int32 InheritHandle, UInt32 ProcessId);
        [DllImport("kernel32.dll", SetLastError=true)]
        static extern Int32 CloseHandle(IntPtr Handle);
        const UInt32 SYNCHRONIZE = 0x00100000;
        delegate void OnProcessStart(UInt32 processId);
        OnProcessStart ProcessStartDelegate = null;
        void ProcessStarted(UInt32 processId)
        {
            SetMaximumResolution();
            IntPtr processHandle = IntPtr.Zero;
            try
            {
                processHandle = OpenProcess(SYNCHRONIZE, 0, processId);
                if(processHandle != IntPtr.Zero)
                    WaitForSingleObject(processHandle, -1);
            }
            catch(Exception ee)
            {
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Warning); }
                    catch {}
            }
            finally
            {
                if(processHandle != IntPtr.Zero)
                    CloseHandle(processHandle);
            }
            SetDefaultResolution();
        }
        List<String> ProcessesNames = null;
        void ReadProcessList()
        {
            String iniFilePath = Assembly.GetExecutingAssembly().Location + ".ini";
            if(File.Exists(iniFilePath))
            {
                this.ProcessesNames = new List<String>();
                String[] iniFileLines = File.ReadAllLines(iniFilePath);
                foreach(var line in iniFileLines)
                {
                    String[] names = line.Split(new char[] {',', ' ', ';'} , StringSplitOptions.RemoveEmptyEntries);
                    foreach(var name in names)
                    {
                        String lwr_name = name.ToLower();
                        if(!lwr_name.EndsWith(".exe"))
                            lwr_name += ".exe";
                        if(!this.ProcessesNames.Contains(lwr_name))
                            this.ProcessesNames.Add(lwr_name);
                    }
                }
            }
        }
        [DllImport("ntdll.dll", SetLastError=true)]
        static extern int NtSetTimerResolution(uint DesiredResolution, bool SetResolution, out uint CurrentResolution);
        [DllImport("ntdll.dll", SetLastError=true)]
        static extern int NtQueryTimerResolution(out uint MinimumResolution, out uint MaximumResolution, out uint ActualResolution);
        uint DefaultResolution = 0;
        uint MininumResolution = 0;
        uint MaximumResolution = 0;
        long processCounter = 0;
        void SetMaximumResolution()
        {
            long counter = Interlocked.Increment(ref this.processCounter);
            if(counter <= 1)
            {
                uint actual = 0;
                NtSetTimerResolution(this.MaximumResolution, true, out actual);
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(String.Format("Actual resolution = {0}", actual)); }
                    catch {}
            }
        }
        void SetDefaultResolution()
        {
            long counter = Interlocked.Decrement(ref this.processCounter);
            if(counter < 1)
            {
                uint actual = 0;
                NtSetTimerResolution(this.DefaultResolution, true, out actual);
                if(null != this.EventLog)
                    try { this.EventLog.WriteEntry(String.Format("Actual resolution = {0}", actual)); }
                    catch {}
            }
        }
    }
    [RunInstaller(true)]
    public class WindowsServiceInstaller : Installer
    {
        public WindowsServiceInstaller()
        {
            ServiceProcessInstaller serviceProcessInstaller =
                               new ServiceProcessInstaller();
            ServiceInstaller serviceInstaller = new ServiceInstaller();
            serviceProcessInstaller.Account = ServiceAccount.LocalSystem;
            serviceProcessInstaller.Username = null;
            serviceProcessInstaller.Password = null;
            serviceInstaller.DisplayName = "Set Timer Resolution Service";
            serviceInstaller.StartType = ServiceStartMode.Automatic;
            serviceInstaller.ServiceName = "STR";
            this.Installers.Add(serviceProcessInstaller);
            this.Installers.Add(serviceInstaller);
        }
    }
}
"@
                        Set-Content -Path "$env:C:\Windows\SetTimerResolutionService.cs" -Value $MultilineComment -Force
                        Start-Process -Wait "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe" -ArgumentList "-out:C:\Windows\SetTimerResolutionService.exe C:\Windows\SetTimerResolutionService.cs" -WindowStyle Hidden
                        Remove-Item "$env:C:\Windows\SetTimerResolutionService.cs" -ErrorAction SilentlyContinue | Out-Null
                        New-Service -Name "Set Timer Resolution Service" -BinaryPathName "$env:C:\Windows\SetTimerResolutionService.exe" -ErrorAction SilentlyContinue | Out-Null
                        Set-Service -Name "Set Timer Resolution Service" -StartupType Auto -ErrorAction SilentlyContinue | Out-Null
                        Start-Service -Name "Set Timer Resolution Service" -ErrorAction SilentlyContinue | Out-Null
                        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f | Out-Null
                        for ($i = 1; $i -le 100; $i++) {
                            Write-Progress -Activity "Timer Resolution Installation" -Status "$i% Complete:" -PercentComplete $i
                            Start-Sleep -Milliseconds 50
                        }
                        $wshell = New-Object -ComObject Wscript.Shell
                        $wshell.Popup("Operation Completed", 0, "Done", 0x1)
                        &Show-Menu
                    } catch {
                        Write-Error "Error installing Timer Resolution Service: $_"
                    }
                }
                2 {
                    try {
                        Clear-Host
                        Stop-Service -Name "Set Timer Resolution Service" -ErrorAction SilentlyContinue | Out-Null
                        sc.exe delete "Set Timer Resolution Service" | Out-Null
                        Remove-Item "$env:C:\Windows\SetTimerResolutionService.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                        cmd /c "reg delete `"HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel`" /v `"GlobalTimerResolutionRequests`" /f >nul 2>&1"
                        for ($i = 1; $i -le 100; $i++) {
                            Write-Progress -Activity "Timer Resolution Uninstallation" -Status "$i% Complete:" -PercentComplete $i
                            Start-Sleep -Milliseconds 50
                        }
                        $wshell = New-Object -ComObject Wscript.Shell
                        $wshell.Popup("Operation Completed", 0, "Done", 0x1)
                        &Show-Menu
                    } catch {
                        Write-Error "Error uninstalling Timer Resolution Service: $_"
                    }
                }
            }
        } else { 
            Write-Host "Invalid input. Please select a valid option (1-2)." 
        }
    }
}

function MSIMODE {
    Write-Host "1. Msi Mode: On (Recommended)"
    Write-Host "2. Msi Mode: Default"
    while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
            switch ($choice) {
                1 {
                    try {
                        Clear-Host
                        for ($i = 1; $i -le 100; $i++) {
                            Write-Progress -Activity "Turning On MSI Mode On Your GPU" -Status "$i% Complete:" -PercentComplete $i
                            Start-Sleep -Milliseconds 50
                        }
                        $wshell = New-Object -ComObject Wscript.Shell
                        $wshell.Popup("Operation Completed", 0, "Done", 0x1)
                        $instanceID = (Get-PnpDevice -Class Display).InstanceId
                        reg add "HKLM\SYSTEM\ControlSet001\Enum\$instanceID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f | Out-Null
                        Write-Host "Msi Mode: On . . ."
                        Get-ItemProperty -Path "Registry::HKLM\SYSTEM\ControlSet001\Enum\$instanceID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" -Name "MSISupported"
                        Write-Host "Restart to apply . . ."
                        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                        &Show-Menu
                    } catch {
                        Write-Error "Error turning on MSI Mode: $_"
                    }
                }
                2 {
                    try {
                        Clear-Host
                        for ($i = 1; $i -le 100; $i++) {
                            Write-Progress -Activity "Turning OFF MSI Mode On Your GPU" -Status "$i% Complete:" -PercentComplete $i
                            Start-Sleep -Milliseconds 50
                        }
                        $wshell = New-Object -ComObject Wscript.Shell
                        $wshell.Popup("Operation Completed", 0, "Done", 0x1)
                        $instanceID = (Get-PnpDevice -Class Display).InstanceId
                        reg add "HKLM\SYSTEM\ControlSet001\Enum\$instanceID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "0" /f | Out-Null
                        Write-Host "Msi Mode: Default . . ."
                        Get-ItemProperty -Path "Registry::HKLM\SYSTEM\ControlSet001\Enum\$instanceID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" -Name "MSISupported"
                        Write-Host "Restart to apply . . ."
                        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                        &Show-Menu
                    } catch {
                        Write-Error "Error turning off MSI Mode: $_"
                    }
                }
            }
        } else { 
            Write-Host "Invalid input. Please select a valid option (1-2)." 
        }
    }
}

function Get-FileFromWeb {
    param (
        [Parameter(Mandatory)][string]$URL, 
        [Parameter(Mandatory)][string]$File
    )
    function Show-Progress {
        param (
            [Parameter(Mandatory)][Single]$TotalValue, 
            [Parameter(Mandatory)][Single]$CurrentValue, 
            [Parameter(Mandatory)][string]$ProgressText, 
            [Parameter()][int]$BarSize = 10, 
            [Parameter()][switch]$Complete
        )
        $percent = $CurrentValue / $TotalValue
        $percentComplete = $percent * 100
        if ($psISE) { 
            Write-Progress "$ProgressText" -id 0 -percentComplete $percentComplete 
        } else { 
            Write-Host -NoNewLine "`r$ProgressText $(''.PadRight($BarSize * $percent, [char]9608).PadRight($BarSize, [char]9617)) $($percentComplete.ToString('##0.00').PadLeft(6)) % " 
        }
    }
    try {
        $request = [System.Net.HttpWebRequest]::Create($URL)
        $response = $request.GetResponse()
        if ($response.StatusCode -eq 401 -or $response.StatusCode -eq 403 -or $response.StatusCode -eq 404) { 
            throw "Remote file either doesn't exist, is unauthorized, or is forbidden for '$URL'." 
        }
        if ($File -match '^\.\\') { 
            $File = Join-Path (Get-Location -PSProvider 'FileSystem') ($File -Split '^\.')[1] 
        }
        if ($File -and !(Split-Path $File)) { 
            $File = Join-Path (Get-Location -PSProvider 'FileSystem') $File 
        }
        if ($File) { 
            $fileDirectory = $([System.IO.Path]::GetDirectoryName($File)); 
            if (!(Test-Path($fileDirectory))) { 
                [System.IO.Directory]::CreateDirectory($fileDirectory) | Out-Null 
            } 
        }
        [long]$fullSize = $response.ContentLength
        [byte[]]$buffer = new-object byte[] 1048576
        [long]$total = [long]$count = 0
        $reader = $response.GetResponseStream()
        $writer = new-object System.IO.FileStream $File, 'Create'
        do {
            $count = $reader.Read($buffer, 0, $buffer.Length)
            $writer.Write($buffer, 0, $count)
            $total += $count
            if ($fullSize -gt 0) { 
                Show-Progress -TotalValue $fullSize -CurrentValue $total -ProgressText " $($File.Name)" 
            }
        } while ($count -gt 0)
    } catch {
        Write-Error "Error downloading file from $URL $_"
    } finally {
        $reader.Close()
        $writer.Close()
    }
}

function DirectXInstaller {
    try {
        Clear-Host
        Write-Host "Installing: Direct X . . ."
        Get-FileFromWeb -URL "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" -File "$env:TEMP\DirectX.exe"
        Get-FileFromWeb -URL "https://www.7-zip.org/a/7z2301-x64.exe" -File "$env:TEMP\7-Zip.exe"
        Start-Process -wait "$env:TEMP\7-Zip.exe" /S
        cmd /c "C:\Program Files\7-Zip\7z.exe" x "$env:TEMP\DirectX.exe" -o"$env:TEMP\DirectX" -y | Out-Null
        Start-Process "$env:TEMP\DirectX\DXSETUP.exe"
    } catch {
        Write-Error "Error installing DirectX: $_"
    }
}

function VisualCPPInstaller {
    try {
        Clear-Host
        Write-Host "Installing: C ++ . . ."
        Get-FileFromWeb -URL "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE" -File "$env:TEMP\vcredist2005_x86.exe"
        Get-FileFromWeb -URL "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE" -File "$env:TEMP\vcredist2005_x64.exe"
        Get-FileFromWeb -URL "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" -File "$env:TEMP\vcredist2008_x86.exe"
        Get-FileFromWeb -URL "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" -File "$env:TEMP\vcredist2008_x64.exe"
        Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe" -File "$env:TEMP\vcredist2010_x86.exe"
        Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" -File "$env:TEMP\vcredist2010_x64.exe"
        Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -File "$env:TEMP\vcredist2012_x86.exe"
        Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" -File "$env:TEMP\vcredist2012_x64.exe"
        Get-FileFromWeb -URL "https://aka.ms/highdpimfc2013x86enu" -File "$env:TEMP\vcredist2013_x86.exe"
        Get-FileFromWeb -URL "https://aka.ms/highdpimfc2013x64enu" -File "$env:TEMP\vcredist2013_x64.exe"
        Get-FileFromWeb -URL "https://aka.ms/vs/17/release/vc_redist.x86.exe" -File "$env:TEMP\vcredist2015_2017_2019_2022_x86.exe"
        Get-FileFromWeb -URL "https://aka.ms/vs/17/release/vc_redist.x64.exe" -File "$env:TEMP\vcredist2015_2017_2019_2022_x64.exe"
        Start-Process -wait "$env:TEMP\vcredist2005_x86.exe" -ArgumentList "/q"
        Start-Process -wait "$env:TEMP\vcredist2005_x64.exe" -ArgumentList "/q"
        Start-Process -wait "$env:TEMP\vcredist2008_x86.exe" -ArgumentList "/qb"
        Start-Process -wait "$env:TEMP\vcredist2008_x64.exe" -ArgumentList "/qb"
        Start-Process -wait "$env:TEMP\vcredist2010_x86.exe" -ArgumentList "/passive /norestart"
        Start-Process -wait "$env:TEMP\vcredist2010_x64.exe" -ArgumentList "/passive /norestart"
        Start-Process -wait "$env:TEMP\vcredist2012_x86.exe" -ArgumentList "/passive /norestart"
        Start-Process -wait "$env:TEMP\vcredist2012_x64.exe" -ArgumentList "/passive /norestart"
        Start-Process -wait "$env:TEMP\vcredist2013_x86.exe" -ArgumentList "/passive /norestart"
        Start-Process -wait "$env:TEMP\vcredist2013_x64.exe" -ArgumentList "/passive /norestart"
        Start-Process -wait "$env:TEMP\vcredist2015_2017_2019_2022_x86.exe" -ArgumentList "/passive /norestart"
        Start-Process -wait "$env:TEMP\vcredist2015_2017_2019_2022_x64.exe" -ArgumentList "/passive /norestart"
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Visual C++ Redistributables Installed Successfully", 0, "Done", 0x1)
    } catch {
        Write-Error "Error installing Visual C++ Redistributables: $_"
    }
}

function RegTweaks {
    try {
        Clear-Host
        Write-Host "Registry: Optimize . . ."
        $MultilineComment = @"
Windows Registry Editor Version 5.00

; --LEGACY CONTROL PANEL--

[HKEY_CURRENT_USER\Control Panel\Accessibility\HighContrast]
"Flags"="4194"

[HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response]
"Flags"="2"
"AutoRepeatRate"="0"
"AutoRepeatDelay"="0"

[HKEY_CURRENT_USER\Control Panel\Accessibility\MouseKeys]
"Flags"="130"
"MaximumSpeed"="39"
"TimeToMaximumSpeed"="3000"

; APPEARANCE AND PERSONALIZATION

; disable show files from office.com
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer]
"ShowCloudFilesInQuickAccess"=dword:00000000

; enable display full path in the title bar
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState]
"FullPath"=dword:00000001

; HARDWARE AND SOUND

; disable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="0"
"MouseThreshold1"="0"
"MouseThreshold2"="0"

; disable device installation settings
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata]
"PreventDeviceMetadataFromNetwork"=dword:00000001

; SYSTEM AND SECURITY

; animate windows when minimizing and maximizing
[HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics]
"MinAnimate"="1"

; enable animations in the taskbar
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarAnimations"=dword:1

; enable enable peek
[HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM]
"EnableAeroPeek"=dword:1

; disable save taskbar thumbnail previews
[HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM]
"AlwaysHibernateThumbnails"=dword:0

; enable show thumbnails instead of icons
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"IconsOnly"=dword:0

; enable show translucent selection rectangle
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ListviewAlphaSelect"=dword:1

; enable show window contents while dragging
[HKEY_CURRENT_USER\Control Panel\Desktop]
"DragFullWindows"="1"

; enable smooth edges of screen fonts
[HKEY_CURRENT_USER\Control Panel\Desktop]
"FontSmoothing"="2"

; enable use drop shadows for icon labels on the desktop
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ListviewShadow"=dword:1

; adjust for best performance of programs
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl]
"Win32PrioritySeparation"=dword:00000026

; disable remote assistance
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance]
"fAllowToGetHelp"=dword:00000000

; --IMMERSIVE CONTROL PANEL--

; GAMING
; disable game bar
[HKEY_CURRENT_USER\System\GameConfigStore]
"GameDVR_Enabled"=dword:00000000

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR]
"AppCaptureEnabled"=dword:00000000

; disable enable open xbox game bar using game controller
[HKEY_CURRENT_USER\Software\Microsoft\GameBar]
"UseNexusForGameBarEnabled"=dword:00000000

; other settings
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR]
"AudioEncodingBitrate"=dword:0001f400
"AudioCaptureEnabled"=dword:00000000
"CustomVideoEncodingBitrate"=dword:003d0900
"CustomVideoEncodingHeight"=dword:000002d0
"CustomVideoEncodingWidth"=dword:00000500
"HistoricalBufferLength"=dword:0000001e
"HistoricalBufferLengthUnit"=dword:00000001
"HistoricalCaptureEnabled"=dword:00000000
"HistoricalCaptureOnBatteryAllowed"=dword:00000001
"HistoricalCaptureOnWirelessDisplayAllowed"=dword:00000001
"MaximumRecordLength"=hex(b):00,D0,88,C3,10,00,00,00
"VideoEncodingBitrateMode"=dword:00000002
"VideoEncodingResolutionMode"=dword:00000002
"VideoEncodingFrameRateMode"=dword:00000000
"EchoCancellationEnabled"=dword:00000001
"CursorCaptureEnabled"=dword:00000000
"VKToggleGameBar"=dword:00000000
"VKMToggleGameBar"=dword:00000000
"VKSaveHistoricalVideo"=dword:00000000
"VKMSaveHistoricalVideo"=dword:00000000
"VKToggleRecording"=dword:00000000
"VKMToggleRecording"=dword:00000000
"VKTakeScreenshot"=dword:00000000
"VKMTakeScreenshot"=dword:00000000
"VKToggleRecordingIndicator"=dword:00000000
"VKMToggleRecordingIndicator"=dword:00000000
"VKToggleMicrophoneCapture"=dword:00000000
"VKMToggleMicrophoneCapture"=dword:00000000
"VKToggleCameraCapture"=dword:00000000
"VKMToggleCameraCapture"=dword:00000000
"VKToggleBroadcast"=dword:00000000
"VKMToggleBroadcast"=dword:00000000
"MicrophoneCaptureEnabled"=dword:00000000
"SystemAudioGain"=hex(b):10,27,00,00,00,00,00,00
"MicrophoneGain"=hex(b):10,27,00,00,00,00,00,00

; PRIVACY

; disable radios
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios]
"Value"="Deny"

; disable background apps
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications]
"GlobalUserDisabled"=dword:00000001

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search]
"BackgroundAppGlobalToggle"=dword:00000000

; APPS
; disable automatically update maps
[HKEY_LOCAL_MACHINE\SYSTEM\Maps]
"AutoUpdateEnabled"=dword:00000000

; disable archive apps
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Appx]
"AllowAutomaticAppArchiving"=dword:00000000

; PERSONALIZATION
; solid color personalize your background

; dark theme
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"AppsUseLightTheme"=dword:00000000
"SystemUsesLightTheme"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"AppsUseLightTheme"=dword:00000000

[HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM]
"EnableWindowColorization"=dword:00000001

; more pins personalization start
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_Layout"=dword:00000001

; show all taskbar icons
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer]
"EnableAutoTray"=dword:00000000

; remove security taskbar icon
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run]
"SecurityHealth"=hex(3):07,00,00,00,05,DB,8A,69,8A,49,D9,01

; DEVICES
; disable usb issues notify

; disable let windows manage my default printer
[HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows]
"LegacyDefaultPrinterMode"=dword:00000001

; SYSTEM
; 100% dpi scaling
[HKEY_CURRENT_USER\Control Panel\Desktop]
"LogPixels"=dword:00000060
"Win8DpiScaling"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM]
"UseDpiScaling"=dword:00000000

; disable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000000

; turn on hardware accelerated gpu scheduling
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers]
"HwSchMode"=dword:00000002

; disable variable refresh rate & enable optimizations for windowed games
[HKEY_CURRENT_USER\Software\Microsoft\DirectX\UserGpuPreferences]
"DirectXUserGlobalSettings"="SwapEffectUpgradeEnable=1;VRROptimizeEnable=0;"

; disable storage sense
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\StorageSense]
"AllowStorageSenseGlobal"=dword:00000000

; --OTHER--

; --CAN'T DO NATIVELY--

; GRAPHICS
; enable mpo (multi plane overlay)
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm]
"OverlayTestMode"=-

; games scheduling (performance)
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games]
"Affinity"=dword:00000000
"Background Only"="False"
"Clock Rate"=dword:00002710
"GPU Priority"=dword:00000008
"Priority"=dword:00000006
"Scheduling Category"="High"
"SFIO Priority"="High"

; POWER
; unpark cpu cores
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583]
"ValueMax"=dword:00000000

; disable power throttling
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling]
"PowerThrottlingOff"=dword:00000001

; network throttling & system responsiveness
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile]
"NetworkThrottlingIndex"=dword:ffffffff
"SystemResponsiveness"=dword:00000000

; fix timer resolution
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel]
"GlobalTimerResolutionRequests"=dword:00000001

;NVIDIA Driver Thread Priority
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters]
"ThreadPriority"=dword:0000001F

; OTHER
; remove 3d objects
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}]

[-HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}]

; disable menu show delay
[HKEY_CURRENT_USER\Control Panel\Desktop]
"MenuShowDelay"="0"

; mouse fix
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	C0,CC,0C,00,00,00,00,00,\
	80,99,19,00,00,00,00,00,\
	40,66,26,00,00,00,00,00,\
	00,33,33,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

[HKEY_USERS\.DEFAULT\Control Panel\Mouse]
"MouseSpeed"="0"
"MouseThreshold1"="0"
"MouseThreshold2"="0"
"@
        Set-Content -Path "$env:TEMP\Registry Optimize.reg" -Value $MultilineComment -Force
        $path = "$env:TEMP\Registry Optimize.reg"
        (Get-Content $path) -replace "\?","$" | Out-File $path
        Regedit.exe /S "$env:TEMP\Registry Optimize.reg"
        Clear-Host
        for ($i = 1; $i -le 100; $i++) {
            Write-Progress -Activity "Tweaking The Registry" -Status "$i% Complete:" -PercentComplete $i
            Start-Sleep -Milliseconds 50
        }
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Restart to apply . . .", 0, "Done", 0x1)
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } catch {
        Write-Error "Error applying registry tweaks: $_"
    }
}

function WindowsRepair {
    try {
        Write-Host "Stopping Windows Update and Windows Store Services..."
        Stop-Service -Name wuauserv -Force
        Stop-Service -Name cryptSvc -Force
        Stop-Service -Name bits -Force
        Stop-Service -Name msiserver -Force
        Write-Host "Clearing Windows Store cache..."
        wsreset.exe
        Get-AppXPackage -AllUsers | ForEach-Object {
            Write-Output "Repairing and re-registering: $($_.Name)"
            try {
                Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ForceApplicationShutdown -Verbose -ErrorAction Stop
                Write-Output "Successfully re-registered: $($_.Name)"
            } catch {
                Write-Error "Failed to re-register: $($_.Name). Error: $_"
            }
        }
        Write-Host "Clearing Windows Store cache..."
        wsreset.exe
        Write-Host "Starting Windows Update and Windows Store Services..."
        Start-Service -Name wuauserv
        Start-Service -Name cryptSvc
        Start-Service -Name bits
        Start-Service -Name msiserver
        Write-Host "Windows Store has been reset and services restarted."
        Write-Output "Running System File Checker (SFC)..."
        try {
            sfc /scannow
            Write-Output "SFC scan completed."
        } catch {
            Write-Error "SFC scan failed. Error: $_"
        }
        Write-Output "Running Deployment Imaging Service and Management Tool (DISM)..."
        try {
            DISM /Online /Cleanup-Image /RestoreHealth
            Write-Output "DISM scan completed."
        } catch {
            Write-Error "DISM scan failed. Error: $_"
        }
        Write-Output "AppX package repair and re-registration process completed."
    } catch {
        Write-Error "Error during Windows repair process: $_"
    }
}

function RepairStore {
	
}

function ClearExplorerCache {
    try {
        Stop-Process -Name explorer -Force
        $cachePaths = @(
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db",
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\IconCacheToDelete",
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\IconCache.db",
            "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db"
        )
        foreach ($path in $cachePaths) {
            Remove-Item $path -Force -ErrorAction SilentlyContinue
        }
        for ($i = 1; $i -le 100; $i++) {
            Write-Progress -Activity "Clearing File Explorer's Cache" -Status "$i% Complete:" -PercentComplete $i
            Start-Sleep -Milliseconds 50
        }
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Restart Explorer . . .", 0, "Done", 0x1)
        Start-Process explorer.exe
    } catch {
        Write-Error "Error clearing File Explorer cache: $_"
    }
}

function Show-Menu {
    $XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="WinKit v1" Height="450" Width="800">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>
        <TextBlock Grid.Row="0" Grid.Column="0" Margin="10" FontSize="16" Text="Select an Option:"/>
        <StackPanel Grid.Row="1" Grid.Column="0" Margin="10">
            <Button Name="UpdateAppXPackagesWinGet" Content="Update AppXPackages (Winget)" Width="200" Margin="5"/>
            <Button Name="ResetAppXPackages" Content="Reset AppXPackages" Width="200" Margin="5"/>
            <Button Name="UpdateAllAppXPackages" Content="Update All AppXPackages" Width="200" Margin="5"/>
            <Button Name="TimerResolution" Content="Timer Resolution Server Install" Width="200" Margin="5"/>
            <Button Name="MSIMODE" Content="MSI Mode" Width="200" Margin="5"/>
            <Button Name="DirectXInstaller" Content="DirectX Installer" Width="200" Margin="5"/>
            <Button Name="VisualCPPInstaller" Content="Visual C++ Installer" Width="200" Margin="5"/>
            <Button Name="RegTweaks" Content="Registry Tweaks" Width="200" Margin="5"/>
            <Button Name="WindowsRepair" Content="Windows Repair" Width="200" Margin="5"/>
            <Button Name="RepairStore" Content="Repair Windows Store" Width="200" Margin="5"/>
            <Button Name="ClearExplorerCache" Content="Clear File Explorer Cache" Width="200" Margin="5"/>
        </StackPanel>
    </Grid>
</Window>
"@

    [xml]$XAML = $XAML
    $Reader = (New-Object System.Xml.XmlNodeReader $XAML)
    $Form = [Windows.Markup.XamlReader]::Load( $Reader )

    $Form.FindName("UpdateAppXPackagesWinGet").Add_Click({ Update-AppXPackagesWinGet })
    $Form.FindName("ResetAppXPackages").Add_Click({ Reset-AppXPackages })
    $Form.FindName("UpdateAllAppXPackages").Add_Click({ Update-AllAppXPackages })
    $Form.FindName("TimerResolution").Add_Click({ TimerResolution })
    $Form.FindName("MSIMODE").Add_Click({ MSIMODE })
    $Form.FindName("DirectXInstaller").Add_Click({ DirectXInstaller })
    $Form.FindName("VisualCPPInstaller").Add_Click({ VisualCPPInstaller })
    $Form.FindName("RegTweaks").Add_Click({ RegTweaks })
    $Form.FindName("WindowsRepair").Add_Click({ WindowsRepair })
    $Form.FindName("RepairStore").Add_Click({ RepairStore })
    $Form.FindName("ClearExplorerCache").Add_Click({ ClearExplorerCache })

    $Form.ShowDialog() | Out-Null
}

Show-Menu
