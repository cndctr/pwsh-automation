$BackupSettings = Import-PowerShellDataFile -Path W:\scr\Config\BackupSettings.psd1

function Export-1CBase {

    $Settings = $BackupSettings

    $1CServerName  = $Settings.ServerName
    $1CBaseName    = $Settings.BaseName
    $1CPath        = $Settings.PathTo1C
    $DTPath        = $Settings.DumpPath
    # $Login         = $Settings.Login
    # $Password      = $Settings.Password

    $DTFile        = "$BaseName" + "_" + (Get-Date -Format "yyyy-MM-dd_HHmmss") + ".dt"
    $Arguments     = "CONFIG /S$1CServerName\$1CBaseName /DisableStartupMessages /DumpIB $DTPath\$DTFile"

    # Ensure $DTPath exists
    if (-Not (Test-Path -Path $DTPath)) {
        Write-Host "The path '$DTPath' does not exist. Creating it now..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $DTPath -Force | Out-Null
        Write-Host "The path '$DTPath' has been created." -ForegroundColor Green
    }

    try {
        # Attempt to start the process
        Start-Process -FilePath "$1CPath\1cv8.exe" -ArgumentList $Arguments -ErrorAction Stop
        Write-Host "Process started successfully. The file will be exported to $DTPath\$DTFile" -ForegroundColor Green
    } catch {
        # Handle any errors that occur during process execution
        Write-Error "An error occurred while starting the process: $_"
    }
}

function FunctionName {

    $Settings = $BackupSettings

    $1CServerName   = $Settings.ServerName
    $1CBaseName     = $Settings.BaseName
    $1CBackupFolder = $Settings.BackupFolder


    $FileToRestore      = Get-ChildItem -Path $1CBackupFolder | Sort-Object -Descending | Select-Object -First 1
    
}