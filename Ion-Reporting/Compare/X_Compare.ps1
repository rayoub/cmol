
Add-Type -AssemblyName System.Windows.Forms
function Get-BEDFileName
{
    param([String] $initialDirectory)

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Text Files (*.txt)|*.txt|BED Files (*.bed)|*.bed|All Files (*.*)|*.*";
    $OpenFileDialog.Title = "Select Hotspot BED File"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}
function Get-CSVFileName
{
    param([String] $initialDirectory)

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*";
    $OpenFileDialog.Title = "Select Low Coverage CSV File"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

# get lines of BED file
$bedFile = Get-BEDFileName -initialDirectory $PSScriptRoot
$bedFileLines = Get-Content $bedFile | Where-Object { $_ -match "^c" }

# iterate BED file lines to get BED file ranges
$bedChr = [String[]]::new($bedFileLines.Length)
$bedStart = [int[]]::new($bedFileLines.Length)
$bedEnd = [int[]]::new($bedFileLines.Length)
for ($i = 0; $i -lt $bedFileLines.Length; $i++) {
    $line = $bedFileLines[$i]
    $parts = $line -split "\s+"
    $bedChr[$i] = $parts[0]
    $bedStart[$i] = $parts[1]
    $bedEnd[$i] = $parts[2]
}

# get lines of CSV file
$csvFile = Get-CSVFileName -initialDirectory $PSScriptRoot
$csvFileLines = Get-Content $csvFile | Select-Object -Skip 1 | Sort-Object

# iterate CSV file lines to get CSV file ranges
$csvChr = [String[]]::new($csvFileLines.Length - 1) # skip first line of headers
$csvStart = [int[]]::new($csvFileLines.Length - 1) 
$csvEnd = [int[]]::new($csvFileLines.Length - 1)
$csvGene = [String[]]::new($csvFileLines.Length - 1)
for ($i = 1; $i -lt $csvFileLines.Length; $i++) {
    $line = $csvFileLines[$i]
    $parts = $line -split ","
    $csvChr[$i - 1] = $parts[0]
    $csvStart[$i - 1] = $parts[1]
    $csvEnd[$i - 1] = $parts[2]
    $csvGene[$i - 1] = $parts[3]
}

# output headers
Write-Output "Gene,HS Chr,HS Start,HS End,LC Chr,LC Start,LC End"

# iterate hotspots and see if any of them fall into low coverage areas
$lastLine = ""
for ($i = 0; $i -lt $bedFileLines.Length; $i++) {
    $matchedChr = $false
    for ($j = 0; $j -lt $csvFileLines.Length - 1; $j++) {
        if ($bedChr[$i] -eq $csvChr[$j]) {
            $matchedChr = $true
            if ($bedStart[$i] -ge $csvStart[$j] -and $bedStart[$i] -le $csvEnd[$j]) {
                $line = $csvGene[$j] + "," + $bedChr[$i] + "," + $bedStart[$i].ToString() + "," + $bedEnd[$i].ToString() + "," + $csvChr[$j] + "," + $csvStart[$j].ToString() + "," + $csvEnd[$j].ToString()
                if ($line -ne $lastLine) {
                    Write-Output $line
                }
                $lastLine = $line
            }
            elseif ($bedEnd[$i] -ge $csvStart[$j] -and $bedEnd[$i] -le $csvEnd[$j]) {
                $line = $csvGene[$j] + "," + $bedChr[$i] + "," + $bedStart[$i].ToString() + "," + $bedEnd[$i].ToString() + "," + $csvChr[$j] + "," + $csvStart[$j].ToString() + "," + $csvEnd[$j].ToString()
                if ($line -ne $lastLine) {
                    Write-Output $line
                }
                $lastLine = $line
            }
        }
        elseif ($matchedChr) {
            break
        }
    }
}