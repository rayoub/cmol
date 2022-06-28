
$baseDir = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Patient Reports\"
$sourceDir = $baseDir + "FLT3 ITD and TK\FLT3 ITD and TK to submit"
$submitDir = $baseDir + "NGS HEME\NGS HEME To Be Submitted"

Write-Host ("Checking the source directory " + $sourceDir)

$docFiles = Get-ChildItem -Path $sourceDir -Filter "*Letter Head*.docx" -Depth 1
if ($null -eq $docFiles ){
    Write-Host "`nERROR: 'Letter Head' Word templates were not found in the source directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load word app
$word = New-Object -ComObject Word.Application
$word.visible = $false

foreach($docFile in $docFiles){

    # open template
    $formatPdf = 17
    $docName = ($submitDir + "\" + [System.IO.Path]::GetFileNameWithoutExtension($docFile.Name)) + ".pdf"

    # save as pdf 
    $doc = $word.documents.open($docFile.FullName, $false, $true)
    $doc.saveas($docName, $formatPdf)
    $doc.close($false)

    # output 
    Write-Host Converted $docFile.Name to Pdf Format
}

# clean up
$word.quit()

Read-Host "`nPress enter to exit"