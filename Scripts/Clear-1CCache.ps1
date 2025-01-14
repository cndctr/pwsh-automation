<#
.SYNOPSIS
Clears 1C cache folders with GUID names based on scope and level.

.DESCRIPTION
This script processes 1C cache folders under `AppData` and/or `LocalAppData` directories, based on the specified parameters.

.PARAMETER Scope
Specifies the user scope for the operation. Allowed values:
- `CurrentUser`: Processes the current user's AppData paths.
- `AllUsers`: Processes AppData paths for all users.

.PARAMETER Level
Determines which paths to process. Allowed values:
- `Full`: Processes both AppData and LocalAppData.
- `Local`: Processes only LocalAppData.

.PARAMETER Force
If specified, the script performs deletions. Otherwise, it runs in dry-run mode.

.EXAMPLE
.\Clear-1CCache.ps1 -Scope CurrentUser -Level Full -Force

.EXAMPLE
.\Clear-1CCache.ps1 -Scope AllUsers -Level Local
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

function Clear-1CCache {
    param (
        [string[]]$TargetPaths,
        [switch]$PerformDeletion
    )

    foreach ($path in $TargetPaths) {
        Write-Host "Processing path: $path" -ForegroundColor Cyan
        Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue | Where-Object {
            $_.Name -as [guid]
        } | ForEach-Object {
            if ($PerformDeletion) {
                Write-Host "Removing folder: $($_.FullName)" -ForegroundColor Yellow
                Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
            } else {
                Write-Host "Found folder: $($_.FullName)" -ForegroundColor Green
            }
        }
    }
}

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

Clear-1CCache -TargetPaths $Paths -PerformDeletion:$Force
