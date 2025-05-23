Import-Module "$PSScriptRoot\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile "$PSScriptRoot\Config\Settings.psd1"

# Install Aspia Host
Install-AspiaHost -AspiaPaths $Settings.Aspia
Update-AspiaHostConfig -ConfigSourcePath $Settings.Aspia.ConfigSourcePath -ConfigDestinationPath $Settings.Aspia.ConfigDestinationPath
