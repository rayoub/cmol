Add-Type -AssemblyName System.Windows.Forms

# ******************************************************************************************
# *** FUNCTIONS ***
# ******************************************************************************************

function Get-FolderForConversion
{
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.SelectedPath = "C:\CompareResults"
	$dialog.ShowNewFolderButton = $false
    $dialog.Description = "Select Folder for Conversion of Excel Files to CSV"
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

$folderForConversion = Get-FolderForConversion
if ($null -eq $folderForConversion) {
   	Write-Host "`nEXITING: No folder for conversion selected." -ForegroundColor Red
  	exit
}

#$convertPercentFiles = @('C*', 'D*', '??BH-*') | ForEach-Object{ Get-ChildItem -Path $folderForConversion -Directory -Filter $_} | Get-ChildItem -Filter "*%.xlsx" | Sort-Object
#$convertHotspotFiles = @('C*', 'D*', '??BH-*') | ForEach-Object{ Get-ChildItem -Path $folderForConversion -Directory -Filter $_} | Get-ChildItem -Filter "*Hotspot.xlsx" | Sort-Object

$convertPercentFiles = @('C*%.xlsx', 'D*%.xlsx', '??BH-*%.xlsx') | ForEach-Object{ Get-ChildItem -Path $folderForConversion -Recurse -File -Filter $_} | Get-ChildItem -Filter "*%.xlsx" | Sort-Object
$convertHotspotFiles = @('C*Hotspot.xlsx', 'D*Hotspot.xlsx', '??BH-*Hotspot.xlsx') | ForEach-Object{ Get-ChildItem -Path $folderForConversion -Recurse -File -Filter $_} | Get-ChildItem -Filter "*Hotspot.xlsx" | Sort-Object

$allFiles = $convertPercentFiles + $convertHotspotFiles 

$excel = New-Object -ComObject Excel.Application

$allFiles | ForEach-Object {
	Convert-ExcelToCsv $_	
}

$excel.quit() 
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()


