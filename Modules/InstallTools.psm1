$Settings = Import-PowerShellDataFile -Path "W:\scr\Config\Settings.psd1"
$ScriptRoot = $Settings.ScriptRoot

function Write-Log {
    param (
        [string] $Message,
        [ValidateSet('Info', 'Warning', 'Error')]
        [string] $Level = 'Info'
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    $LogFile = "$ScriptRoot\Logs\ExecutionLog.txt"

    try {
        Add-Content -Path $LogFile -Value $LogMessage
    }
    catch {
        Write-Error -Message "Failed to write to log file : $LogFile"
    }
}

function Add-WindowsDefenderExclusions {

    $DefenderExclusionPaths = $Settings.DefenderExclusionPaths

    Write-Verbose -Message "Adding Windows Defender exclusions for paths : $($DefenderExclusionPaths -join ', ')" -Verbose
    Write-Log -Message "Starting to add Windows Defender exclusions."

    foreach ($Path in $DefenderExclusionPaths) {
        try {
            Add-MpPreference -ExclusionPath $Path
            Write-Log -Message "Successfully added exclusion for : $Path"
        }
        catch {
            $ErrorMessage = "Failed to add exclusion for : $Path. Error : $_"
            Write-Log -Message $ErrorMessage -Level Error
            Write-Error -Message $ErrorMessage
        }
    }
    
    Write-Log -Message "Completed adding Windows Defender exclusions."
    Write-Verbose -Message "Windows Defender exclusions added successfully." -Verbose
}


function Install-AspiaHost {
    param (
        [string] $AspiaInstaller
    )

    $Is64Bit = [System.Environment]::Is64BitOperatingSystem
    $AspiaInstaller = if ($Is64Bit) { 
        Write-Verbose -Message "64-bit OS detected. Installing x64 aspia-host." -Verbose
        $Settings.Aspia.X64InstallerPath 
    }
    else {
        Write-Verbose -Message "32-bit OS detected. Installing x86 aspia-host." -Verbose
        $Settings.Aspia.X86InstallerPath
    }

    if (Test-Path -Path $AspiaInstaller) {
        Write-Log -Message "Starting Aspia host installation from : $AspiaInstaller"
        Start-Process msiexec -ArgumentList "/i `"$AspiaInstaller`" DESKTOP_SHORTCUT="""" /quiet" -Wait
        Write-Log -Message "Aspia host installation completed successfully for : $AspiaInstaller"
    }
    else {
        $ErrorMessage = "Installer not found at : $AspiaInstaller"
        Write-Log -Message $ErrorMessage -Level Error
        Write-Error -Message $ErrorMessage
    }
}


function Update-AspiaHostConfig {
    param (
        [string] $ConfigSourcePath,
        [string] $ConfigDestinationPath
    )
    $AspiaSettings = $Settings.Aspia
    $ConfigSourcePath = $AspiaSettings.ConfigSourcePath
    $ConfigDestinationPath = $AspiaSettings.ConfigDestinationPath

    Write-Verbose -Message "Configuring Aspia host with settings from : $ConfigSourcePath" -Verbose

    if (Test-Path -Path $ConfigSourcePath) {
        Stop-Service -Name 'aspia-host-service'
        Copy-Item -Path $ConfigSourcePath -Destination $ConfigDestinationPath -Force
        Start-Service -Name 'aspia-host-service'
        Write-Log -Message "Aspia host configuration updated successfully from : $ConfigSourcePath"
    }
    else {
        $ErrorMessage = "Configuration file not found at : $ConfigSourcePath"
        Write-Log -Message $ErrorMessage -Level Error
        Write-Error -Message $ErrorMessage
    }
}

function Install-GoogleChrome {
    param (
        [string] $ChromeInstaller
    )
    
    # Variables
    $ChromeInstallerUrl = $Settings.ChromeInstallerUrl
    
    Write-Verbose -Message "Installing Google Chrome" -Verbose
    Write-Log -Message "Starting Google Chrome installation"
    
    Start-Process msiexec -ArgumentList "/i `"$ChromeInstallerUrl`" /passive" -Wait
    Write-Log -Message "Installation of Google Chrome completed successfully"
    Write-Verbose -Message 'Installation completed successfully.' -Verbose

}

function Install-ThinClient1C {
    param (
        [string] $ThinClient1C
    )
    
    # Variables
    $ThinClient1C = $Settings.ThinClient1C
    
    Write-Verbose -Message "Installing software from : $ThinClient1C" -Verbose
    Write-Log -Message "Starting installation from : $ThinClient1C"
    
    if (Test-Path -Path $ThinClient1C) {
        # Include the installer in the msiexec argument list
        Start-Process msiexec -ArgumentList "/i `"$ThinClient1C`" /passive" -Wait
        Write-Log -Message "Installation completed successfully for : $ThinClient1C"
        Write-Verbose -Message 'Installation completed successfully.' -Verbose
    }
    else {
        $ErrorMessage = "Installer not found at : $ThinClient1C"
        Write-Log -Message $ErrorMessage -Level Error
        Write-Error -Message $ErrorMessage
    }
}

function Install-NOD32 {
    param (
        [string] $NOD32
    )
        
    # Variables
    $NOD32 = $Settings.NOD32
        
    Write-Verbose -Message "Installing software from : $NOD32" -Verbose
    Write-Log -Message "Starting installation from : $NOD32"
        
    if (Test-Path -Path $NOD32) {
        # Include the installer in the msiexec argument list
        Start-Process msiexec -ArgumentList "/i `"$NOD32`" /passive" -Wait
        Write-Log -Message "Installation completed successfully for : $NOD32"
        Write-Verbose -Message 'Installation completed successfully.' -Verbose
    }
    else {
        $ErrorMessage = "Installer not found at : $NOD32"
        Write-Log -Message $ErrorMessage -Level Error
        Write-Error -Message $ErrorMessage
    }
}

function Install-MSOffice {

    $ImageFile = $Settings.MSOffice.ImageFile
    $ConfigFile = $Settings.MSOffice.ConfigFile
    $InstallerScript = $Settings.MSOffice.InstallerScript
    $DriveLetter = "O:"

    try {
        Write-Verbose -Message "Installing Office 2016 from $ImageFile" -Verbose

        # Mount the disk image
        $diskImg = Mount-DiskImage -ImagePath $ImageFile -NoDriveLetter
        $volInfo = $diskImg | Get-Volume
        mountvol $DriveLetter $volInfo.UniqueId

        # Copy installation configuration and script
        Copy-Item -Path $ConfigFile -Destination "$env:TEMP\C2R_Config.ini" -Force
        Copy-Item -Path $InstallerScript -Destination "$env:TEMP\installer.cmd" -Force

        # Start the installer
        Start-Process -FilePath "$env:TEMP\installer.cmd" -Wait

        # Unmount the disk image
        Dismount-DiskImage -ImagePath $ImageFile

        Write-Verbose -Message "Office 2016 installation completed successfully." -Verbose
    }
    catch {
        Write-Error -Message "Failed to install Office 2016. Error: $_"
    }
}




function Get-ZoomVersion {
    <#
	.SYNOPSIS
    Retrieves the installed Zoom version on a remote computer.
    
	.DESCRIPTION
    This function checks if the target computer is reachable within 3 seconds.
		If reachable, it queries the Zoom executable file to retrieve the installed version.
		If the Zoom executable is not found or the computer is unreachable, it returns an appropriate message.
        
        .PARAMETER ComputerName
		The name of the remote computer to check.
        
	.EXAMPLE
    Get-ZoomVersion -ComputerName "PC1"
		Retrieves the Zoom version installed on the computer named "PC1".
        
        .NOTES
		Ensure that the user running this function has the necessary permissions to access the target computer and its file system.
	#>
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Specify the name of the target computer.")]
        [string]$ComputerName
    )
        
    # Check if the computer is reachable
    if (-not (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet -TimeoutSeconds 3)) {
        return "Computer not reachable"
    }

    # Define the Zoom executable path
    $zoomPath = "C$\Program Files\Zoom\bin\Zoom.exe"
    
    # Try to retrieve the Zoom version
    try {
        $zoomFile = Get-Item "\\$ComputerName\$zoomPath" -ErrorAction Stop
        $Version = $zoomFile.VersionInfo.ProductVersion -replace ",", "."
        return $Version
    }
    catch {
        return "Zoom not found"
    }
}


function Install-ZoomUpdate {
    <#
	.SYNOPSIS
	Upgrades Zoom on a remote computer if it is not up-to-date.
    
	.PARAMETER ComputerName
	The name of the remote computer.
    
	.PARAMETER ZoomInstallerUrl
	The URL to the latest Zoom installer.
    
	.EXAMPLE
	Install-ZoomZoomUpdate -ComputerName "PC1" -ZoomInstallerUrl "https://zoom.us/client/latest/ZoomInstaller.exe"
    
	.NOTES
	Author: Your Name
	#>
    param (
        [string]$ComputerName,
        [string]$ZoomInstallerUrl
    )
        
    $tempPath = "\\$ComputerName\C$\Temp"
    $installerPath = "$tempPath\ZoomInstaller.exe"
    
    try {
        # Ensure the Temp directory exists
        if (!(Test-Path $tempPath)) {
            New-Item -ItemType Directory -Path $tempPath -Force
        }
        
        # Download the installer
        Invoke-WebRequest -Uri $ZoomInstallerUrl -OutFile $installerPath
        
        # Execute the installer remotely
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            Start-Process -FilePath "C:\Temp\ZoomInstaller.exe" -ArgumentList "/silent /install" -Wait
        }
        
        return "Upgrade successful"
    }
    catch {
        return "Failed to upgrade: $_"
    }
}

function Invoke-Activation {
    param (
        [string] $Url = 'https://get.activated.win',
        [ValidateSet('/HWID /Ohook', '/K-Office', '/K-WindowsOffice', '/K-Windows')]
        [string] $Arguments = '/HWID /Ohook'
    )

    Write-Verbose -Message "Starting remote activation from URL : $Url with arguments : $Arguments" -Verbose
    Write-Log -Message "Initiating remote activation process from : $Url"

    try {
        & ([ScriptBlock]::Create((Invoke-RestMethod -Uri $Url))) $Arguments
        Write-Log -Message "Successfully completed remote activation from : $Url"
        Write-Verbose -Message "Successfully completed remote activation"
    }
    catch {
        $ErrorMessage = "Failed to complete remote activation from : $Url. Error : $_"
        Write-Log -Message $ErrorMessage -Level Error
        Write-Error -Message $ErrorMessage
    }
}

function Set-EdgePolicies {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("HKCU", "HKLM")]
        [string]$Scope,

        [hashtable]$Policies = @{
            # Default policies
            HideFirstRunExperience                        = 1
            AutoImportAtFirstRun                          = 4
            SyncDisabled                                  = 1
            BrowserSignin                                 = 0
            NewTabPageContentEnabled                      = 0
            NewTabPageQuickLinksEnabled                   = 0
            NewTabPageHideDefaultTopSites                 = 1
            NewTabPageAllowedBackgroundTypes              = 3
            HubsSidebarEnabled                            = 0
            PersonalizationReportingEnabled               = 0
            SearchSuggestEnabled                          = 0
            SpotlightExperiencesAndRecommendationsEnabled = 0
            ShowRecommendationsEnabled                    = 0
            VisualSearchEnabled                           = 0
            QuickSearchShowMiniMenu                       = 0
        }
    )

    Write-Verbose -Message "Setting Edge policies for scope : $Scope" -Verbose
    Write-Log -Message "Applying Edge policies for scope : $Scope"

    try {
        # Define policy registry path
        $RegistryPath = "$($Scope):SOFTWARE\Policies\Microsoft\Edge"

        # Ensure the registry path exists
        New-Item -Path $(Split-Path $RegistryPath -Parent) -Name $(Split-Path $RegistryPath -Leaf) -ErrorAction SilentlyContinue | Out-Null

        # Set policies
        foreach ($Policy in $Policies.GetEnumerator()) {
            Write-Verbose -Message "Setting policy : $($Policy.Key) = $($Policy.Value)" -Verbose
            New-ItemProperty -Path $RegistryPath -Name $Policy.Key -Type Dword -Value $Policy.Value -Force | Out-Null
        }

        # Restart Edge processes
        Get-Process msedge -IncludeUserName -ErrorAction SilentlyContinue | Where-Object UserName -match $ENV:USERNAME | Stop-Process

        # Refresh Group Policy
        if ($Scope -eq 'HKCU') {
            Write-Verbose -Message "Refreshing user group policy." -Verbose
            gpupdate /force /target:user | Out-Null
        }
        else {
            Write-Verbose -Message "Refreshing computer group policy." -Verbose
            gpupdate /force /target:computer | Out-Null
        }

        Write-Log -Message "Edge policies applied successfully for scope : $Scope"
    }
    catch {
        $ErrorMessage = "Failed to apply Edge policies for scope : $Scope. Error : $_"
        Write-Log -Message $ErrorMessage -Level Error
        Write-Error -Message $ErrorMessage
    }
}


function Enable-FirewallRules {
    [CmdletBinding()]
    param (
        [string[]]$RuleGroups
    )

    $FirewallRules = @(
        # File and printer sharing
        "@FirewallAPI.dll,-32752",
        # Network discovery
        "@FirewallAPI.dll,-28502"
    )
    Write-Verbose -Message "Enabling specified firewall rules and groups..." -Verbose

    try {
        # Enable specified rule groups
        Set-NetFirewallRule -Group $FirewallRules -Profile Any -Enabled True
        Set-NetFirewallRule -Profile Any -Name FPS-SMB-In-TCP -Enabled True

        Write-Verbose -Message 'Firewall rules enabled successfully.' -Verbose
    }
    catch {
        Write-Error -Message "Failed to enable firewall rules. Error: $_"
    }
}

function Uninstall-UWPApps {
    [CmdletBinding()]
    param (
        [string[]]$UWPApps
    )

    Write-Verbose -Message "Removing UWP apps for all users"

    foreach ($UWPApp in $UWPApps) {
        try {
            Write-Verbose -Message "Removing : $UWPApp"
            Get-AppxPackage -Name $UWPApp -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $UWPApp | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        }
        catch {
            Write-Error -Message "Failed to remove : $UWPApp"
        }
    }
}

