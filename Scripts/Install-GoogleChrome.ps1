Import-Module "w:\scr\Modules\InstallTools.psm1"

# Install Google Chrome
Write-Log -Message "Starting Google Chrome installation process."
Install-GoogleChrome
Write-Log -Message "Google Chrome installation process completed."
