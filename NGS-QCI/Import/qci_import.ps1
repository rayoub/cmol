
######################################################################################################
### FUNCTION DEFINITIONS
######################################################################################################

function Format-Date {
    param ([String] $dateText)

    if (-not [String]::isNullOrEmpty($dateText)) {
        $dateObj = [DateTime] $dateText
        Get-Date -Date $dateObj -Format 'yyyy-MM-dd'
    }
    else {
        ""
    }
}

function Get-Age {
    param ([String] $birthDateText)

    if (-not [String]::isNullOrEmpty($birthDateText)) {
        $birthDateObj = [DateTime] $birthDateText
        $todayDateObj = Get-Date 
        $age = $todayDateObj.Year - $birthDateObj.Year
        if ($birthDateObj.Date -gt $todayDateObj.AddYears(-$age)) {
            $age = $age - 1
        }
        $age
    }
    else {
        ""
    }
}

function Format-Providers {

    $providers = @()
    
    $provider = $row.Columns("R").text.trim()
    if (!$provider -eq "") {
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("S").text.trim(), $row.Columns("R").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    $provider = $row.Columns("AG").text.trim()
    if (!$provider -eq ""){
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("AH").text.trim(), $row.Columns("AG").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    $provider = $row.Columns("AI").text.trim()
    if (!$provider -eq ""){
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("AJ").text.trim(), $row.Columns("AI").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    $provider = $row.Columns("AK").text.trim()
    if (!$provider -eq ""){
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("AL").text.trim(), $row.Columns("AK").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    $provider = $row.Columns("AM").text.trim()
    if (!$provider -eq ""){
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("AN").text.trim(), $row.Columns("AM").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    ($providers -join "; ")
}

######################################################################################################
### TEMPLATE DEFINITION
######################################################################################################

$templateXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ns1:QCISomaticTest xmlns:ns1="http://qci.qiagen.com/xsd/interpret" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.12.0">
    <ns1:TestProduct>
        <ns1:Code></ns1:Code>
        <ns1:Profile></ns1:Profile>
        <ns1:ReportTemplate>KUMC_HemOnc_v2</ns1:ReportTemplate>
    </ns1:TestProduct>
    <ns1:Test>
        <ns1:AccessionId></ns1:AccessionId>
        <ns1:VariantsFilename></ns1:VariantsFilename>
        <ns1:TestDate></ns1:TestDate>
        <ns1:Diagnosis></ns1:Diagnosis>
        <ns1:PrimarySourceTissue></ns1:PrimarySourceTissue>
    </ns1:Test>
    <ns1:Patient>
        <ns1:Name></ns1:Name>
        <ns1:BirthDate></ns1:BirthDate>
        <ns1:Age></ns1:Age>
        <ns1:Gender></ns1:Gender>
    </ns1:Patient>
    <ns1:Specimen>
        <ns1:Id></ns1:Id>
        <ns1:CollectionDate></ns1:CollectionDate>
        <ns1:Type></ns1:Type>
    </ns1:Specimen>
    <ns1:Physician>
        <ns1:Name></ns1:Name>
        <ns1:ClientId></ns1:ClientId>
        <ns1:FacilityName></ns1:FacilityName>
    </ns1:Physician>
    <ns1:Pathologist>
        <ns1:Name></ns1:Name>
    </ns1:Pathologist>
</ns1:QCISomaticTest>
"@

######################################################################################################
### GATHER INPUT
######################################################################################################

$reportType = (Read-Host "Enter the report type (Comp|Heme)").Trim()

$code = $null
$tpp = $null
if ($reportType -ieq "Comp") {
    $code = "Comprehensive 275"
    $tpp = "Comprehensive_Cancer_Panel_275"
}
elseif ($reportType -ieq "Heme") {
    $code = "Heme 141"
    $tpp = "Hematologic_Neoplasms_Panel_141"
}
else {
    Write-Host "`nERROR: An invalid report type was entered." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

$inputFile = Get-ChildItem -Filter *_Input_v?.xlsx | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: An Excel input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

######################################################################################################
### DO THE WORK
######################################################################################################

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

# iterate input rows
foreach($key in $patientRows.Keys){
    foreach($row in $patientRows[$key]){

        $xml = [xml] $templateXml 

        $nsmgr = New-Object -TypeName System.Xml.XmlNamespaceManager -ArgumentList $xml.NameTable
        $nsmgr.AddNamespace("ns1", "http://qci.qiagen.com/xsd/interpret")

        # based on report type
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:TestProduct/ns1:Code", $nsmgr).InnerText = $code
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:TestProduct/ns1:Profile", $nsmgr).InnerText = $tpp

        # based on input excel
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:AccessionId", $nsmgr).InnerText = $row.Columns("D").text.trim()
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:TestDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("K").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:PrimarySourceTissue", $nsmgr).InnerText = "Unknown"

        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:Id", $nsmgr).InnerText = $row.Columns("I").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:CollectionDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("E").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:Type", $nsmgr).InnerText = $row.Columns("N").text.trim()

		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Name", $nsmgr).InnerText = $row.Columns("A").text.trim() + ", " + $row.Columns("B").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:BirthDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("F").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Age", $nsmgr).InnerText = Get-Age $row.Columns("F").text.trim()
        $gender = 'Male'
        if ($row.Columns("G").text.trim().toUpper() -ne 'M') {
            $gender = 'Female'
        }
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Gender", $nsmgr).InnerText = $gender

		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:Name", $nsmgr).InnerText = Format-Providers
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:ClientId", $nsmgr).InnerText = $row.Columns("C").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:FacilityName", $nsmgr).InnerText = $row.Columns("P").text.trim()

		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Pathologist/ns1:Name", $nsmgr).InnerText = $row.Columns("H").text.trim()

        # gather input
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:VariantsFilename", $nsmgr).InnerText = "Test"
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:Diagnosis", $nsmgr).InnerText = "Test"

        # file names
        $saveXml = (Join-Path -Path $PSScriptRoot -ChildPath ($key + ".xml"))
        $saveZip = (Join-Path -Path $PSScriptRoot -ChildPath ($key + ".zip"))

        $xml.Save($saveXml)
        $compress = @{
            Path = $saveXml
            DestinationPath = $saveZip 
            CompressionLevel = "Optimal"
        }
        Compress-Archive @compress -Force

        # since this does not handle common reports, ignore subsequent rows
        break
    }
}

# clean up 
$inputBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"