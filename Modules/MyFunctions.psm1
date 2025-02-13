function Send-SMS {
    <#
    .SYNOPSIS
    Sends an SMS using the MTS Communicator API.

    .DESCRIPTION
    This function sends an SMS message via the MTS Communicator API by using a provided phone number, message text, and authorization token.

    .PARAMETER PhoneNumber
    The recipient's phone number.

    .PARAMETER SmsText
    The text of the SMS message.

    .PARAMETER AlphaName
    The sender's alpha name displayed to the recipient (default: SAFETEAM).

    .PARAMETER TTL
    Time-to-live for the SMS in seconds (default: 600).

    .EXAMPLE
    PS> Send-SMS -PhoneNumber "375291234567" -SmsText "Test message"

    Sends a test SMS message to the specified phone number using the MTS_TOKEN environment variable.

    .NOTES
    Ensure the MTS_TOKEN environment variable is set and contains a valid token.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$PhoneNumber,

        [Parameter(Mandatory)]
        [string]$SmsText,

        [Parameter()]
        [string]$AlphaName = "SAFETEAM",

        [Parameter()]
        [int]$TTL = 600
    )

    # Retrieve token from environment variable
    $Token = $Env:MTS_TOKEN
    if (-not $Token) {
        Write-Error -Message "The environment variable 'MTS_TOKEN' is not set. Please define it before using this function." -ErrorAction Stop
    }

    # API URI
    $uri = 'https://api.communicator.mts.by/1719/json2/simple'

    # Headers
    $headers = @{
        "Content-Type"  = "application/json"
        "Authorization" = "Basic $Token"
    }

    # Body
    $body = @{
        phone_number    = $PhoneNumber
        extra_id        = "dfswkjhdfsdfs"
        tag             = "TEST Campaign"
        channels        = @("sms")
        channel_options = @{
            sms = @{
                text       = $SmsText
                alpha_name = $AlphaName
                ttl        = $TTL
            }
        }
    } | ConvertTo-Json -Depth 10

    # Send Request
    try {
        $response = Invoke-WebRequest -Uri $uri -Method POST -Headers $headers -Body $body
        Write-Verbose -Message "SMS sent successfully. Response: $($response.Content)" -Verbose
        return $response.Content
    }
    catch {
        Write-Error -Message "Failed to send SMS. Error: $_"
    }
}


function Get-InstalledSoftware {
    Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ |
    Get-ItemProperty | Select-Object DisplayName, UninstallString
}

function Export-PhonebookToCSV {
    param (
        [string]$PhonebookUri="http://10.41.41.3/tftpboot/phonebook/yealink.php",
        
        [Parameter(Mandatory)]
        [string]$OutputPath
    )
    
    [xml]$res = (Invoke-WebRequest $PhonebookUri).Content
    $res.YealinkIPPhoneBook.Menu.Unit | Export-Csv $OutputPath"\phonebook.csv" -Delimiter ";" -Encoding 1251
}

function Clear-1CCache {
    <#
    .SYNOPSIS
    Clears 1C cache folders with GUID names based on scope and level.
    
    .DESCRIPTION
    This function processes 1C cache folders under `AppData` and/or `LocalAppData` directories, based on the specified parameters.
    
    .PARAMETER Scope
    Specifies the user scope for the operation. Allowed values:
    - `CurrentUser`: Processes the current user's AppData paths.
    - `AllUsers`: Processes AppData paths for all users.
    
    .PARAMETER Level
    Determines which paths to process. Allowed values:
    - `Full`: Processes both AppData and LocalAppData.
    - `Local`: Processes only LocalAppData.
    
    .PARAMETER Force
    If specified, the function performs deletions. Otherwise, it runs in dry-run mode.
    
    .EXAMPLE
    Clear-1CCache -Scope CurrentUser -Level Full -Force
    
    .EXAMPLE
    Clear-1CCache -Scope AllUsers -Level Local
    #>
    param (
        [ValidateSet("CurrentUser", "AllUsers")]
        [Parameter(Mandatory = $true)]
        [string]$Scope,

        [ValidateSet("Full", "Local")]
        [Parameter(Mandatory = $true)]
        [string]$Level,

        [switch]$Force
    )

    # Determine paths based on scope and level
    $Paths = @()
    if ($Scope -eq "CurrentUser") {
        if ($Level -eq "Full") {
            $Paths += "$env:APPDATA\1C\1cv8\*", "$env:LOCALAPPDATA\1C\1cv8\*"
        } elseif ($Level -eq "Local") {
            $Paths += "$env:LOCALAPPDATA\1C\1cv8\*"
        }
    } elseif ($Scope -eq "AllUsers") {
        if ($Level -eq "Full") {
            $Paths += "C:\Users\*\AppData\Roaming\1C\1cv8\*", "C:\Users\*\AppData\Local\1C\1cv8\*"
        } elseif ($Level -eq "Local") {
            $Paths += "C:\Users\*\AppData\Local\1C\1cv8\*"
        }
    }

    # Dry-run or deletion mode
    if ($Force) {
        Write-Host "Running in deletion mode..." -ForegroundColor Red
    } else {
        Write-Host "Running in dry-run mode. No folders will be deleted." -ForegroundColor Yellow
    }

    # Process each path
    foreach ($path in $Paths) {
        Write-Host "Processing path: $path" -ForegroundColor Cyan
        Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue | Where-Object {
            $_.Name -as [guid]
        } | ForEach-Object {
            if ($Force) {
                Write-Host "Removing folder: $($_.FullName)" -ForegroundColor Yellow
                Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
            } else {
                Write-Host "Found folder: $($_.FullName)" -ForegroundColor Green
            }
        }
    }
}

# Export the function to make it available when the module is imported
Export-ModuleMember -Function Clear-1CCache