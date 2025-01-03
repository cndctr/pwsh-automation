# Import the InstallTools module
Import-Module -Name "..\Modules\InstallTools.psm1"

# Import settings from the configuration file
$settings = Import-PowerShellDataFile -Path "..\Config\Settings.psd1"
$logFile = $settings.LogFilePath

# Get all enabled AD computers
Import-Module ActiveDirectory
$computers = Get-ADComputer -Filter {Enabled -eq $true} -Property Name | Select-Object -ExpandProperty Name

# Check Zoom version on each computer
foreach ($computer in $computers) {
    Write-Output "Checking Zoom version on $computer..."
    $version = Get-ZoomVersion -ComputerName $computer

    if ($version -eq "Zoom not found") {
        Write-Output "$computer : Zoom not installed"
        Write-Log "$computer : Zoom not installed"
    } else {
        Write-Output "$computer : Zoom version is $version"
        Write-Log "$computer : Zoom version is $version"
    }
}
