# $BackupSettings = Import-PowerShellDataFile -Path W:\scr\Config\BackupSettings.psd1

function Export-1CBase {
    [CmdletBinding()]
    param (
        [string]$Server1CName,
        [string]$Base1CName,
        [string]$PathTo1C,
        [string]$DTPath,
        [string]$DTFile
    )
    <#
    .DESCRIPTION
    This function starts 1C Enterprise in designer mode and exports database
    to .dt file on disk
    #>

    # $DTFile        = "$Base1CName" + "_" + (Get-Date -Format "yyyy-MM-dd") + ".dt"
    $Arguments     = "CONFIG /S$Server1CName\$Base1CName /DisableStartupMessages /DumpIB $DTPath\$DTFile"

    # Ensure $DTPath exists
    if (-Not (Test-Path -Path $DTPath)) {
        Write-Host "The path '$DTPath' does not exist. Creating it now..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $DTPath -Force | Out-Null
        Write-Host "The path '$DTPath' has been created." -ForegroundColor Green
    }

    Write-Host "Process started. The file is exporting to $DTPath\$DTFile" -ForegroundColor Green
    $Process = Start-Process -FilePath "$PathTo1C\1cv8.exe" -ArgumentList $Arguments -ErrorAction Stop -Wait -PassThru
    
    $ExportResult = $Process.ExitCode
    if ($ExportResult -eq 0) {
        Write-Output "Export successful"
        return $Process.ExitCode
    } else {
        Write-Output "Export failed with exit code: $ExportResult"
        return $Process.ExitCode
    }

}

function Invoke-WinSCPUpload {
    param (
        [string]$WinSCPPath,
        [string]$WinSCPLog,
        [string]$FTPSConnectionString,
        [string]$FileToUpload,
        [string]$FTPPath
    )

    # Ensure output encoding is UTF-8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    # Define the commands
    $PutCommand = "put $FileToUpload $FTPPath"

    # Construct arguments for WinSCP
    $arguments = @(
        "/log=`"$WinSCPLog`"", 
        "/ini=nul", 
        "/command", 
        "`"open $FTPSConnectionString`"", 
        "`"$PutCommand`"", 
        "exit"
    )

    # Start the WinSCP process
    Write-Host "Process started. The file is uploading to FTP" -ForegroundColor Green
    $Process = Start-Process -FilePath $WinSCPPath -ArgumentList $arguments -NoNewWindow -Wait -PassThru

    # Return the result
    $WinSCPResult = $Process.ExitCode
    if ($WinSCPResult -eq 0) {
        Write-Output "Upload successful." 
    } else {
        Write-Output "Upload failed with exit code: $WinSCPResult"
    }

}


