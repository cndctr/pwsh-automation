Import-Module "w:\scr\Modules\InstallTools.psm1"

# Install MS Office
Write-Log -Message "Starting the MS Office installation process."
Install-MSOffice
Write-Log -Message "MS Office installation process completed."