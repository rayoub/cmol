Add-Type -AssemblyName System.Windows.Forms

# ******************************************************************************************
# *** FUNCTIONS ***
# ******************************************************************************************

function Get-ValidateForFolder
{
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog 
    $dialog.SelectedPath = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Personal Data\Ayoub"
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
    $dialog.SelectedPath = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Assay Results\Clinical Data\NGS"
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
	while (![string]::IsNullOrEmpty($validateForSheet.cells($i, 1).text)) {

		$v = @(
			$sampleName,
			$validateForSheet.cells($i, 1).text,
			$validateForSheet.cells($i, 2).text,
			$validateForSheet.cells($i, 3).text,
			$validateForSheet.cells($i, 4).text,
			$validateForSheet.cells($i, 5).text
		)

		$j = 2
		$matched = $false
		while (![string]::IsNullOrEmpty($compareToSheet.cells($j, 1).text)) {

			$c = @(
				$sampleName,
				$compareToSheet.cells($j, 1).text,
				$compareToSheet.cells($j, 2).text,
				$compareToSheet.cells($j, 3).text,
				$compareToSheet.cells($j, 4).text,
				$compareToSheet.cells($j, 5).text
			)

			$matched = (Compare-Object $v $c).Length -eq 0
			if ($matched) {
				break
			}

			$j++
		}

		if (!$matched) {
			$unmatchedValidateForRows += $v
		}

		$i++
	}

	$i = 2
	while (![string]::IsNullOrEmpty($compareToSheet.cells($i, 1).text)) {

		$c = @(
			$sampleName,
			$compareToSheet.cells($i, 1).text,
			$compareToSheet.cells($i, 2).text,
			$compareToSheet.cells($i, 3).text,
			$compareToSheet.cells($i, 4).text,
			$compareToSheet.cells($i, 5).text
		)

		$j = 2
		$matched = $false
		while (![string]::IsNullOrEmpty($validateForSheet.cells($j, 1).text)) {

			$v = @(
				$sampleName,
				$validateForSheet.cells($j, 1).text,
				$validateForSheet.cells($j, 2).text,
				$validateForSheet.cells($j, 3).text,
				$validateForSheet.cells($j, 4).text,
				$validateForSheet.cells($j, 5).text
			)

			$matched = (Compare-Object $c $v).Length -eq 0
			if ($matched) {
				break
			}

			$j++
		}

		if (!$matched) {
			$unmatchedCompareToRows += $c		
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

#$validateForFolder = Get-ValidateForFolder
#if ($null -eq $validateForFolder) {
#   	Write-Host "`nEXITING: No validation folder selected." -ForegroundColor Red
#  	exit
#}
#
#$compareToFolder = Get-CompareToFolder
#if ($null -eq $compareToFolder) {
#   	Write-Host "`nEXITING: No comparison folder selected." -ForegroundColor Red
#  	exit
#}
#if (!$compareToFolder.toLower().endsWith("results")){
#   	Write-Host "`nERROR: You must select an NGS run 'results' folder to compare to." -ForegroundColor Red
#  	exit
#}
#
#$validateForPercentFiles = Get-ChildItem -Path $validateForFolder -Filter "*%.xlsx" | Sort-Object
#$validateForHotspotFiles = Get-ChildItem -Path $validateForFolder -Filter "*Hotspot.xlsx" | Sort-Object
#$compareToPercentFiles = @("C*", "D*_*") | ForEach-Object{ Get-ChildItem -Path $compareToFolder -Directory -Filter $_} | Get-ChildItem -Filter "*%.xlsx" | Sort-Object
#$compareToHotspotFiles = @("C*", "D*_*") | ForEach-Object{ Get-ChildItem -Path $compareToFolder -Directory -Filter $_} | Get-ChildItem -Filter "*Hotspot.xlsx" | Sort-Object

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

