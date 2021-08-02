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

$inputFile = Get-ChildItem -Filter *_Input_v?.xlsx | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: An Excel input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input workbook
$excel = New-Object -ComObject Excel.Application
$inputBook = $excel.workbooks.open($inputFile.FullName)
$inputSheet = $inputBook.sheets(1)

# build hash-table of accession #/cmol id combos and patient rows from input workbook
$patientRows = @{} 
for ($i = 2; $i -lt 100; $i++){

    $text = $inputSheet.cells($i,1).text().trim()
    if ([String]::IsNullOrEmpty($text)){

        # no more rows
        break
    }

    # fill in hash-table
    $dirName = $inputSheet.cells($i, 9).text().trim() + "_" + $inputsheet.cells($i, 4).text().trim()
    $row = $inputSheet.rows($i)
    if ($patientRows.ContainsKey($dirName)) {

        # some reports may have multiple rows for a single accession #/cmol id combination
        $patientRows[$dirName] += $row
    }
    else {
        $patientRows.Add($dirName, @($row))
    }
}

# copy and populate templates
foreach($key in $patientRows.Keys){

    # make directory for patient
    mkdir $key

    # file name for copied template
    $fileName = ((Get-Location).Path + "\" + $key + "\" + $key + " N" + $batchNumber + " summary.xlsm")

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
    foreach($a in $patientRows[$key]){
        $a.copy() | Out-Null
        $patientSheet.rows($i).pastespecial(12) | Out-Null # paste values and number formats
        $i++
    }

    # activate first worksheet
    $startSheet = $book.sheets("Start Here")
    $startSheet.Activate()

    # clean up
    $book.save()
    $book.close()
}

# clean up 
$inputBook.save()
$inputBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"