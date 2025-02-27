Import-Module "w:\scr\Modules\InstallTools.psm1"
$Settings = Import-PowerShellDataFile "W:\scr\Config\Settings.psd1"

# Add Windows Defender exclusions
Add-WindowsDefenderExclusions -DefenderExclusionPaths $Settings.DefenderExclusionPaths

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

# Set password policy for predefined administrator "adml"
Set-LocalUser -Name adml -PasswordNeverExpires $true

# Apply Edge policies
Set-EdgePolicies -Scope "HKLM"

#Disable Bing Search in Start Menu
Set-BingSearch -Disable

# Install and configure Aspia Host
Install-AspiaHost -AspiaPaths $Settings.Aspia -Wait
Update-AspiaHostConfig -ConfigSourcePath $Settings.Aspia.ConfigSourcePath -ConfigDestinationPath $Settings.Aspia.ConfigDestinationPath

# Install 1C Thin Client
Install-ThinClient1C -ThinClient1C $Settings.ThinClient1C

# Install MS Office
$ImageFile = $Settings.MSOffice.ImageFile
$ConfigFile = $Settings.MSOffice.ConfigFile
$InstallerScript = $Settings.MSOffice.InstallerScript
Install-MSOffice -ImageFile $ImageFile -ConfigFile $ConfigFile -InstallerScript $InstallerScript 

# Install Chrome, Zoom, FSViewer, etc using winget
winget import 'w:\soft\winget\basic_import.json'
winget install sumatrapdf.sumatrapdf --accept-source-agreements --override "/install /s -with-preview -all-users"
Expand-Archive 'W:\soft\_utils\totalcmd_arch\totalcmd.zip' -DestinationPath 'c:\'
Copy-Item 'w:\soft\_utils\totalcmd\Total Commander.lnk' -Destination C:\Users\Public\Desktop
Copy-Item 'w:\soft\_utils\winrar\rarreg.key' -destination 'c:\program files\winrar\'

# Install ESET NOD32 Antivirus
Install-NOD32 -NODInstaller $Settings.NODInstaller

# Activate Windows

W:\soft\ms_windows\mas\MAS_AIO.cmd /Z-WindowsESUOffice
# $ActivationUrl = 'https://get.activated.win'
# $ActivationArguments = '/HWID /Ohook' # Permanent Activation of Windows and Office
# Invoke-Activation -Url $ActivationUrl -Arguments $ActivationArguments