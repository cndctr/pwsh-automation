param (
    [string]$ComputerName
)
Import-Module "$PSScriptRoot\Modules\ADTools.psm1"

Enable-ADComputerRDP -ComputerName $ComputerName