Import-Module "w:\scr\Modules\InstallTools.psm1"

# Add Windows Defender exclusions
Add-WindowsDefenderExclusions

# Enable firewall rules
Enable-FirewallRules

# Apply Edge policies
Set-EdgePolicies -Scope "HKLM"

# Install and configure Aspia Host
Install-AspiaHost -Wait
Update-AspiaHostConfig

# Install 1C Thin Client
Install-ThinClient1C

# Install Chrome, Zoom, FSViewer, etc using winget
winget import 'w:\soft\winget\basic_import.json'
Copy-Item 'w:\soft\_utils\winrar\rarreg.key' -destination 'c:\program files\winrar\'
winget install sumatrapdf.sumatrapdf --accept-source-agreements --override "/install /s -with-preview -all-users"

# Install ESET NOD32 Antivirus
Install-NOD32

# Activate Windows
$ActivationUrl = 'https://get.activated.win'
$ActivationArguments = '/HWID /Ohook' # Permanent Activation of Windows and Office
Invoke-Activation -Url $ActivationUrl -Arguments $ActivationArguments