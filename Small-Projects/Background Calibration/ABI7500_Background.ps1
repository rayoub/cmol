
Add-Type -AssemblyName System.Windows.Forms

function Get-FileName
{
    param([String] $initialDirectory)

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Comma-Separated Values (*.csv) | *.csv"
    $OpenFileDialog.Title = "Select CSV for Processing"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

$dirPath = (Join-Path $PSScriptRoot -ChildPath $dirName)
$file = Get-FileName -initialDirectory $dirPath 
if ([String]::IsNullOrEmpty($file)) {
    Write-Host "No CSV file selected.`n" -ForegroundColor Red
    continue
}
$fileName = (Split-Path -Path $file -Leaf)

$alerts = @()
$lines = Get-Content $fileName
for ($i = 4; $i -le $lines.length; $i++) {

    $line = $lines[$i];
    if (-not [String]::isNullOrEmpty($line)) {
        $fields = $line -split ','

        $reading = $fields[0].trim()
        $well = $fields[1].trim()

        $filterA = $fields[2].trim()
        $filterB = $fields[3].trim()
        $filterC = $fields[4].trim()
        $filterD = $fields[5].trim()
        $filterE = $fields[6].trim()

        if ([int] $filterA -gt 72000) {
            $alerts += @{ reading = $reading; well = $well; filter = "A"; value = $filterA }
        }
        if ([int] $filterB -gt 72000) {
            $alerts += @{ reading = $reading; well = $well; filter = "B"; value = $filterB }
        }
        if ([int] $filterC -gt 72000) {
            $alerts += @{ reading = $reading; well = $well; filter = "C"; value = $filterC }
        }
        if ([int] $filterD -gt 72000) {
            $alerts += @{ reading = $reading; well = $well; filter = "D"; value = $filterD }
        }
        if ([int] $filterE -gt 90000) {
            $alerts += @{ reading = $reading; well = $well; filter = "E"; value = $filterE }
        }
    }
}

Write-Host "Reading,Well,Filter,Value"
if ($alerts.Count -gt 0) {
    foreach ($alert in $alerts) {
        Write-Host ($alert.reading + "," + $alert.well + "," + $alert.filter + "," + $alert.value)
    }
}

Read-Host "`nPress enter to exit"
