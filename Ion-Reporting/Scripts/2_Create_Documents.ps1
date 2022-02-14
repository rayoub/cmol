
$panel = "Comprehensive Plus"
$suffix = "-Comprehensive Plus.docx"
$submitDir = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Patient Reports\NGS Comprehensive Plus\Comprehensive Plus To Be Submitted"

$templateFile = Get-ChildItem -Filter '*Assay Result Summary*.dotx' | Select-Object -First 1
if ($null -eq $templateFile ){
    Write-Host "`nERROR: An 'Assay Result Summary' Word template was not found in the current directory." -ForegroundColor Red
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

    $text = $inputSheet.cells($i,1).text.trim()
    if ([String]::IsNullOrEmpty($text)){

        # no more rows
        break
    }

    # fill in hash-table
    # CMOL_ID-LAST_NAME, FIRST_NAME
    $dirName = $inputSheet.cells($i, 9).text.trim() + "-" + $inputsheet.cells($i, 1).text.trim() + ", " + $inputSheet.cells($i, 2).text.trim()
    $row = $inputSheet.rows($i)
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

    # path name for report
    $pathName = $submitDir + "\" + $dirName 

    # create path if it doesn't already exist
    if (!(Test-Path -Path $pathName)){
        mkdir $pathName
    }

    # fill-in templates 
    foreach($a in $patientRows[$dirName]){

        # providers
        $providers = @()
        
        $provider = $a.Columns("R").text.trim()
        if (!$provider -eq "") {
            $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
            $providers += (($doctor, $a.Columns("S").text.trim(), $a.Columns("R").text.trim()) | 
                Where-Object {$_ -ne ""}) -join " "
        }

        $provider = $a.Columns("AG").text.trim()
        if (!$provider -eq ""){
            $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
            $providers += (($doctor, $a.Columns("AH").text.trim(), $a.Columns("AG").text.trim()) | 
                Where-Object {$_ -ne ""}) -join " "
        }

        $provider = $a.Columns("AI").text.trim()
        if (!$provider -eq ""){
            $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
            $providers += (($doctor, $a.Columns("AJ").text.trim(), $a.Columns("AI").text.trim()) | 
                Where-Object {$_ -ne ""}) -join " "
        }

        $provider = $a.Columns("AK").text.trim()
        if (!$provider -eq ""){
            $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
            $providers += (($doctor, $a.Columns("AL").text.trim(), $a.Columns("AK").text.trim()) | 
                Where-Object {$_ -ne ""}) -join " "
        }

        $provider = $a.Columns("AM").text.trim()
        if (!$provider -eq ""){
            $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
            $providers += (($doctor, $a.Columns("AN").text.trim(), $a.Columns("AM").text.trim()) | 
                Where-Object {$_ -ne ""}) -join " "
        }

        $providersField = ($providers -join "; ")

        # report date
        $reportDate = Get-Date -Format "M/d/yyyy"

        # open template
        $doc = $word.documents.add($templateFile.FullName)

        # write template
        
        # top 
        $doc.bookmarks("Assay").range.text = $panel

        # column 1
        $doc.bookmarks("AssayID").range.text = $a.Columns("V").text.trim()
        $doc.bookmarks("PatientName").range.text = $a.Columns("A").text.trim() + ", " + $a.Columns("B").text.trim()
        $doc.bookmarks("Providers").range.text = $providersField
        $doc.bookmarks("OrderingFacility").range.text = $a.Columns("P").text.trim()
        $doc.bookmarks("MRN").range.text = $a.Columns("C").text.trim()
        $doc.bookmarks("DOBandSex").range.text = $a.Columns("F").text.trim() + ", " + $a.Columns("G").text.trim()

        # column 2
        $doc.bookmarks("CollectionDate").range.text = $a.Columns("E").text.trim()
        $doc.bookmarks("ReceivedDate").range.text = $a.Columns("K").text.trim()
        $doc.bookmarks("ReportDate").range.text = $reportDate
        $doc.bookmarks("DNANumber").range.text = $a.Columns("I").text.trim()
        $doc.bookmarks("Accession").range.text = $a.Columns("D").text.trim()
        $doc.bookmarks("SpecimenType").range.text = $a.Columns("N").text.trim()

        # notes
        $doc.bookmarks("Notes").range.text = $a.Columns("AA").text.trim()

        # save template
        $doc.saveas($pathName + "\" + $dirName + $suffix) 

        # clean up
        $doc.close()
    }
}

# clean up
$word.quit()

# clean up 
$inputBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"