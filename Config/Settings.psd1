@{
    ScriptRoot = 'W:\scr'
    SoftPath = 'W:\soft'
    LogFilePath = 'w:\scr\Logs\ExecutionLog.txt'
    ZoomPath = 'C$\Program Files\Zoom\bin\Zoom.exe'
    ZoomInstallerUrl = 'https://zoom.us/client/latest/ZoomInstaller.exe'
    ChromeInstallerUrl = 'https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi'
    MinimumZoomVersion = '6.3.0'
    ThinClient1C = "w:\soft\1C\8.3.18.1563\x64\thinclient\1CEnterprise 8 Thin client (x86-64).msi"
    NOD32 = "w:\soft\av\nod\_office\eavbe_nt64_rus_42713.msi"
	Aspia = @{
        X64InstallerPath = 'w:\soft\_utils\aspia\aspia-host-2.7.0-x86_64.msi'
        X86InstallerPath = 'w:\soft\_utils\aspia\aspia-host-2.7.0-x86.msi'
        ConfigSourcePath = 'w:\soft\_utils\aspia\aspia-host-config.json'
        ConfigDestinationPath = 'C:\ProgramData\aspia\host.json' # Static path instead of $Env
    }
    DefenderExclusionPaths = @(
        'W:\soft',
        'D:\install',
        '\\srv-store\share\files\soft',
        '\\srv-store\soft'
    )
    WingetImportFile = 'w:\soft\winget\basic_import.json'
    WinRAR = @{
        KeySourcePath = 'w:\soft\_utils\winrar\rarreg.key'
        KeyDestinationPath = 'C:\Program Files\WinRAR\'
    }
    SumatraPDFArguments = '/install /s -with-preview -all-users'

}
