Import-Module "w:\scr\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile "W:\scr\Config\Settings.psd1"

Add-WindowsDefenderExclusions -DefenderExclusionPaths $Settings.DefenderExclusionPaths