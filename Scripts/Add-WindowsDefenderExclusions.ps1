Import-Module "w:\scr\Modules\InstallTools.psm1"

# Add Windows Defender exclusions
Write-Log -Message "Starting process to add Windows Defender exclusions."
Add-WindowsDefenderExclusions
Write-Log -Message "Completed process to add Windows Defender exclusions."