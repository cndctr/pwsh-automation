Import-Module "w:\scr\Modules\InstallTools.psm1"

# Install 1C Thin Client
Write-Log -Message "Starting the 1C Thin Client installation process."
Install-ThinClient1C
Write-Log -Message "1C Thin Client installation process completed."
