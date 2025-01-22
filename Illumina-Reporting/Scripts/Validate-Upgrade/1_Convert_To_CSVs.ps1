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

function Convert-ExcelToCsv ($file) {
    
    $x = $file | Select-Object Directory, BaseName
    $n = [System.IO.Path]::Combine($x.Directory, (($x.BaseName, 'csv') -join "."))
	if (Test-Path -Path $n -PathType Leaf) {
		Write-Host "$_ already exists"
	}
	else {
		$wb = $excel.workbooks.open($file.FullName)

		Write-Host "Saving $n"
		$wb.Worksheets(1).SaveAs($n, 6)

		$wb.close()
		Remove-Variable 'wb'
	}
}

# ******************************************************************************************
# *** SCRIPT ***
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

$allFiles = $validateForPercentFiles + $validateForHotspotFiles + $compareToPercentFiles + $compareToHotspotFiles


$excel = New-Object -ComObject Excel.Application

$allFiles | ForEach-Object {
	Convert-ExcelToCsv $_	
}

$excel.quit() 
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()


