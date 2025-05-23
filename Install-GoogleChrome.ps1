Import-Module "$PSScriptRoot\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile "$PSScriptRoot\Config\Settings.psd1"
$ChromeInstallerUrl = $Settings.ChromeInstallerUrl

# Install Google Chrome
Write-Log -Message "Starting Google Chrome installation process."
Start-Process msiexec -ArgumentList "/i `"$ChromeInstallerUrl`" /passive" -Wait
Write-Log -Message "Google Chrome installation process completed."
