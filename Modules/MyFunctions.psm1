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
                text      = $SmsText
                alpha_name = $AlphaName
                ttl        = $TTL
            }
        }
    } | ConvertTo-Json

    # Send Request
    try {
        $response = Invoke-WebRequest -Uri $uri -Method POST -Headers $headers -Body $body
        Write-Verbose -Message "SMS sent successfully. Response: $($response.Content)" -Verbose
        return $response.Content
    } catch {
        Write-Error -Message "Failed to send SMS. Error: $_"
    }
}
