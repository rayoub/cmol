
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
	$caseId = "N/A"
	$dnaNumber = $sampleID
	$receivedDate = Get-DateField $row.Received
	$sampleType = Get-StringField $row.Type
	if ($sampleType -ilike '*paraffin*') {
		$sampleType = 'FFPE'
	}
	$orderingLocation = 'The University of Kansas Hospital'
	$provideLastName = ((Get-StringField $row.AuthorizingProvider) -split ',')[0]
	$provideFirstName = ((Get-StringField $row.AuthorizingProvider) -split ',')[1]
	$notes = Get-StringField $row.Comments
	$dnaConcentration = Get-StringField $row.DNAConcentration
	$rnaConcentration = Get-StringField $row.RNA

	$outRows += [PSCustomObject]@{
		'LastName' = $lastName
		'FirstName' = $firstName
		'MRN' = $mrn
		'Accession' = $accession
		'CollectionDate' = $collectionDate
		'BirthDate' = $birthDate
		'Gender' = $gender
		'CaseId' = $caseId
		'DNANumber' = $dnaNumber + ".2"
		'Color' = 'Blue'
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
		'TestRequested' = 'Comprehensive Cancer Plus NGS Panel'
		'AssayID' = 'GS NGS ' + $batchNumber
		'TestRunBy' = ''
		'TestRunDate' = ''
		'ReportedDate' = ''
		'InvoiceNumber' = ''
		'Notes' = $notes
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
		'DNAExtractedDate' = ''
		'DNAExtractedBy' = ''
		'Concentration' = $dnaConcentration
	}

	$outRows += [PSCustomObject]@{
		'LastName' = $lastName
		'FirstName' = $firstName
		'MRN' = $mrn
		'Accession' = $accession
		'CollectionDate' = $collectionDate
		'BirthDate' = $birthDate
		'Gender' = $gender
		'CaseId' = $caseId
		'DNANumber' = $dnaNumber + ".3"
		'Color' = 'Purple'
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
		'TestRequested' = 'Comprehensive Cancer Plus NGS Panel'
		'AssayID' = 'GS NGS ' + $batchNumber
		'TestRunBy' = ''
		'TestRunDate' = ''
		'ReportedDate' = ''
		'InvoiceNumber' = ''
		'Notes' = $notes
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
		'DNAExtractedDate' = ''
		'DNAExtractedBy' = ''
		'Concentration' = $rnaConcentration
	}
}

$outRows | Export-Csv -Path .\RunRecord.csv -NoTypeInformation

Write-Host "`nDone creating run record CSV." -ForegroundColor Green
Read-Host "`nPress enter to exit"

