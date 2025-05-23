# Set-Location "W:\scr"
# Define input and output files
$InputCsv = "$PSScriptRoot\config\printers.csv"  # Change if needed
$OutputCsv = "$PSScriptRoot\logs\counters.csv"
$SerialNumberOID = "1.3.6.1.2.1.43.5.1.1.17.1" # Serial number
$ModelNameOID = "1.3.6.1.2.1.25.3.2.1.3.1" # Model name
$Community = "public"  # Change if needed

# Read CSV file (assuming semicolon as delimiter)
$Printers = Import-Csv -Path $InputCsv -Delimiter ";"

# Check if Get-SNMPData function is available
if (-not (Get-Command Get-SNMPData -ErrorAction SilentlyContinue)) {
    Write-Error "The Get-SNMPData function is missing. Ensure SNMP module is installed."
    exit
}

# Create an array to store results
$Results = @()
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Iterate through printers
foreach ($Printer in $Printers) {
    $IP = $Printer.IP
    $PrinterName = $Printer.PrinterName
    $PageCountOID = $Printer.TotalPagesOID
    $SNMPVer = $Printer.SNMPVer  # Read OID from CSV
    
    Write-Host "Querying SNMP for $PrinterName ($IP)"
    
    try {
        # Fetch SNMP data
        $PageCount = (Get-SNMPData -Community $Community -IP $IP -OID $PageCountOID -Version $SNMPVer).Data
        $SerialNumber = (Get-SNMPData -Community $Community -IP $IP -OID $SerialNumberOID -Version $SNMPVer).Data
        $ModelName = (Get-SNMPData -Community $Community -IP $IP -OID $ModelNameOID -Version $SNMPVer).Data
        
        # Store result
        $Results += [PSCustomObject]@{
            Timestamp = $Timestamp
            PrinterName = $PrinterName
            SerialNumber = $SerialNumber
            ModelName = $ModelName
            IP = $IP
            PageCount = $PageCount
        }
    } catch {
        Write-Warning "Failed to get SNMP data for $PrinterName ($IP)"
        $Results += [PSCustomObject]@{
            Timestamp = $Timestamp
            PrinterName = $PrinterName
            SerialNumber = "ERROR"
            ModelName = "ERROR"
            IP = $IP
            PageCount = "ERROR"
        }
    }
}

# Append results to CSV
$Results | Export-Csv -Path $OutputCsv -NoTypeInformation -Delimiter ";" -Append
Write-Host "Results appended to $OutputCsv"
