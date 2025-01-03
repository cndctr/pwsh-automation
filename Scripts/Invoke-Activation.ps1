Import-Module "w:\scr\Modules\InstallTools.psm1"
# Variables
$ActivationUrl = 'https://get.activated.win'
$ActivationArguments = '/HWID /Ohook' # Permanent Activation of Windows and Office
# $ActivationArguments = '/K-Office' # Activate only Office with Online KMS
# $ActivationArguments = '/K-WindowsOffice' # Activate all Windows and Office with Online KMS
# $ActivationArguments = '/K-Windows' # Activate only Windows with Online KMS

# Call the function
Invoke-Activation -Url $ActivationUrl -Arguments $ActivationArguments
