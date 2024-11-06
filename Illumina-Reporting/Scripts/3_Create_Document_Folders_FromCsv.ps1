
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

$currentDir = Get-Location | Split-Path -Leaf
if ($currentDir -ne "results"){
    Write-Host "`nERROR: You must be in a 'results' folder to run this script." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
   exit
}

$inputFile = Get-ChildItem -Filter *.csv | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: A CSV input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

$submitDir = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Patient Reports\"
if ($reportType -ieq "Common") {
    $submitDir += "NGS Common\NGS COMMON To be Submitted"
}
elseif ($reportType -ieq "Heme") {
    $submitDir += "NGS HEME\NGS HEME To Be Submitted"
}
else {
    Write-Host "`nERROR: An invalid report type was entered." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}


# load input csv 
$header = 'Ignore','SampleID','PatientName','MRN','SEX','DOB','Type','Collection','Received','DNAConcentration','DNAPurity',
    'RNA','RNAPurity','AuthorizingProvider','OrderingProvider', 'Facility','Comments','Ignore2','Ignore3','DNAPurity2'
$inputCsv = Import-Csv -Path $inputFile.FullName -Header $header

# create folders from input csv
foreach ($row in $inputCsv) {

    $sampleID = Get-StringField $row.SampleID
    if ([String]::IsNullOrEmpty($sampleID)){

        # no more rows
        break
    }

    # CMOL_ID-LAST_NAME, FIRST_NAME
    $pathName = $submitDir + "\" + $sampleID + "-" + (Get-StringField $row.PatientName)

    # create path if it doesn't already exist
    if (!(Test-Path -Path $pathName)){
        mkdir $pathName
    }
}

Read-Host "`nPress enter to exit"