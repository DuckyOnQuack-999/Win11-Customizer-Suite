# Enable strict error checking and logging
$ErrorActionPreference = "Stop"

# Function to log errors
function Log-Error {
    param (
        [string]$Message
    )
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Error $Message
}

# 1. Get the current logged-in user (will preserve this account)
try {
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split("\")[-1]
    Write-Host "Current logged-in user: $currentUser"
} catch {
    Log-Error "Failed to detect the current logged-in user."
    exit 1  # Exit since we can't proceed without knowing the current user
}

# 2. Enable the built-in Administrator account
try {
    Write-Host "Enabling built-in Administrator account..."
    net user Administrator /active:yes
    net user Administrator * /add   # You can replace * with your preferred password
} catch {
    Log-Error "Failed to enable the built-in Administrator account."
}

# 3. Disable the Guest account (if enabled)
try {
    Write-Host "Disabling Guest account..."
    net user Guest /active:no
} catch {
    Log-Error "Failed to disable the Guest account."
}

# 4. Identify non-default user accounts (excluding the current user and system accounts)
try {
    $defaultSystemAccounts = @("Administrator", "Guest", "WDAGUtilityAccount", "DefaultAccount")
    $allUsers = Get-LocalUser | Where-Object { $_.Name -notin $defaultSystemAccounts -and $_.Name -ne $currentUser }
    if ($allUsers.Count -eq 0) {
        Write-Host "No non-default users found."
    } else {
        Write-Host "Non-default user accounts found: $($allUsers.Name -join ', ')"
        foreach ($user in $allUsers) {
            try {
                Write-Host "Disabling user account: $($user.Name)"
                net user $user.Name /active:no
            } catch {
                Log-Error "Failed to disable user account: $($user.Name)"
            }
        }
    }
} catch {
    Log-Error "Failed to identify non-default user accounts."
}

# 5. Ensure the current user remains an administrator
try {
    Write-Host "Ensuring $currentUser remains active and in Administrators group..."
    net user $currentUser /active:yes
    Add-LocalGroupMember -Group "Administrators" -Member $currentUser -ErrorAction Stop
} catch {
    Log-Error "Failed to ensure $currentUser remains in Administrators group."
}

# 6. Reset group memberships for the Administrator account
try {
    Write-Host "Resetting group memberships for Administrator..."
    Remove-LocalGroupMember -Group "Users" -Member "Administrator" -ErrorAction SilentlyContinue
    Remove-LocalGroupMember -Group "Guests" -Member "Administrator" -ErrorAction SilentlyContinue
    Add-LocalGroupMember -Group "Administrators" -Member "Administrator" -ErrorAction Stop
} catch {
    Log-Error "Failed to reset group memberships for Administrator."
}

# 7. Reset group memberships for the Guest account
try {
    Write-Host "Resetting group memberships for Guest..."
    Remove-LocalGroupMember -Group "Users" -Member "Guest" -ErrorAction SilentlyContinue
    Remove-LocalGroupMember -Group "Administrators" -Member "Guest" -ErrorAction SilentlyContinue
} catch {
    Log-Error "Failed to reset group memberships for Guest."
}

# 8. Ensure the default system accounts are in the correct groups
try {
    Write-Host "Resetting group memberships for default system accounts..."
    $defaultGroups = @{
        "Administrators" = @("Administrator", "WDAGUtilityAccount")
        "Users"          = @("DefaultAccount", "WDAGUtilityAccount")
        "Guests"         = @("Guest")
    }

    foreach ($group in $defaultGroups.Keys) {
        foreach ($account in $defaultGroups[$group]) {
            try {
                Add-LocalGroupMember -Group $group -Member $account -ErrorAction Stop
                Write-Host "Added $account to $group group."
            } catch {
                Log-Error "Failed to add $account to $group group."
            }
        }
    }
} catch {
    Log-Error "Failed to reset group memberships for default system accounts."
}

# 9. Recreate default groups if they were deleted (optional)
try {
    Write-Host "Recreating default groups if needed..."
    $defaultLocalGroups = @(
        "Administrators", "Users", "Guests", "Backup Operators", "Cryptographic Operators", "Device Owners",
        "Distributed COM Users", "Event Log Readers", "Hyper-V Administrators", "IIS_IUSRS", 
        "Network Configuration Operators", "Performance Log Users", "Performance Monitor Users",
        "Power Users", "Remote Desktop Users", "Remote Management Users", "Replicator"
    )

    foreach ($group in $defaultLocalGroups) {
        if (-not (Get-LocalGroup -Name $group -ErrorAction SilentlyContinue)) {
            try {
                New-LocalGroup -Name $group
                Write-Host "Created missing group: $group."
            } catch {
                Log-Error "Failed to create missing group: $group."
            }
        }
    }
} catch {
    Log-Error "Failed to recreate default groups."
}

Write-Host "Reset of local users and groups complete. Current user '$currentUser' has been preserved as an administrator."
