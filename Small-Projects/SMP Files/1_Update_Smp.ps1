
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Get-CsvFileName
{
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $PSScriptRoot
    $OpenFileDialog.filter = "Comma delimited (*.csv) | *.csv"
    $OpenFileDialog.Title = "Select CSV file with samples."
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

function Get-SmpFileName
{
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $PSScriptRoot
    $OpenFileDialog.filter = "Comma delimited (*.smp) | *.smp"
    $OpenFileDialog.Title = "Select SMP file to update."
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

$csvFile = Get-CsvFileName
$smpFile = Get-SmpFileName

$done = Select-String -Path $csvFile -Pattern ',"Patient Name:' -Quiet
if (!$done) {
    Write-Host "`nThe CSV file is invalid." 
    Read-Host "Press enter to exit"
    exit
}

# load csv 
$header = 'Ignore','SampleID','PatientName','MRN','SEX','DOB','Type','Collection','Received','DNAConcentration','DNAPurity',
    'RNA','RNAPurity','AuthorizingProvider','OrderingProvider', 'Facility','Comments','Ignore2','Ignore3','DNAPurity2'
$inputCsv = Import-Csv -Path $csvFile -Header $header

# iterate rows and update smp file contents
$i = 0
$smpFileContents = (Get-Content $smpFile)
foreach ($row in $inputCsv) {

    $sampleID = ($row.SampleID -split ":")[1]
    if ([String]::IsNullOrEmpty($sampleID)){

        # no more rows
        break
    }

    $i++
    $smpFileContents = $smpFileContents -replace "<NAME>SAMPLE$i", "<NAME>$sampleID"
}

$smpFileContents | Set-Content $smpFile
    
Write-Host "`nDone updating SMP file." -ForegroundColor Green
Read-Host "Press enter to exit"