
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

$reportType = (Read-Host "Enter the report type (Common|Heme)").Trim()
$batchNumber = (Read-Host "Enter a batch number").Trim()
$stampInitials = (Read-Host "Enter your initials").Trim()
$stampDate = (Read-Host "Enter the date").Trim()

$currentDir = Get-Location | Split-Path -Leaf
if ($currentDir -ne "results"){
    Write-Host "`nERROR: You must be in a 'results' folder to run this script." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
   exit
}

$templateFile = Get-ChildItem -Filter *.xlsm | Select-Object -First 1
if ($null -eq $templateFile ){
    Write-Host "`nERROR: A macro-enabled Excel file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

$inputFile = Get-ChildItem -Filter *-*.csv | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: A CSV input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input csv 
$header = 'Ignore','SampleID','PatientName','MRN','SEX','DOB','Type','Collection','Received','DNAConcentration','DNAPurity',
    'RNA','RNAPurity','AuthorizingProvider','OrderingProvider', 'Facility','Comments','Ignore2','Ignore3','DNAPurity2'
$inputCsv = Import-Csv -Path $inputFile.FullName -Header $header

# build hash-table of sample ids and patient rows from input csv
$patientRows = @{} 
foreach ($row in $inputCsv) {

    $sampleID = Get-StringField $row.SampleID
    if ([String]::IsNullOrEmpty($sampleID)){

        # no more rows
        break
    }

    # fill in hash-table
    if ($patientRows.ContainsKey($sampleID)) {

        # some reports may have multiple rows for a single sample id
        $patientRows[$sampleID] += $row
    }
    else {
        $patientRows.Add($sampleID, @($row))
    }
}

# copy and populate templates
$excel = New-Object -ComObject Excel.Application
foreach($sampleID in $patientRows.Keys){

    # make directory for patient
    mkdir $sampleID

    # file name for copied template
    $fileName = ((Get-Location).Path + "\" + $sampleID + "\" + $sampleID + " N" + $batchNumber + " summary.xlsm")

    # copy template to patient directory and rename
    Copy-Item $templateFile -Destination $fileName

    # open template
    $book = $excel.workbooks.open($fileName)

    # sleep for a bit
    Start-Sleep -Seconds 5

    # assign initials and date
    $resultSheet = $book.sheets("Result")
    $resultSheet.cells(2, 2).value = $stampInitials
    $resultSheet.cells(2, 4).value = $stampDate

    # copy patient rows
    $i = 2 
    $patientSheet = $book.sheets("Patient Information")
    foreach($row in $patientRows[$sampleID]){

        # ROW DEFINITION
        #Last Name,First Name,MRN,Accession,Collection Date,
        #Birth Date,Gender,Case ID,CMOL ID,Color,
        #Received Date,Received Time,Received By,Sample Type,Sample Amount,
        #Ordering Location,Test Code,Provider Last Name,Provider First Name,Due Date,
        #Test Requested,Assay ID,Test Run Date,Reported/Canceled Date,Test Run By,
        #Invoice Number,Notes

        # input test type ie. NGS Heme
        $patientSheet.cells($i,1).value = ((Get-StringField $row.PatientName) -split ',')[0]
        $patientSheet.cells($i,2).value = ((Get-StringField $row.PatientName) -split ',')[1]
        $patientSheet.cells($i,3).value = Get-StringField $row.MRN
        $patientSheet.cells($i,4).value = 'n/a'
        $patientSheet.cells($i,5).value = Get-DateField $row.Collection
        $patientSheet.cells($i,6).value = Get-DateField $row.DOB
        $patientSheet.cells($i,7).value = Get-StringField $row.SEX
        $patientSheet.cells($i,9).value = Get-StringField $row.SampleID
        $patientSheet.cells($i,11).value = Get-DateField $row.Received
        $sampleType = Get-StringField $row.Type
        if ($sampleType -ilike '*paraffin*') {
            $sampleType = 'FFPE'
        }
        $patientSheet.cells($i,14).value = $sampleType
        $patientSheet.cells($i,16).value = Get-StringField $row.Facility
        $patientSheet.cells($i,21).value = 'NGS ' + $reportType
        $patientSheet.cells($i,22).value = 'NGS ' + $batchNumber 
        $patientSheet.cells($i,27).value = Get-StringField $row.Comments
        $textInfo = (Get-Culture).TextInfo
        if ($i -ieq 2) {
            if ($reportType -eq 'Heme') {
                $patientSheet.cells(26,1).value = $textInfo.toTitleCase((Get-StringField $row.AuthorizingProvider).toLower())
            }
            else { # -eq 'Common
                $patientSheet.cells(22,2).value = $textInfo.toTitleCase((Get-StringField $row.AuthorizingProvider).toLower())
            }
        }

        $i++
    }

    # activate first worksheet
    $startSheet = $book.sheets("Start Here")
    $startSheet.Activate()

    # clean up
    $book.save()
    $book.close()
}

Remove-Variable 'book','resultSheet','startSheet','patientSheet'
$excel.quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
[GC]::Collect()

Read-Host "`nPress enter to exit"