Import-Module "$PSScriptRoot\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile -Path "$PSScriptRoot\Config\Settings.psd1"


# Uninstalling UWP Apps
$UWPApps = $Settings.UWPApps
Write-Log -Message "Starting to uninstall UWP apps"
Uninstall-UWPApps -UWPApps $UWPApps -ErrorAction SilentlyContinue
Write-Log -Message "Finished uninstalling UWP Apps"