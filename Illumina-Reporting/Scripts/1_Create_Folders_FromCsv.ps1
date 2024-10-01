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

$inputFile = Get-ChildItem -Filter *.csv | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: A CSV input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input csv 
$header = 'Ignore','SampleID', 'LastName', 'FirstName', 'MRN', 'Sex', 'DOB', 'SpecimenType', 'OrderingPhysician', 'Diagnosis', 'Notes'
$inputCsv = Import-Csv -Path $inputFile.FullName -Header $header

# build hash-table of sample ids and patient rows from input csv
$patientRows = @{} 
foreach ($row in $inputCsv) {

    $sampleID = ($row.SampleID -split ":")[1]
    if ([String]::IsNullOrEmpty($SampleID)){

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

        # test type ie. NGS Heme
        $patientSheet.cells($i,1).value = ($row.LastName -split ':')[1]
        $patientSheet.cells($i,2).value = $row.FirstName
        $patientSheet.cells($i,3).value = ($row.MRN -split ':')[1]
        $patientSheet.cells($i,6).value = ($row.DOB -split ':')[1]
        $patientSheet.cells($i,7).value = ($row.Sex -split ':')[1]
        $patientSheet.cells($i,9).value = ($row.SampleID -split ':')[1]
        $patientSheet.cells($i,14).value = ($row.SpecimenType -split ':')[1]
        $patientSheet.cells($i,22).value = 'NGS ' + $batchNumber 
        $patientSheet.cells($i,27).value = ($row.Notes -split ':')[1]
        if ($i -eq 2) {
            $patientSheet.cells(26,1).value = ($row.OrderingPhysician -split ':')[1]
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
$excel.quit()

Read-Host "`nPress enter to exit"