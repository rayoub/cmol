
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

######################################################################################################
### FUNCTION DEFINITIONS
######################################################################################################

function Get-FileName
{
    param([String] $initialDirectory)

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Variant Call File (*.vcf) | *.vcf"
    $OpenFileDialog.Title = "Select Variant Call File"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

######################################################################################################
### DO THE WORK
######################################################################################################

# get the VCF file
$dirName = Get-Location 
$file = Get-FileName -initialDirectory $dirName
if ([String]::IsNullOrEmpty($file)) {
    Write-Host "`nNo Vcf file selected. -ForegroundColor Red"
}
else {
    (Get-Content $file).Replace("NOCALL", "PASS").Replace("./.", "0/1") | Set-Content $file
    Write-Host "`nFile updated."
}

Read-Host "`nPress enter to exit"