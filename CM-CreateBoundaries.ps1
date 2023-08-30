# Site configuration
$SiteCode = "<SITECODE>" # Site code 
$ProviderMachineName = "<PRIMARY SERVER FQDN>" # SMS Provider machine name
$ImportFile = "$PSScriptRoot\NewBoundaries.txt"

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams


$CSV = Import-Csv -Delimiter "`t" -Header Subnet, BDescription, BoundaryGroup -Path $ImportFile

ForEach ($Record in $CSV) {

    $Subnet = $Record.Subnet
    $Description = $Record.BDescription
    $BoundaryGroup = $Record.BoundaryGroup
        
    Write-Host $Subnet
    Write-Host $Description


    

    New-CMBoundary -Type IPSubnet -Value $Subnet -Name $Description

    Write-Host "$Subnet Boundary Created"
   
    Start-Sleep 1

}
