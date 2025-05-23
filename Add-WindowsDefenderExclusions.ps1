Import-Module "$PSScriptRoot\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile "$PSScriptRoot\Config\Settings.psd1"

Add-WindowsDefenderExclusions -DefenderExclusionPaths $Settings.DefenderExclusionPaths