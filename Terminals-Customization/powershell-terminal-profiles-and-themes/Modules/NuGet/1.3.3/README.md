#Nuget DSC Module

The Nuget DSC module exists to provide an easy to use mechanism for creating, using, and consuming Nuget packages on Windows Servers.



## Contributing
Please check out common DSC Resources [contributing guidelines](https://github.com/PowerShell/DscResource.Kit/blob/master/CONTRIBUTING.md).

## Resources

* **Nuget** Creates Nuget Repos 
* **PSRepo** Registers a PowershellGet Repo
* **PackageRepo** Registers a Nuget/Chocolatey Repo
* **Nuget_Module** Manage a particular module
* **Nuget_Package** Manage a particular package

### Nuget

Creates a local nuget repository for hosting modules or packages.

* **PackageSource**: [string] Location on the filesystem where you want packages to be hosted
* **Name**: [string] Name of the Website, typically matches the **PackageSource** directory name
* **Port**: [int] The port you want the website to publish on
* **Protocol**: [string] http or https, defaults to http
* **APIKey**: [string] The API key for publishing packages. If you don't allow package publishing just use a blank string
* **AllowNugetPackagePush**: [Boolean] Set to Allow package uploads
* **AllowPackageOverwrite**: [Boolean] Set to allow packages to overwrite

### PSRepo

Registers a PSGallery type repository

* **Ensure**: [string] Absent or Present
* **Name**: [string] Set the name of the Repository
* **PublishUri**: [string] The package publish address for your module provider
* **SourceUri**: [string] The package Source address for your module provider
* **InstallPolicy**: [string] Trusted or Untrusted

* **Property1**: Description of property 1

### PackageRepo

Registers a Package Repository

* **Ensure**: [string] Absent or Present
* **Name**: [string] Set the name of the Repository
* **SourceUri**: [string] The package Source address for your module provider
* **InstallPolicy**: [string] Trusted or Untrusted
* **ProviderName**: [string] Name of the provider type, valid options are: Nuget, Chocolatey

### Nuget_Module

Manage a Module

* **Ensure**: [string] Absent or Present
* **Name**: [string] The Name of the Module you want to manage
* **Version**: [string] The Module version, this is required, will add support for, and default to 'latest' in a future release
* **ProviderName**: [string] Name of the module provider you want to pull the module from

### Nuget_Package

Manage a Package

* **Ensure**: [string] Absent or Present
* **Name**: [string] The Name of the package you want to manage
* **Version**: [string] The package version, this is required, will add support for, and default to 'latest' in a future release
* **ProviderName**: [string] Name of the package provider you want to pull the package from

## Versions

### 1.3.1

Renamed Repo and resources from cNuget

* Initial release with the following resources:
    * Nuget
    * PSRepo
    * Package_Repo
    * Nuget_Module
    * Nuget_Package

### 1.3.2

Added README

## Examples
