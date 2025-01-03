param (
    [Parameter(Mandatory = $true)]
    [string]$ComputerName
)

# Import the InstallTools module
Import-Module -Name "..\Modules\InstallTools.psm1"

# Import settings from the configuration file
$settings = Import-PowerShellDataFile -Path "..\Config\Settings.psd1"
$logFile = $settings.LogFilePath
$zoomInstallerUrl = $settings.ZoomInstallerUrl
$minimumVersion = [version]$settings.MinimumZoomVersion

# Check Zoom version on the specified computer
Write-Output "Checking Zoom version on $ComputerName..."
$version = Get-ZoomVersion -ComputerName $ComputerName

if ($version -eq "Zoom not found") {
    Write-Output "$ComputerName : Zoom not installed"
    Write-Log "$ComputerName : Zoom not installed"
    return
}

$versionObject = [version]$version
if ($versionObject -lt $minimumVersion) {
    Write-Output "$ComputerName : Current Zoom version is $version (Outdated)"
    Write-Log "$ComputerName : Current Zoom version is $version (Outdated)"

    Write-Output "$ComputerName : Upgrading Zoom..."
    Write-Log "$ComputerName : Starting Zoom upgrade..."
    $upgradeResult = Install-ZoomUpdate -ComputerName $ComputerName -ZoomInstallerUrl $zoomInstallerUrl
    Write-Output "$ComputerName : $upgradeResult"
    Write-Log "$ComputerName : $upgradeResult"
} else {
    Write-Output "$ComputerName : Zoom is up-to-date ($version)"
    Write-Log "$ComputerName : Zoom is up-to-date ($version)"
}
