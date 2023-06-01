
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
    $OpenFileDialog.Title = "Select Coverage CSV File"
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

# get low-coverage regions from the CSV file
$csvFile = Get-CSVFileName -initialDirectory $PSScriptRoot
$csvRegions = Import-Csv $csvFile | Where-Object { [int]$_.Total -le 200 } | Sort-Object -Property Chr

# iterate hotspots and see if any of them fall into low coverage regions
$matched = @()
for ($i = 0; $i -lt $bedFileLines.Length; $i++) {
    $matchedChr = $false
    for ($j = 0; $j -lt $csvRegions.Length; $j++) {
        if ($bedChr[$i] -eq $csvRegions[$j].Chr) {
            $matchedChr = $true
            if (($bedStart[$i] -ge $csvRegions[$j].Start -and $bedStart[$i] -le $csvRegions[$j].End) -or
                ($bedEnd[$i] -ge $csvRegions[$j].Start -and $bedEnd[$i] -le $csvRegions[$j].End)
            ) {

                $matched += [PSCustomObject]@{
                    Gene = $csvRegions[$j].Attributes 
                    HSChr = $bedChr[$i]
                    HSStart = $bedStart[$i]
                    HSEnd = $bedEnd[$i]
                    LCChr = $csvRegions[$j].Chr
                    LCStart = $csvRegions[$j].Start
                    LCEnd =  + $csvRegions[$j].End
                }
            }
        }
        elseif ($matchedChr) {
            break
        }
    }
}

# output matched regions to a csv
$matched | Sort-Object -Property Gene, HSChr, HSStart, HSEnd, LCChr, LCStart, LCEnd -Unique | Export-Csv -Path .\lowcoveragehotspots.csv -NoTypeInformation

# output matched genes to text
$matched | Select-Object -Property Gene | Sort-Object -Property Gene -Unique | Select-Object -ExpandProperty Gene | Set-Content -Path .\lowcoveragegenes.txt

