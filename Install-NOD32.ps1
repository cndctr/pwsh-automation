Import-Module "$PSScriptRoot\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile "$PSScriptRoot\Config\Settings.psd1"

# Install ESET NOD32 Antivirus
Write-Log -Message "Starting the ESET NOD32 installation process."
Install-NOD32 -NODInstaller $Settings.NODInstaller
Write-Log -Message "1C Thin Client installation process completed."