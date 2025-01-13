Import-Module "w:\scr\Modules\InstallTools.psm1"

# Uninstalling UWP Apps
Write-Log -Message "Starting to uninstall UWP apps"
Uninstall-UWPApps
Write-Log -Message "Finished uninstalling UWP Apps"