enum actions {
  Set
  Test
}

enum ensures {
  Present
  Absent
}

function Module {
  param (
    [actions]$Action,
    [string]$Name,
    [System.Version]$Version,
    [string]$ProviderName,
    [ensures]$Ensure
  )
  switch ($Action) {
    Test {
      $Module = Get-Module -ListAvailable -Name $Name
      if ((! $Module) -or ($Module.version -lt $Version)) {$return = $false}
      else {$return = $true}
      switch ($Ensure) {
        Present {
          $return
        }
        Absent {
          ! $return
        }
      }
    }
    Set {
      switch ($Ensure) {
        Present {
          $params = @{
            Repository = $ProviderName
            Name = $Name
          }
          if ($Version) {
            $params.Add('RequiredVersion',$Version)
          }
          Find-Module @params| Install-Module -Force -Scope AllUsers
        }
        Absent {
          Uninstall-Module -Name $Name -Force
        }
      }
    }
  }
}

function Package {
  param (
    [actions]$Action,
    [string]$Name,
    [version]$Version,
    [string]$ProviderName,
    [ensures]$Ensure
  )
  switch ($Action) {
    Test {
      $pkg = Get-Package -Name $Name -ErrorAction SilentlyContinue
      if ((! $pkg) -or ($pkg.version -lt $Version)) {$return = $false}
      else {$return = $true}
      switch ($Ensure) {
        Present {
          $return
        }
        Absent {
          ! $return
        }
      }
    }
    Set {
      switch ($Ensure) {
        Present {
          Find-Package -Source $ProviderName -Name $Name -RequiredVersion $Version | Install-Package -Force -Scope AllUsers
        }
        Absent {
          Uninstall-Package -Name $Name -Force
        }
      }
    }
  }
}

function website {
  param (
    [string]$Name,
    [string]$Path,
    [int]$Port,
    [switch]$Ssl,
    [actions]$Action
  )
  switch ($Action)
  {
    'test' {
      if (get-website -name $Name) {
        return $true
      } 
      else {
        return $false
      }
    }
    'set' {
      switch ($Ssl) {
        $True {
          New-Website -Name $Name -PhysicalPath $Path -Port $Port -Ssl
        }
        $False {
          New-Website -Name $Name -PhysicalPath $Path -Port $Port
        }
      }
      
    }
  }
}

function IIS {
  param (
    [validateset('test','set')]
    [actions]$Action
  )
  switch ($Action)
  {
    'test' {
      (get-windowsfeature -name Web-Server).installed
    }
    'set' {
      Add-WindowsFeature -Name Web-Server
    }
  }
}

function ASP {
  param (
      [validateset('test','set')]
      [actions]$Action
    )
  switch ($Action) {
      'test' {
          (get-windowsfeature -name Web-Asp-Net45).installed
        }
      'set' {
          Add-WindowsFeature -Name Web-Asp-Net45
        }
    }
}

function Zip {
  param (
    [validateset('test','set')]
    [actions]$Action,
    [string]$Path = "$env:Systemdrive\inetpub\wwwroot"
  )
  $names = @(
    'App_Readme'
    'bin'
    'DataServices'
    'obj'
    'Packages'
    'Properties'
    'Default.aspx'
    'favicon.ico'
    'LocalNuGetFeed.csproj'
    'LocalNuGetFeed.csproj.user'
    'packages.config'
    'Web.config'
    'Web.Release.config'
  )
  switch ($Action) {
    'test' {
        $return = $names | foreach {
            Test-Path $Path\$_
          }
        if ($return -contains $false) {$false}
        else {$true}
      }
    'set' {
        Expand-Archive -Path $PSScriptRoot\nuget.zip -DestinationPath $Path -Force
      }
  }
}

function pkg {
  param (
    [validateset('test','set')]
    [actions]$Action,
    [string]$path
  )
  switch ($Action) {
    'test' {
      Test-Path -Path $path
    }
    'set' {
      $null = New-Item -Path $path -ItemType Directory -Force 
    }
  }
}

function webconf {
  param (
    [validateset('test','set')]
    [actions]$Action,
    [string]$Path =  "$env:SystemDrive\inetpub\wwwroot\Web.config",
    [string]$Conf
  )
  switch ($Action) {
    'test' {
      $temp = $Path + ".tmp"
      $Conf | Set-Content -Path $temp
      $control = Get-Content $temp -Raw
      Remove-Item -Path $temp -Force
      if (Compare-Object -ReferenceObject $control -DifferenceObject (Get-Content $Path -Raw))
        {
          $false
        }
      else {$true}
    }
    'set' {
      $Conf | Set-Content -Path $Path
    }
  }
}

function webconfvar {
  param (
    [bool]$AllowNugetPackagePush,
    [bool]$AllowPackageOverwrite,
    [string]$PackageSource,
    [string]$APIKey
  )
  $ExecutionContext.InvokeCommand.ExpandString($webconf)
}

function provider {
  param (
    [validateset('test','set')]
    [actions]$Action,
    [string]$Name,
    [string]$PublisherURI,
    [string]$SourceURI,
    [string]$Type,
    [string]$Ensure
  )
  switch ($Action) {
    'test' {
      Write-Verbose "Checking for provider: $Name"
      if (Get-PSRepository -Name $Name -ErrorAction SilentlyContinue)
      {
        $return = $true
      }
      else {$return = $false}
      switch ($Ensure) {
        Present {
          return $return
        }
        Absent {
          return (! $return)
        }
      }
    }
    'set' {
      switch ($Ensure) {
        Present {
          $null = Register-PackageSource -Name $Name -Location $SourceURI -ProviderName PowerShellGet -Force -ForceBootstrap -WarningAction Ignore -ErrorAction Ignore
          $null = Set-PSRepository -Name $Name -SourceLocation $SourceURI -PublishLocation $PublisherURI -InstallationPolicy $Type
        }
        Absent {
          $null = Unregister-PackageSource -Name $Name -Force
        }
      }
      
    }
  }
}

function package_provider {
  param (
    [validateset('test','set')]
    [actions]$Action,
    [string]$Name,
    [string]$SourceURI,
    [string]$ProviderName,
    [string]$Ensure
  )
  switch ($Action) {
    'test' {
      Write-Verbose "Checking for provider: $Name"
      if (Get-PackageSource -Name $Name -ErrorAction SilentlyContinue)
      {
        $return = $true
      }
      else {$return = $false}
      switch ($Ensure) {
        Present {
          return $return
        }
        Absent {
          return (! $return)
        }
      }
      
    }
    'set' {
      $Null = Find-PackageProvider -Name Nuget -ForceBootstrap -Force
      switch ($Ensure) {
        Present {
          $null = Register-PackageSource -Name $Name -Location $SourceURI -ProviderName $ProviderName -Force -ForceBootstrap -Trusted
        }
        Absent {
          $null = Unregister-PackageSource -Name $Name -Force
        }
      }
    }
  }
}


$webconf = @'
<?xml version="1.0" encoding="utf-8"?>
<!--
  For more information on how to configure your ASP.NET application, please visit
  http://go.microsoft.com/fwlink/?LinkId=169433
  -->
<configuration>
  <configSections>
    <sectionGroup name="elmah">
      <section name="security" requirePermission="false" type="Elmah.SecuritySectionHandler, Elmah"/>
      <section name="errorLog" requirePermission="false" type="Elmah.ErrorLogSectionHandler, Elmah"/>
      <section name="errorMail" requirePermission="false" type="Elmah.ErrorMailSectionHandler, Elmah"/>
      <section name="errorFilter" requirePermission="false" type="Elmah.ErrorFilterSectionHandler, Elmah"/>
    </sectionGroup>
  </configSections>
  <system.web>
    <compilation debug="true" targetFramework="4.5"/>
    <httpRuntime targetFramework="4.5" maxRequestLength="31457280"/>
  <httpModules>
      <add name="ErrorLog" type="Elmah.ErrorLogModule, Elmah"/>
      <add name="ErrorMail" type="Elmah.ErrorMailModule, Elmah"/>
      <add name="ErrorFilter" type="Elmah.ErrorFilterModule, Elmah"/>
    </httpModules></system.web>
<system.webServer>
    <validation validateIntegratedModeConfiguration="false"/>
    <modules runAllManagedModulesForAllRequests="true">
      <add name="ErrorLog" type="Elmah.ErrorLogModule, Elmah" preCondition="managedHandler"/>
      <add name="ErrorMail" type="Elmah.ErrorMailModule, Elmah" preCondition="managedHandler"/>
      <add name="ErrorFilter" type="Elmah.ErrorFilterModule, Elmah" preCondition="managedHandler"/>
    </modules>
  <staticContent>
      <mimeMap fileExtension=".nupkg" mimeType="application/zip"/>
    </staticContent></system.webServer><elmah>
    <!--
        See http://code.google.com/p/elmah/wiki/SecuringErrorLogPages for 
        more information on remote access and securing ELMAH.
    -->
    <security allowRemoteAccess="false"/>
  <errorLog type="Elmah.XmlFileErrorLog, Elmah" logPath="~/App_Data"/></elmah><location path="elmah.axd" inheritInChildApplications="false">
    <system.web>
      <httpHandlers>
        <add verb="POST,GET,HEAD" path="elmah.axd" type="Elmah.ErrorLogPageFactory, Elmah"/>
      </httpHandlers>
      <!-- 
        See http://code.google.com/p/elmah/wiki/SecuringErrorLogPages for 
        more information on using ASP.NET authorization securing ELMAH.

      <authorization>
        <allow roles="admin" />
        <deny users="*" />  
      </authorization>
      -->  
    </system.web>
    <system.webServer>
      <handlers>
        <add name="ELMAH" verb="POST,GET,HEAD" path="elmah.axd" type="Elmah.ErrorLogPageFactory, Elmah" preCondition="integratedMode"/>
      </handlers>
    </system.webServer>
  </location><appSettings>
    <!--
            Determines if an Api Key is required to push\delete packages from the server. 
    -->
    <add key="requireApiKey" value="$AllowNugetPackagePush"/>
    <!-- 
            Set the value here to allow people to push/delete packages from the server.
            NOTE: This is a shared key (password) for all users.
    -->
    <add key="apiKey" value="$APIKey"/>
    <!--
            Change the path to the packages folder. Default is ~/Packages.
            This can be a virtual or physical path.
        -->
    <add key="packagesPath" value="$PackageSource"/>
    <!--
            Set allowOverrideExistingPackageOnPush to false if attempts to upload a package that already exists
            (same id and same version) should fail.
    -->
    <add key="allowOverrideExistingPackageOnPush" value="$AllowPackageOverwrite"/>
    <!--
            Set enableDelisting to true to enable delist instead of delete as a result of a "nuget delete" command.
            - delete: package is deleted from the repository's local filesystem.
            - delist: 
              - "nuget delete": the "hidden" file attribute of the corresponding nupkg on the repository local filesystem is turned on instead of deleting the file.
              - "nuget list" skips delisted packages, i.e. those that have the hidden attribute set on their nupkg.
              - "nuget install packageid -version version" command will succeed for both listed and delisted packages.
                 e.g. delisted packages can still be downloaded by clients that explicitly specify their version.
    -->
    <add key="enableDelisting" value="false"/>
    <!--
      Set enableFrameworkFiltering to true to enable filtering packages by their supported frameworks during search.
    -->
    <add key="enableFrameworkFiltering" value="false"/>
  </appSettings><system.serviceModel>
    <serviceHostingEnvironment aspNetCompatibilityEnabled="true"/>
  </system.serviceModel></configuration>
'@