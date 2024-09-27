# PowerShell script to set .NET environment paths on Windows

# Define the path to the .NET SDK
$dotnetSdkPath = "C:\Program Files\dotnet"

# Add the .NET SDK path to the system PATH environment variable
[Environment]::SetEnvironmentVariable(
    "PATH", 
    [Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine) + ";$dotnetSdkPath", 
    [System.EnvironmentVariableTarget]::Machine
)

# Verify the change
$updatedPath = [Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
Write-Output "Updated PATH: $updatedPath"

# Refresh the environment variables in the current session
& cmd /c "refreshenv"
pause