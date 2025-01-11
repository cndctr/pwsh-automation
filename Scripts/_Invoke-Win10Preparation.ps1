Import-Module "w:\scr\Modules\InstallTools.psm1"

# Add Windows Defender exclusions
Add-WindowsDefenderExclusions

# Enable firewall rules
Enable-FirewallRules

# Set tweaks
# Start menu layout
Write-Verbose -Message 'Importing Start menu and taskbar layout' -Verbose
Import-StartLayout -LayoutPath 'w:\soft\ms_windows\LayoutModification.xml' -MountPath c:\
Write-Verbose -Message 'OK' -Verbose

# Enabling WinRM 
Write-Verbose -Message 'Enabling  Windows remote management service' -Verbose
winrm quickconfig -quiet
Write-Verbose -Message 'OK' -Verbose

# Powerconfigurations
Write-Verbose -Message 'Setting monitor and standby timeouts' -Verbose
powercfg /x monitor-timeout-ac 60
powercfg /x standby-timeout-ac 0
Write-Verbose -Message 'OK' -Verbose

# Перезапустить explorer
Stop-Process -ProcessName Explorer


# Apply Edge policies
Set-EdgePolicies -Scope "HKLM"

# Install and configure Aspia Host
Install-AspiaHost -Wait
Update-AspiaHostConfig

# Install 1C Thin Client
Install-ThinClient1C

# Install MS Office
Install-MSOffice

# Install Chrome, Zoom, FSViewer, etc using winget
winget import 'w:\soft\winget\basic_import.json'
winget install sumatrapdf.sumatrapdf --accept-source-agreements --override "/install /s -with-preview -all-users"
Expand-Archive 'W:\soft\_utils\totalcmd_arch\totalcmd.zip' -DestinationPath 'c:\'
Copy-Item 'w:\soft\_utils\totalcmd\Total Commander.lnk' -Destination C:\Users\Public\Desktop
Copy-Item 'w:\soft\_utils\winrar\rarreg.key' -destination 'c:\program files\winrar\'

# Install ESET NOD32 Antivirus
Install-NOD32

# Activate Windows
$ActivationUrl = 'https://get.activated.win'
$ActivationArguments = '/HWID /Ohook' # Permanent Activation of Windows and Office
Invoke-Activation -Url $ActivationUrl -Arguments $ActivationArguments