
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

######################################################################################################
### FUNCTIONS
######################################################################################################

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
        Get-Date -Date $fieldValue -Format 'MM/dd/yyyy'
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

######################################################################################################
### DO THE WORK
######################################################################################################

$suffix = "-Comprehensive Plus Assay Summary Result.docx"
$submitDir = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Patient Reports\NGS Comprehensive Plus\Comprehensive Plus To Be Submitted"

$inputFile = Get-CsvFileName
if ([String]::IsNullOrEmpty($inputFile)) {
    Write-Host "`nERROR: No CSV file was selected" -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input csv 
$header = 'Ignore','SampleID','PatientName','MRN','SEX','DOB','Type','Collection','Received','DNAConcentration','DNAPurity',
    'RNA','RNAPurity','AuthorizingProvider','OrderingProvider','Facility','Comments','Ignore2','Ignore3','DNAPurity2'
$inputCsv = Import-Csv -Path $inputFile -Header $header

# build hash-table of accession #/cmol id combos and patient rows from input csv
$patientRows = @{} 
foreach ($row in $inputCsv) {

    $sampleID = Get-StringField $row.SampleID
    if ([String]::IsNullOrEmpty($sampleID)){

        # no more rows
        break
    }

    # fill in hash-table
    $dirName = $sampleID  + "-" + (Get-StringField $row.PatientName)
    if ($patientRows.ContainsKey($dirName)) {

        # some reports may have multiple rows for a single accession #/cmol id combination
        $patientRows[$dirName] += $row
    }
    else {
        $patientRows.Add($dirName, @($row))
    }
}

# load word app
$word = New-Object -ComObject Word.Application
$word.Visible = $false

# create word docs
foreach($dirName in $patientRows.Keys){

    Write-Host "Processing $dirName"

    # path name for report
    $pathName = $submitDir + "\" + $dirName 

    # create path if it doesn't already exist
    if (!(Test-Path -Path $pathName)){
        mkdir $pathName
    }
    
    $doc = $word.documents.add()

    $row = $patientRows[$dirName][0]

    # parse fields
    $patientName = Get-StringField $row.PatientName
    $MRN = Get-StringField $row.MRN
    $DOB = Get-DateField $row.DOB
    $sex = Get-StringField $row.SEX
    $sampleID = Get-StringField $row.SampleID
    $textInfo = (Get-Culture).TextInfo
    $provider = $textInfo.ToTitleCase((Get-StringField $row.AuthorizingProvider).toLower())
    $facility = 'The University of Kansas Hospital'
    $collectionDate = Get-DateField $row.Collection
    $receivedDate = Get-DateField $row.Received

    # build text
    $text = "" + 
        $patientName + "`v" + "`v" +
        $provider + "`v" + "`v" +
        $sampleID + "`v" + "`v" +
        $MRN + "`v" +"`v" +
        $facility + "`v" + "`v" +
        $collectionDate + "`v" + "`v" +
        $DOB + ", " + $sex + "`v" + "`v" +
        "[surgepath_id]" + "`v" + "`v" +
        $receivedDate + "`v" + "`v" +
        (Get-Date -Format "MM/dd/yyyy") + "`v"

    # output text
    $selection = $word.Selection
    $selection.TypeText($text)
    $selection.TypeParagraph()
        
    # save template
    $doc.saveas($pathName + "\" + $dirName + $suffix) 

    # clean up
    $doc.close()
}

# clean up
$word.quit()

#Write-Host "`nDone writing documents to:" $submitDir -ForegroundColor Green
Read-Host "`nPress enter to exit"