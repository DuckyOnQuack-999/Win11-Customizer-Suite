@echo off
echo This script will reset your UEFI BCD, remove unnecessary entries, and recreate it from scratch for Windows 11 on the C drive.
echo Make sure you have backups of any important data before proceeding.
pause

:: Step 1: Back up the current BCD
echo Backing up current BCD to C:\bcd_backup.bak...
bcdedit /export C:\bcd_backup.bak
if %errorlevel% neq 0 (
    echo Failed to back up the current BCD. Exiting...
    exit /b 1
)
echo BCD backup completed.

:: Step 2: Delete the current BCD store
echo Deleting current BCD store...
attrib -r -s -h C:\Boot\BCD
del C:\Boot\BCD

:: Deleting from EFI system partition (usually found on the EFI partition)
:: Find and delete from the EFI path
echo Searching for the EFI partition...
mountvol X: /s
if %errorlevel% neq 0 (
    echo Failed to mount the EFI system partition. Exiting...
    exit /b 1
)
echo EFI partition mounted on X:

echo Deleting BCD from EFI partition...
attrib -r -s -h X:\EFI\Microsoft\Boot\BCD
del /f X:\EFI\Microsoft\Boot\BCD
if exist X:\EFI\Boot\bcd (
    attrib -r -s -h X:\EFI\Boot\bcd
    del X:\EFI\Boot\bcd
)
mountvol X: /d
if %errorlevel% neq 0 (
    echo Failed to delete the current EFI BCD. Exiting...
    exit /b 1
)
echo EFI BCD deleted successfully.

:: Step 3: Recreate UEFI BCD for Windows 11
echo Rebuilding UEFI BCD for Windows 11...
bcdboot C:\Windows /l en-us /s X: /f UEFI
if %errorlevel% neq 0 (
    echo Failed to rebuild the BCD. Exiting...
    exit /b 1
)
echo UEFI BCD rebuild completed.

:: Step 4: Remove Unnecessary Entries (Hypervisor only)
echo Removing unwanted Hypervisor settings...
bcdedit /delete {hypervisorsettings}
if %errorlevel% neq 0 (
    echo Failed to remove Hypervisor settings or they may not exist.
)

:: Step 5: Confirm boot entry
echo Here is the current boot configuration:
bcdedit /v
pause

:: Final Step: Restart and test
echo All done! Your UEFI BCD has been reset and recreated for Windows 11 on the C drive.
echo Please restart your computer and verify that everything works as expected.
pause