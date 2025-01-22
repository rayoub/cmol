Add-Type -AssemblyName System.Windows.Forms

# ******************************************************************************************
# *** FUNCTIONS ***
# ******************************************************************************************

function Get-ValidateForFolder
{
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog 
    $dialog.SelectedPath = "C:\CompareResults\ValidateFor"
	$dialog.ShowNewFolderButton = $false
    $dialog.Description = "Select the backed up 'pending' folder to validate for."
    if ($dialog.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true })) -eq "OK")
    {
		$dialog.SelectedPath
	}
	else {
		$null
	}
}

function Get-CompareToFolder
{
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.SelectedPath = "C:\CompareResults\CompareTo"
	$dialog.ShowNewFolderButton = $false
    $dialog.Description = "Select the NGS run 'results' folder to compare to."
    if ($dialog.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true })) -eq "OK")
    {
		$dialog.SelectedPath
	}
	else {
		$null
	}
}

function Compare-Files {

	param(
		$validateForFile,
		$compareToFile
	)

	$sampleName = $compareToFile.Directory.Name

	# return values
	$unmatchedValidateForRows = @()
	$unmatchedCompareToRows = @()

	# csv files
	$validateForRows= Import-Csv $validateForFile.FullName
	$compareToRows = Import-Csv $compareToFile.FullName

	for ($i = 0; $i -lt $validateForRows.Length; $i++) {
		
		$iRow = $validateForRows[$i]

		$matched = $false
		for ($j = 0; $j -lt $compareToRows.Length; $j++) {
			
			$jRow = $compareToRows[$j]
			
			$matched = ($iRow.Chromosome -eq $jRow.Chromosome) -and ($iRow.Region -eq $jRow.Region) -and ($iRow.Type -eq $jRow.Type) -and ($iRow.Reference -eq $jRow.Reference) -and ($iRow.Allele -eq $jRow.Allele)
			if ($matched) {
				break
			}
		}

		if (!$matched) {
			$unmatchedValidateForRows += $iRow
		}
	}

	for ($i = 0; $i -lt $compareToRows.Length; $i++) {
		
		$iRow = $compareToRows[$i]

		$matched = $false
		for ($j = 0; $j -lt $validateForRows.Length; $j++) {
			
			$jRow = $validateForRows[$j]
			
			$matched = ($iRow.Chromosome -eq $jRow.Chromosome) -and ($iRow.Region -eq $jRow.Region) -and ($iRow.Type -eq $jRow.Type) -and ($iRow.Reference -eq $jRow.Reference) -and ($iRow.Allele -eq $jRow.Allele)
			if ($matched) {
				break
			}
		}
		if (!$matched) {
			$unmatchedCompareToRows += $iRow
		}
	}

	$unmatchedValidateForRows, $unmatchedCompareToRows
} 

# ******************************************************************************************
# *** GATHER INPUTS ***
# ******************************************************************************************

$validateForFolder = Get-ValidateForFolder
if ($null -eq $validateForFolder) {
   	Write-Host "`nEXITING: No validation folder selected." -ForegroundColor Red
  	exit
}

$compareToFolder = Get-CompareToFolder
if ($null -eq $compareToFolder) {
   	Write-Host "`nEXITING: No comparison folder selected." -ForegroundColor Red
  	exit
}
if (!$compareToFolder.toLower().endsWith("results")){
   	Write-Host "`nERROR: You must select an NGS run 'results' folder to compare to." -ForegroundColor Red
  	exit
}

$validateForPercentFiles = Get-ChildItem -Path $validateForFolder -Filter "*%.csv" | Sort-Object
$validateForHotspotFiles = Get-ChildItem -Path $validateForFolder -Filter "*Hotspot.csv" | Sort-Object
$compareToPercentFiles = @("C*", "D*_*") | ForEach-Object{ Get-ChildItem -Path $compareToFolder -Directory -Filter $_} | Get-ChildItem -Filter "*%.csv" | Sort-Object
$compareToHotspotFiles = @("C*", "D*_*") | ForEach-Object{ Get-ChildItem -Path $compareToFolder -Directory -Filter $_} | Get-ChildItem -Filter "*Hotspot.csv" | Sort-Object

#******************************************************************************************
#*** VALIDATION ***
#******************************************************************************************

# initialize unmatched rows
$unmatchedValidateForRows = $()
$unmatchedCompareToRows = $()

# validate percent files
foreach($validateForFile in $validateForPercentFiles) {

	$matched = $false
	$validateForFileName = $validateForFile.BaseName.SubString(0,$validateForFile.BaseName.IndexOf(")") + 1)
	foreach($compareToFile in $compareToPercentFiles) {

		$compareToFileName = $compareToFile.BaseName.SubString(0,$compareToFile.BaseName.IndexOf(")") + 1)
		if ($compareToFileName -ieq $validateForFileName) {

			$matched = $true
			
			Write-Host "`nValidating for the following match:" 

			$validateForFile.FullName
			$compareToFile.FullName

			$a, $b = Compare-Files $validateForFile $compareToFile
			$unmatchedValidateForRows += $a
			$unmatchedCompareToRows += $b

			# look for the next files
			break
		}
	}
	if ($matched -eq $false) {
    	Write-Host "`nWARNING:" $validateForFileName "file was not matched"  -ForegroundColor Red
	}

	# just do one file compare for now
	break
}

Write-Host "unmatchedValidateForRows"
$unmatchedValidateForRows
Write-Host "unmatchedCompareToRows"
$unmatchedCompareToRows