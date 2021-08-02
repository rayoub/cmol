
$fileNames = Get-Content .\Review2020.txt

foreach($fileName in $fileNames) {

    if (-not (Test-Path $fileName)) {
        
        Write-Host $fileName
    }
}