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
		$compareToFile,
		$excel
	)

	$sampleName = $compareToFile.Directory.Name

	# return values
	$unmatchedValidateForRows = @()
	$unmatchedCompareToRows = @()

	$validateForBook = $excel.workbooks.open($validateForFile.FullName)
	$compareToBook = $excel.workbooks.open($compareToFile.FullName)

	# sleep for a bit
	Start-Sleep -Seconds 5

	$validateForSheet = $validateForBook.sheets(1)
	$compareToSheet = $compareToBook.sheets(1)

	$i = 2
	while (![string]::IsNullOrEmpty($validateForSheet.Cells($i, 1).Text)) {

		$row = $validateForSheet.Rows($i)

		$v_chromosome = $row.Cells(1).Text
		$v_region = $row.Cells(2).Text
		$v_type = $row.Cells(3).Text
		$v_reference = $row.Cells(4).Text
		$v_allele = $row.Cells(5).Text

		$j = 2
		$matched = $false
		while (![string]::IsNullOrEmpty($compareToSheet.Cells($j, 1).Text)) {

			$row = $compareToSheet.Rows($j)

			$c_chromosome = $row.Cells(1).Text
			$c_region = $row.Cells(2).Text
			$c_type = $row.Cells(3).Text
			$c_reference = $row.Cells(4).Text
			$c_allele = $row.Cells(5).Text

			$matched = $v_chromosome -eq $c_chromosome -and $v_region -eq $c_region -and $v_type -eq $c_type -and $v_reference -eq $c_reference -and $v_allele -eq $c_allele
			if ($matched) {
				break
			}

			$j++
		}

		if (!$matched) {
			$unmatchedValidateForRows += @{
					sampleName = $sampleName
					chromosome = $v_chromosome 
					region = $v_region 
					type = $v_type 
					reference = $v_reference
					allele = $v_allele
				}
		}

		$i++
	}

	$i = 2
	while (![string]::IsNullOrEmpty($compareToSheet.Cells($i, 1).Text)) {

		$row = $compareToSheet.Rows($i)

		$c_chromosome = $row.Cells(1).Text
		$c_region = $row.Cells(2).Text
		$c_type = $row.Cells(3).Text
		$c_reference = $row.Cells(4).Text
		$c_allele = $row.Cells(5).Text

		$j = 2
		$matched = $false
		while (![string]::IsNullOrEmpty($validateForSheet.Cells($j, 1).Text)) {

			$row = $validateForSheet.Rows($j)

			$v_chromosome = $row.Cells(1).Text
			$v_region = $row.Cells(2).Text
			$v_type = $row.Cells(3).Text
			$v_reference = $row.Cells(4).Text
			$v_allele = $row.Cells(5).Text

			$matched = $v_chromosome -eq $c_chromosome -and $v_region -eq $c_region -and $v_type -eq $c_type -and $v_reference -eq $c_reference -and $v_allele -eq $c_allele
			if ($matched) {
				break
			}

			$j++
		}

		if (!$matched) {
			$unmatchedCompareToRows += @{
					sampleName = $sampleName
					chromosome = $c_chromosome 
					region = $c_region 
					type = $c_type 
					reference = $c_reference
					allele = $c_allele
				}
		}

		$i++
	}

	# clean up
	$validateForBook.close()
	$compareToBook.close()
	Remove-Variable 'validateForBook','validateForSheet','compareToBook','compareToSheet'

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

$validateForPercentFiles = Get-ChildItem -Path $validateForFolder -Filter "*%.xlsx" | Sort-Object
$validateForHotspotFiles = Get-ChildItem -Path $validateForFolder -Filter "*Hotspot.xlsx" | Sort-Object
$compareToPercentFiles = @("C*", "D*_*") | ForEach-Object{ Get-ChildItem -Path $compareToFolder -Directory -Filter $_} | Get-ChildItem -Filter "*%.xlsx" | Sort-Object
$compareToHotspotFiles = @("C*", "D*_*") | ForEach-Object{ Get-ChildItem -Path $compareToFolder -Directory -Filter $_} | Get-ChildItem -Filter "*Hotspot.xlsx" | Sort-Object

#******************************************************************************************
#*** VALIDATION ***
#******************************************************************************************

$excel = New-Object -ComObject Excel.Application

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

			$unmatchedValidateForRows, $unmatchedCompareToRows = Compare-Files $validateForFile $compareToFile $excel

			Write-Host "unmatchedValidateForRows"
			$unmatchedValidateForRows
			Write-Host "unmatchedCompareToRows"
			$unmatchedCompareToRows

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

$excel.quit() 
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()

