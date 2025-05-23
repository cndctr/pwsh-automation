
Import-Module "$PSScriptRoot\Modules\BackupTools.psm1" -Force
$Settings = Import-PowerShellDataFile "$PSScriptRoot\Config\BackupSettings.psd1"

# $FileToRestore = Get-ChildItem -Path $Settings.SQLBackupFolder | Sort-Object -Descending | Select-Object -First 1
# try {
#     Restore-SqlDatabase -ServerInstance $Settings.Server1CName `
#                         -Database $Settings.Base1CName + "_test" `
#                         -BackupFile $FileToRestore `
#                         -ReplaceDatabase `
#                         -ErrorAction Stop
#                         # -Credential $SQLCredential
# }
# catch {
#     Write-Error "Restore process failed"
# }

$CurYear = get-date -Format "yy"
$CurQrt = [math]::Ceiling((Get-Date).Month/3)
$DTFile = "83-$CurYear-$CurQrt-МинскСЭЙФТИМ.dt"
# $DTFile = $Settings.Base1CName + "_" + (Get-Date -Format "yyyy-MM-dd_HHmmss") + ".dt"

Export-1CBase -Server1CName $Settings.Server1CName `
                -Base1CName  $Settings.Base1CName `
                -PathTo1C $Settings.PathTo1CExecutable `
                -DTPath $Settings.DTPath `
                -DTFile $DTFile
                -ErrorAction Stop


$FileToUpload = Join-Path -Path $Settings.DTPath -ChildPath $DTFile

if (! (Test-Path $FileToUpload)) {
    throw "Backup file not found: $FileToUpload"
}

# $FTPSConnectionString = Get-Content $Settings.FTPSConnectionString
Invoke-WinSCPUpload -WinSCPPath $Settings.WinSCPCom `
                    -WinSCPLog $Settings.WinSCPLog `
                    -FTPSConnectionString (Get-Content $Settings.FTPSConnectionString) `
                    -FileToUpload $FileToUpload `
                    -FTPPath $Settings.FTPPath    
