Import-Module W:\scr\Modules\ADTools.psm1
$Settings = Import-PowerShellDataFile -Path "W:\scr\Config\ADSettings.psd1"

try {
    Write-host "Getting $NumberOfNewest users" -ForegroundColor Green
    Get-NewestADUsers -OUList $Settings.MainUsers
    Write-Host "Done!" -ForegroundColor Green
}
catch {
    Write-Error "Couldn't get any users"
}