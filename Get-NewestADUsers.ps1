param(
    
    [string]$OUList,
    [int]$NumberOfNewest = 5
)
# $Settings = Import-PowerShellDataFile -Path "W:\scr\Config\ADSettings.psd1"
Import-Module "$PSScriptRoot\Modules\ADTools.psm1" -Force

try {
    Write-host "Getting $NumberOfNewest users" -ForegroundColor Green
    Get-NewestADUsers -OUList $OUList -NumberOfNewest $NumberOfNewest
    Write-Host "Done!" -ForegroundColor Green
}
catch {
    Write-Error "Couldn't get any users"
}