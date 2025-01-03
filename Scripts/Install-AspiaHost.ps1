Import-Module "w:\scr\Modules\InstallTools.psm1"

# Install Aspia Host
Write-Log -Message "Starting the Aspia Host installation process."
Install-AspiaHost -Wait
Update-AspiaHostConfig
Write-Log -Message "Aspia Host installation process completed."
