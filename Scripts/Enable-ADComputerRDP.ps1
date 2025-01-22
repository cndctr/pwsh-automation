param (
    [string]$ComputerName
)
Import-Module W:\scr\Modules\ADTools.psm1

Enable-ADComputerRDP -ComputerName $ComputerName