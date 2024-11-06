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
foreach($validateFile in $validateForPercentFiles) {

	$matched = $false
	$validateFileName = $validateFile.BaseName.SubString(0,$validateFile.BaseName.IndexOf(")") + 1)
	foreach($compareFile in $compareToPercentFiles) {

		$compareFileName = $compareFile.BaseName.SubString(0,$compareFile.BaseName.IndexOf(")") + 1)
		if ($compareFileName -ieq $validateFileName) {
			$matched = $true
		
			Write-Host "`nValidating for the following match:" -ForegroundColor Green

			$validateFile.FullName
			$validateBook = $excel.workbooks.open($validateFile.FullName)

			$compareFile.FullName
			$compareBook = $excel.workbooks.open($compareFile.FullName)

			# sleep for a bit
			Start-Sleep -Seconds 5

			$validateSheet = $validateBook.sheets(1)
			$compareSheet = $compareBook.sheets(1)

			# perform the validation
			$rowNumber = 2
			while (![string]::IsNullOrEmpty($validateSheet.cells($rowNumber, 1).text)) {
				
				$value = $validateSheet.cells($rowNumber, 1).text
				Write-Host 'the value is' $value

				$rowNumber++
			}

			# clean up
			$validateBook.close()
			$compareBook.close()

			break
		}
	}
	if ($matched -eq $false) {
    	Write-Host "`nWARNING:" $validateFileName "file was not matched"  -ForegroundColor Red
	}
	break
}

Remove-Variable 'validateBook','validateSheet','compareBook','compareSheet'
$excel.quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
[GC]::Collect()

