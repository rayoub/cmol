
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Get-FileName
{
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $PSScriptRoot
    $OpenFileDialog.filter = "Comma delimited (*.csv) | *.csv"
    $OpenFileDialog.Title = "Select CSV file to scrub"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

$file = Get-FileName
$done = Select-String -Path $file -Pattern ',"Patient Name:' -Quiet
if ($done) {
    Write-Host "`nFile has already been scrubbed." 
    Read-Host "Press enter to exit"
    exit
}

(Get-Content $file) `
	-replace ',(Patient Name:)', ',"$1' `
	-replace ',(MRN:)','",$1' `
	-replace ',(Authorizing Provider:)', ',"$1' `
	-replace ',(Ordering Provider:)','","$1' | 
	Set-Content $file
    
Write-Host "`nDone scrubbing file." -ForegroundColor Green
Read-Host "Press enter to exit"