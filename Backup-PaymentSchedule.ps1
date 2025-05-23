<#
    This script creates backup of shared folder database.
#>

$SourceDir = "d:\share\Files\!OFFICE\Платёжный календарь\*"
$DestinationFile = "d:\share\backup_files\payment_schedule_$(Get-Date -f yyyy-MM-dd_HHmmss).zip"
$DestinationDir = "d:\share\backup_files"

Compress-Archive -Path $SourceDir -DestinationPath $DestinationFile

# Remove unnecessary zips, leave only 10 newest by date
Get-ChildItem -Path $DestinationDir | Where-Object Name -Like payment* | Sort-Object CreationTime -Descending | Select-Object -Skip 10 | ForEach-Object {Remove-Item $_.FullName}