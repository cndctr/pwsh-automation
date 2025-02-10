# Install Chrome, Zoom, FSViewer, etc using winget
winget import 'w:\soft\winget\basic_import.json'
Copy-Item 'w:\soft\_utils\winrar\rarreg.key' -destination 'c:\program files\winrar\'
winget install sumatrapdf.sumatrapdf --accept-source-agreements --override "/install /s -with-preview -all-users"