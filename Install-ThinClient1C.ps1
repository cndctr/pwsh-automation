Import-Module "$PSScriptRoot\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile "$PSScriptRoot\Config\Settings.psd1"

# Install 1C Thin Client
Write-Log -Message "Starting the 1C Thin Client installation process."
Install-ThinClient1C -ThinClient1C $Settings.ThinClient1C
Write-Log -Message "1C Thin Client installation process completed."
