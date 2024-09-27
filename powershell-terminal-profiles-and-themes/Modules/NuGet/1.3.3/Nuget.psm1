enum ensures {
  Present
  Absent
}

enum policies {
  Trusted
  Untrusted
}

enum protocols {
  http
  https
}

Import-Module $PSScriptRoot\tools.psm1

[DscResource()]
class Nuget_Module {
  #Declare Properties
  [DscProperty(Key)]
  [ensures] $Ensure
  [DscProperty(Mandatory)]
  [string] $Name
  [DscProperty()]
  [string] $Version
  [DscProperty(Mandatory)]
  [string] $ProviderName
  
  # Gets the resource's current state.
  [Nuget_Module] Get () {
    return $this
  }
  
  # Tests if the resource is in the desired state.
  [bool] Test () {
    Import-Module $PSScriptRoot\tools.psm1
    return (Module -Ensure $this.ensure -Action Test -Name $this.Name)
  }
  
  # Sets the desired state of the resource.
  [void] Set () {
    Import-Module $PSScriptRoot\tools.psm1
    switch ($this.Version -eq $null) {
      $true {
        Module -Ensure $this.Ensure -Action Set -ProviderName $this.ProviderName -Name $this.Name
      }
      $false {
        Module -Ensure $this.Ensure -Action Set -ProviderName $this.ProviderName -Version $this.Version -Name $this.Name
      }
    }
  }
}

[DscResource()]
class Nuget_Package {
  #Declare Properties
  [DscProperty(Mandatory)]
  [ensures] $Ensure
  [DscProperty(Key)]
  [string] $Name
  [DscProperty()]
  [string] $Version
  [DscProperty(Mandatory)]
  [string] $ProviderName
  
  # Gets the resource's current state.
  [Nuget_Package] Get () {
    return $this
  }
  
  # Tests if the resource is in the desired state.
  [bool] Test () {
    Import-Module $PSScriptRoot\tools.psm1
    return (Package -Ensure $this.ensure -Action Test -Name $this.Name)
  }
  
  # Sets the desired state of the resource.
  [void] Set () {
    Import-Module $PSScriptRoot\tools.psm1
    switch ($this.Version -eq $null) {
      $true {
        Package -Ensure $this.Ensure -Action Set -ProviderName $this.ProviderName -Name $this.Name
      }
      $false {
        Package -Ensure $this.Ensure -Action Set -ProviderName $this.ProviderName -Version $this.Version -Name $this.Name
      }
    }
  }
}

[DSCResource()]
class PackageRepo {
  #Declare Properties
  [DscProperty(Mandatory)] 
  [ensures]$Ensure
  [DscProperty(Mandatory)]
  [string]$Name
  [DscProperty(Key)]
  [string]$ProviderName
  [DscProperty(Mandatory)]
  [string]$SourceUri
  [DscProperty(Mandatory)]
  [policies]$InstallPolicy
  #Define Methods
  #Get Method, gathers data about the system state  
  [PackageRepo] Get () { 
    return $this
  } 
  
  #Test Method, tests if the system is in the desired state 
  [bool] Test () { 
    Import-Module $PSScriptRoot\tools.psm1
    return (package_provider -Name $this.Name -Action test -Ensure $this.Ensure)
  } 
  
  #Replaces Set-TargetResource 
  [void] Set () { 
    Import-Module $PSScriptRoot\tools.psm1
    Write-Verbose 'creating new provider'
    package_provider -Name $this.Name -Action set -SourceURI $this.SourceURI -Credential $this.Credential -Ensure $this.Ensure -ProviderName $this.ProviderName
  }
}

[DSCResource()]
class PSRepo {
  #Declare Properties
  [DscProperty(Mandatory)] 
  [ensures]$Ensure
  [DscProperty(Key)]
  [string]$Name
  [DscProperty()]
  [string]$PublishUri
  [DscProperty()]
  [string]$SourceUri
  [DscProperty()]
  [policies]$InstallPolicy = 'Trusted'
  #Define Methods
  #Get Method, gathers data about the system state  
  [PSRepo] Get () { 
    return $this
  } 
  
  #Test Method, tests if the system is in the desired state 
  [bool] Test () { 
    Import-Module $PSScriptRoot\tools.psm1
    return (provider -Name $this.Name -Action test -Ensure $this.Ensure)
  } 
  
  #Replaces Set-TargetResource 
  [void] Set () { 
    Import-Module $PSScriptRoot\tools.psm1
    Write-Verbose 'creating new provider'
    provider -Name $this.Name -Action set -PublisherURI $this.PublishURI -SourceURI $this.SourceURI -Type $this.InstallPolicy -Credential $this.Credential -Ensure $this.Ensure
  }
}

[DSCResource()]
class NuGet {
  #Declare Properties
  [DscProperty(Key)] 
  [string]$PackageSource
  [DscProperty(Mandatory)]
  [string]$Name
  [DscProperty(Mandatory)]
  [int]$Port
  [DscProperty()]
  [protocols]$Protocol = 'http'
  [DscProperty(Mandatory)]
  [string]$APIKey
  [DscProperty()]
  [Boolean]$AllowNugetPackagePush
  [DscProperty()]
  [Boolean]$AllowPackageOverwrite
  #Define Methods
  #Get Method, gathers data about the system state  
  [NuGet] Get () { 
    return $this
  } 
  
  #Test Method, tests if the system is in the desired state 
  [bool] Test () { 
    Import-Module $PSScriptRoot\tools.psm1
    $Conf = webconfvar -AllowNugetPackagePush $This.AllowNugetPackagePush -AllowPackageOverwrite $This.AllowPackageOverwrite -PackageSource $This.PackageSource -APIKey $This.APIKey
    Write-Verbose 'Working on IIS install'
    if (! (IIS -Action test))
    {
      return $false
    }
    Write-Verbose 'Testing on ASPNet'
    if (! (ASP -Action test))
    {
      return $false
    }
    Write-Verbose 'Testing package directory'
    if (! (pkg -Action test -path $This.PackageSource))
    {
      return $false
    }
    Write-Verbose 'Testing for the website'
    if (! (website -Name $this.Name -Action Test))
    {
      return $false
    }
    Write-Verbose 'Checking WWWRoot files'
    if (! (Zip -Action test -Path $this.PackageSource ))
    {
      return $false
    }
    Write-Verbose 'Checking Web.config'
    if (! (webconf -Action test -Conf $Conf -Path "$($this.PackageSource)\Web.config"))
    {
      return $false
    }
    return $true
  } 
  
  #Replaces Set-TargetResource 
  [void] Set () { 
    Import-Module $PSScriptRoot\tools.psm1
    $Conf = webconfvar -AllowNugetPackagePush $this.AllowNugetPackagePush -AllowPackageOverwrite $this.AllowPackageOverwrite -PackageSource $this.PackageSource -APIKey $this.APIKey
    Write-Verbose 'Working on IIS install'
    if (! (IIS -Action test))
    {
      Write-Verbose 'Installing IIS'
      IIS -Action set
    }
    Write-Verbose 'Working on ASPNet'
    if (! (ASP -Action test))
    {
      Write-Verbose 'Installing ASPNet'
      ASP -Action set
    }
    Write-Verbose 'Working on package directory'
    if (! (pkg -Action test -path $This.PackageSource))
    {
      Write-Verbose 'Creating Package directory'
      pkg -Action set -path $This.PackageSource
    }
    Write-Verbose 'Testing for the website'
    if (! (website -Name $this.Name -Action Test))
    {
      switch ($this.Protocol) {
        http {
          website -Name $this.Name -Action Set -Port $this.Port -Path $this.PackageSource
        }
        https {
          website -Name $this.Name -Action Set -Port $this.Port -Path $this.PackageSource -Ssl
        }
      } 
    }
    Write-Verbose 'Checking WWWRoot files'
    if (! (Zip -Action test ))
    {
      Write-Verbose 'Building out wwwroot'
      Zip -Action set -Path $this.PackageSource
    }
    Write-Verbose 'Checking Web.config'
    if (! (webconf -Action test -Conf $Conf -Path "$($this.PackageSource)\Web.config"))
    {
      Write-Verbose 'setting web.config'
      webconf -Action set -Conf $Conf -Path "$($this.PackageSource)\Web.config"
    }
  }
}