$ConfigurationData = @{
    AllNodes = @(
      @{
        NodeName                    = 'localhost'
        PSDscAllowPlainTextPassword = $True
      }
    )
}
$pass = (convertto-securestring -asplaintext -force 'vagrant')
$cred = (New-Object System.Management.Automation.PSCredential ('vagrant', $pass))

configuration default {
  param (
    $ComputerName = 'localhost'
  )
  Import-DscResource -Module NuGet
  
  node $ComputerName {
    NuGet default {
      PackageSource = "$ENV:SYSTEMDRIVE\Modules"
      Name = 'Modules'
      Port = 81
      APIKey = 'myapikey'
      AllowNugetPackagePush = $true
      AllowPackageOverwrite = $true
    }
    PSRepo default {
      Ensure = 'Present'
      Name = 'Modules'
      PublishUri = 'http://localhost:81/'
      SourceUri = 'http://localhost:81/nuget'
      InstallPolicy = 'trusted'
      PSDscRunAsCredential = $cred
    }
    NuGet packages {
      PackageSource = "$ENV:SYSTEMDRIVE\Packages"
      Name = 'Packages'
      Port = 82
      APIKey = 'myapikey'
      AllowNugetPackagePush = $true
      AllowPackageOverwrite = $true
    }
    PackageRepo default {
      Ensure = 'Present'
      Name = 'Packages'
      ProviderName = 'Nuget'
      SourceUri = 'http://localhost:82/nuget'
      InstallPolicy = 'Trusted'
      PSDscRunAsCredential = $cred
    }
    PackageRepo choco {
      Ensure = 'Present'
      Name = 'chocolatey'
      ProviderName = 'chocolatey'
      SourceUri = 'http://chocolatey.org/api/v2/'
      InstallPolicy = 'Trusted'
      PSDscRunAsCredential = $cred
    }
    Nuget_Module Steroids {
      Ensure = 'Present'
      Name = 'ISESteroids'
      ProviderName = 'PSGallery'
      Version = '2.3.0.64'
      PSDscRunAsCredential = $cred
    }#>
    Nuget_Package git {
      Ensure = 'Present'
      Name = 'git'
      ProviderName = 'chocolatey'
      Version = '2.7.4'
      PSDscRunAsCredential = $cred
    }#>
    Nuget_Package sublime {
      Ensure = 'Present'
      Name = 'sublimetext3'
      ProviderName = 'chocolatey'
      Version = '3.0.0.3103'
      PSDscRunAsCredential = $cred
    }
  }
}