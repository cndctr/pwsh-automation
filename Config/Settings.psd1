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
    MSOffice = @{
        ImageFile = 'w:\soft\ms_office\Office2016.img'
        ConfigFile = 'w:\soft\ms_office\Office2016_basic.ini'
        InstallerScript = 'w:\soft\ms_office\installer.cmd'
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
    UWPApps =@(
        "Microsoft.549981C3F5F10",
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.MixedReality.Portal",
        "Microsoft.Office.OneNote",
        "Microsoft.People",
        "Microsoft.Wallet",
        "Microsoft.SkypeApp",
        "microsoft.windowscommunicationsapps",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.Windows.DevHome",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    )
}
