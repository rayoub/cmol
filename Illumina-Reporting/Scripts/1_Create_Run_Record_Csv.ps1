
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Get-StringField {
    param ([String] $fieldValue)

    if (-not [String]::isNullOrEmpty($fieldValue) -and $fieldValue.contains(":")) {
        ($fieldValue -split ":")[1]
    }
    else {
        $fieldValue
    }
}

function Get-DateField {
    param ([String] $fieldValue)

    if (-not [String]::isNullOrEmpty($fieldValue) -and $fieldValue.contains(":")) {
        if ($fieldValue.endsWith("M")) {
            $fieldValue = $fieldValue.substring(0, $fieldValue.LastIndexOf("/"))
        }
        $fieldValue = ($fieldValue -split ":")[1]
        Get-Date -Date $fieldValue -Format 'yyyy-MM-dd'
    }
    else {
        $fieldValue
    }
}
function Get-CsvFileName
{
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $PSScriptRoot
    $OpenFileDialog.filter = "Comma delimited (*.csv) | *.csv"
    $OpenFileDialog.Title = "Select CSV file"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

$batchNumber = (Read-Host "Enter a batch number").Trim()

$currentDir = Get-Location | Split-Path -Leaf
if ($currentDir -ne "results"){
    Write-Host "`nERROR: You must be in a 'results' folder to run this script." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
   exit
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

$outRows = @()
foreach ($row in $inputCsv) {

    $sampleID = Get-StringField $row.SampleID

    if ([String]::IsNullOrEmpty($sampleID)){

        # no more rows
        break
    }

    $lastName = ((Get-StringField $row.PatientName) -split ',')[0]
	$firstName = ((Get-StringField $row.PatientName) -split ',')[1]
	$mrn = Get-StringField $row.MRN
	$accession = $sampleID
	$collectionDate = Get-DateField $row.Collection
	$birthDate = Get-DateField $row.DOB
	$gender = Get-StringField $row.SEX
	$caseId = "n/a"
	$dnaNumber = $sampleID
	$receivedDate = Get-DateField $row.Received
	$sampleType = Get-StringField $row.Type
	if ($sampleType -ilike '*paraffin*') {
		$sampleType = 'FFPE'
	}
	$orderingLocation = Get-StringField $row.Facility
	$provideLastName = ((Get-StringField $row.AuthorizingProvider) -split ',')[0]
	$provideFirstName = ((Get-StringField $row.AuthorizingProvider) -split ',')[1]
	$concentration = Get-StringField $row.DNAConcentration
	$A260A280 = Get-StringField $row.DNAPurity

	$outRows += [PSCustomObject]@{
		'LastName' = $lastName
		'FirstName' = $firstName
		'MRN' = $mrn
		'Accession' = $accession
		'CollectionDate' = $collectionDate
		'BirthDate' = $birthDate
		'Gender' = $gender
		'CaseId' = $caseId
		'DNANumber' = $dnaNumber
		'Color' = ''
		'ReceivedDate' = $receivedDate
		'ReceivedTime' = ''
		'ReceivedBy' = ''
		'SampleType' = $sampleType
		'SampleAmount' = ''
		'OrderingLocation' = $orderingLocation
		'LocationCode' = ''
		'ProviderLastName' = $provideLastName
		'ProviderFirstName' = $provideFirstName
		'DueDate' = ''
		'TestRequested' = ''
		'AssayID' = 'NGS ' + $batchNumber
		'TestRunDate' = ''
		'ReportedDate' = ''
		'TestRunBy' = ''
		'InvoiceNumber' = ''
		'Notes' = ''
		'Column1' = ''
		'Column2' = ''
		'Column3' = ''
		'TestRequested4' = ''
		'Holidays' = ''
		'OrderingLocation5' = ''
		'Column6' = ''
		'Column7' = ''
		'Column8' = ''
		'Column9' = ''
		'Column10' = ''
		'Column11' = ''
		'Column12' = ''
		'Column13' = ''
		'Column14' = ''
		'Concentration' = $concentration
		'A260A280' = $A260A280
	}
}

$outRows | Export-Csv -Path .\RunRecord.csv -NoTypeInformation

Write-Host "`nDone creating run record CSV." -ForegroundColor Green
Read-Host "`nPress enter to exit"

