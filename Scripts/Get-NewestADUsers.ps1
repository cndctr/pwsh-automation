Import-Module W:\scr\Modules\ADTools.psm1
$Settings = Import-PowerShellDataFile -Path "W:\scr\Config\ADSettings.psd1"

Get-NewestADUsers -OUList $Settings.MainUsers