class site {
  #Properties
  [string]$Name
  [int]$Port
  [string]$Path
  #Constructors
  site () {}
  
  site ([string]$name,[int]$port,[string]$path) {
    $this.Name = $name
    $this.Port = $port
    $this.Path = $path
  }
}
$sites = [site]::new('modules',81,'c:\Modules'),[site]::new('packages',82,'c:\packages')

describe "Testing the default configuration of NuGet" {
    context "Nuget website | napmSources | W3SVC" {
        
        it "ensures IIS installed" {
            (get-windowsfeature -name web-server).installed | should be $true
        }
        foreach ($site in $sites) {
          it "checks for Modules website" {
            get-website -name $site.Name | should not be $null
          }
          it "ensures $($site.path) directory exists" {
            test-path $site.Path -type container | should be true
          }
          it "tests for contents" {
            (invoke-webrequest -uri "http://localhost:$($site.Port)" -usebasicparsing).StatusCode | should be 200
          }
        }
        
        it "ensures w3svc is running" {
            (get-service -name w3svc).status | should match 'running'
        }
    }
}
