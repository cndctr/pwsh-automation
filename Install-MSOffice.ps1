Import-Module "$PSScriptRoot\Modules\InstallTools.psm1" -Force
$Settings = Import-PowerShellDataFile "$PSScriptRoot\Config\Settings.psd1"

$ImageFile = $Settings.MSOffice.ImageFile
$ConfigFile = $Settings.MSOffice.ConfigFile
$InstallerScript = $Settings.MSOffice.InstallerScript

# Install MS Office
Write-Log -Message "Starting the MS Office installation process."
Install-MSOffice -ImageFile $ImageFile -ConfigFile $ConfigFile -InstallerScript $InstallerScript 
Write-Log -Message "MS Office installation process completed."