
function Parse-StringField {
    param ([String] $fieldValue)

    if (-not [String]::isNullOrEmpty($fieldValue) -and $fieldValue.contains(":")) {
        ($fieldValue -split ":")[1]
    }
    else {
        $fieldValue
    }
}

function Parse-DateField {
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

$batchNumber = (Read-Host "Enter a batch number").Trim()

$suffix = "-Comprehensive Plus Assay Summary Result.docx"
$submitDir = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Patient Reports\NGS Comprehensive Plus\Comprehensive Plus To Be Submitted"

$templateFile = Get-ChildItem -Filter '*Assay Result Summary*.dotx' | Select-Object -First 1
if ($null -eq $templateFile ){
    Write-Host "`nERROR: An 'Assay Result Summary' Word template was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

$inputFile = Get-ChildItem -Filter *.csv | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: A CSV input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input csv 
$header = 'Ignore','SampleID','PatientName','MRN','SEX','DOB','Type','Collection','Received','DNAConcentration','DNAPurity',
    'RNA','RNAPurity','AuthorizingProvider','OrderingProvider', 'Facility','Comments','Ignore2','Ignore3','DNAPurity2'
$inputCsv = Import-Csv -Path $inputFile.FullName -Header $header

# build hash-table of accession #/cmol id combos and patient rows from input workbook
$patientRows = @{} 
foreach ($row in $inputCsv) {

    $sampleID = Parse-StringField $row.SampleID
    if ([String]::IsNullOrEmpty($sampleID)){

        # no more rows
        break
    }

    # fill in hash-table
    $dirName = $sampleID  + "-" + Parse-StringField $row.PatientName
    if ($patientRows.ContainsKey($dirName)) {

        # some reports may have multiple rows for a single accession #/cmol id combination
        $patientRows[$dirName] += $row
    }
    else {
        $patientRows.Add($dirName, @($row))
    }
}

# load word template
$word = New-Object -ComObject Word.Application

foreach($dirName in $patientRows.Keys){

    Write-Host "Processing $dirName"

    # path name for report
    $pathName = $submitDir + "\" + $dirName 

    # create path if it doesn't already exist
    if (!(Test-Path -Path $pathName)){
        mkdir $pathName
    }

    # fill-in templates 
    foreach($row in $patientRows[$dirName]){

        # report date
        $reportDate = Get-Date -Format "M/d/yyyy"

        # open template
        $doc = $word.documents.add($templateFile.FullName)

        $header = 'Ignore','SampleID','PatientName','MRN','SEX','DOB','Type','Collection','Received','DNAConcentration','DNAPurity',
    'RNA','RNAPurity','AuthorizingProvider','OrderingProvider', 'Facility','Comments','Ignore2','Ignore3','DNAPurity2'

        # parse fields
        $patientName = Parse-StringField $row.PatientName
        $MRN = Parse-StringField $row.MRN
        $DOB = Parse-DateField $row.DOB
        $sex = Parse-StringField $row.SEX
        $sampleID = Parse-StringField $row.SampleID
        $specimenType = Parse-StringField $row.Type 
        $runID = 'NGS ' + $batchNumber 
        $notes = Parse-StringField $row.Comments
        $provider = Parse-StringField $row.AuthorizingProvider
        $facility = Parse-StringField $row.Facility
        $collectionDate = Parse-DateField $row.Collection
        $receivedDate = Parse-DateField $row.Received

        # write template
        
        # column 1
        $doc.bookmarks("AssayID").range.text = $runID
        $doc.bookmarks("PatientName").range.text = $lastName + ", " + $firstName
        $doc.bookmarks("Providers").range.text = $provider
        $doc.bookmarks("OrderingFacility").range.text = $facility
        $doc.bookmarks("MRN").range.text = $MRN
        $doc.bookmarks("DOBandSex").range.text = $DOB + ", " + $sex
        $doc.bookmarks("SurgPathID").range.text = "MISSING"

        # column 2
        $doc.bookmarks("CollectionDate").range.text = $collectionDate
        $doc.bookmarks("ReceivedDate").range.text = $receivedDate
        $doc.bookmarks("ReportDate").range.text = $reportDate
        $doc.bookmarks("DNANumber").range.text = $sampleID
        $doc.bookmarks("Accession").range.text = $sampleID
        $doc.bookmarks("SpecimenType").range.text = $specimenType

        # notes
        $doc.bookmarks("Notes").range.text = $notes
        
        # save template
        $doc.saveas($pathName + "\" + $dirName + $suffix) 

        # clean up
        $doc.close()
    }
}

# clean up
$word.quit()

Read-Host "`nPress enter to exit"