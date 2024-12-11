
function Get-CsvFileName
{
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $PSScriptRoot
    $OpenFileDialog.filter = "Comma delimited (*.csv) | *.csv"
    $OpenFileDialog.Title = "Select CSV file"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

$inputFile = Get-CsvFileName
if ([String]::IsNullOrEmpty($inputFile)) {
    Write-Host "`nERROR: No CSV file was selected" -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input csv 
$header = 'Ignore','SampleID','PatientName','MRN','SEX','DOB','Type','Collection','Received','DNAConcentration','DNAPurity',
    'RNA','RNAPurity','AuthorizingProvider','OrderingProvider', 'Facility','Comments','Ignore2','Ignore3','DNAPurity2'
$inputCsv = Import-Csv -Path $inputFile -Header $header

# build array of sample ids
$sampleIDs = @()
foreach ($row in $inputCsv) {

    $sampleID = ($row.SampleID -split ":")[1]
    if ([String]::IsNullOrEmpty($SampleID)){

        # no more rows
        break
    }

    # fill in array
    if ($sampleIDs -notcontains $sampleID) {

        $sampleIDs += $sampleID
    }
}

# make patient directories
foreach($sampleID in $sampleIDs){

    mkdir $sampleID
}

Write-Host "`nDone creating folders." -ForegroundColor Green
Read-Host "`nPress enter to exit"