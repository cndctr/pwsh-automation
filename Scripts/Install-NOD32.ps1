Import-Module "w:\scr\Modules\InstallTools.psm1"

# Install ESET NOD32 Antivirus
Write-Log -Message "Starting the ESET NOD32 installation process."
Install-NOD32
Write-Log -Message "1C Thin Client installation process completed."