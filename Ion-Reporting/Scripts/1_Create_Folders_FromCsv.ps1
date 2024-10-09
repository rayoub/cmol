
$inputFile = Get-ChildItem -Filter *.csv | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: A CSV input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input csv 
$header = 'Ignore','SampleID', 'LastName', 'FirstName', 'MRN', 'Sex', 'DOB', 'SpecimenType', 'OrderingPhysician', 'Diagnosis', 'Notes'
$inputCsv = Import-Csv -Path $inputFile.FullName -Header $header

# build array of sample ids
$sampleIDs = @()
foreach ($row in $inputCsv) {

    $sampleID = ($row.SampleID -split ":")[1]
    if ([String]::IsNullOrEmpty($SampleID)){

        # no more rows
        break
    }

    # fill in array
    if ($sampleIDs -notcontains $sampleID) {

        $sampleIDs += $sampleID
    }
}

# make patient directories
foreach($sampleID in $sampleIDs){

    mkdir $sampleID
}

Read-Host "`nPress enter to exit"