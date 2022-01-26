
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
    $id = $inputSheet.cells($i, 9).text().trim() + "_" + $inputsheet.cells($i, 4).text().trim()
    $row = $inputSheet.rows($i)
    if ($patientRows.ContainsKey($id)) {

        # some reports may have multiple rows for a single accession #/cmol id combination
        $patientRows[$id] += $row
    }
    else {
        $patientRows.Add($id, @($row))
    }
}

# copy and populate templates
foreach($id in $patientRows.Keys){

    # create file 
    $fileName = ($id + ".txt")
    New-Item -Path . -Name $fileName -ItemType "file" -Force

    foreach($a in $patientRows[$id]) {

        # patient name
        "Patient Name:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $a.Columns("A").text.trim() + ", " + $a.Columns("B").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        
        # facility 
        "Facility:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $a.Columns("P").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # accession #
        "Accession #:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $a.Columns("D").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # provider name
        "Provider Name:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $provider = $a.Columns("R").text.trim()
        if (!$provider -eq "") {
            $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
            $provider = (($doctor, $a.Columns("S").text.trim(), $a.Columns("R").text.trim()) | 
                Where-Object {$_ -ne ""}) -join " "
        }
        $provider + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # dob
        "DOB:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $a.Columns("F").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # collection date
        "Collection Date:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $a.Columns("E").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # sex
        "Sex:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $a.Columns("G").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # received date
        "Received Date:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $a.Columns("K").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # MRN
        "MRN:" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
        $a.Columns("C").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
    }
}

# clean up 
$inputBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"