$OneDrive = Get-Package -Name "Microsoft OneDrive" -ProviderName Programs -Force -ErrorAction Ignore
if (-not $OneDrive)
{
    if (Test-Path -Path $env:SystemRoot\SysWOW64\OneDriveSetup.exe)
    {
        Write-Information -MessageData "" -InformationAction Continue
        Write-Verbose "OneDrive installing" -Verbose

        Start-Process -FilePath $env:SystemRoot\SysWOW64\OneDriveSetup.exe
    }
    else
    {
        try
        {
            # Check the internet connection
            $Parameters = @{
                Uri              = "https://www.google.com"
                Method           = "Head"
                DisableKeepAlive = $true
                UseBasicParsing  = $true
            }
            if (-not (Invoke-WebRequest @Parameters).StatusDescription)
            {
                return
            }

            # Downloading the latest OneDrive installer 64-bit
            Write-Information -MessageData "" -InformationAction Continue
            Write-Verbose -Message $Localization.OneDriveDownloading -Verbose

            # Parse XML to get the URL
            # https://go.microsoft.com/fwlink/p/?LinkID=844652
            $Parameters = @{
                Uri             = "https://g.live.com/1rewlive5skydrive/OneDriveProductionV2"
                UseBasicParsing = $true
                Verbose         = $true
            }
            $Content = Invoke-RestMethod @Parameters

            # Remove invalid chars
            [xml]$OneDriveXML = $Content -replace "ï»¿", ""

            $OneDriveURL = ($OneDriveXML).root.update.amd64binary.url
            $DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
            $Parameters = @{
                Uri             = $OneDriveURL
                OutFile         = "$DownloadsFolder\OneDriveSetup.exe"
                UseBasicParsing = $true
                Verbose         = $true
            }
            Invoke-WebRequest @Parameters

            Start-Process -FilePath "$DownloadsFolder\OneDriveSetup.exe" -Wait

            Remove-Item -Path "$DownloadsFolder\OneDriveSetup.exe" -Force
        }
        catch [System.Net.WebException]
        {
            Write-Warning -Message $Localization.NoInternetConnection
            Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

            Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line) -ErrorAction SilentlyContinue
        }
    }

    # Save screenshots by pressing Win+PrtScr in the Pictures folder
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{B7BEDE81-DF94-4682-A7D8-57A52620B86F}" -Force -ErrorAction Ignore

    Get-ScheduledTask -TaskName "Onedrive* Update*" | Enable-ScheduledTask
    Get-ScheduledTask -TaskName "Onedrive* Update*" | Start-ScheduledTask
}