Import-Module "w:\scr\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile -Path "W:\scr\Config\Settings.psd1"


# Uninstalling UWP Apps
$UWPApps = $Settings.UWPApps
Write-Log -Message "Starting to uninstall UWP apps"
Uninstall-UWPApps -UWPApps $UWPApps -ErrorAction Stop
Write-Log -Message "Finished uninstalling UWP Apps"