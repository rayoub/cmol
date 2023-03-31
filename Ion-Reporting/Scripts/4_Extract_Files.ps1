
# extract files from zip
$dirNames = Get-ChildItem . -Directory -Filter D*_* | Select-Object -ExpandProperty BaseName
foreach($dirName in $dirNames){

    $zipFile = Get-ChildItem -Path $dirName -Filter *.zip | Select-Object -First 1
    if ($null -eq $zipFile){
        Write-Host "`nWARNING: A zip file was not found in the $dirName directory." -ForegroundColor Red
        continue
    }
    Write-Host "`nProcessing the zip file in the $dirName directory.`n"
    
    $path = $PSScriptRoot + "\" + $dirName 
    $shell = New-Object -com shell.application
    $folder = $shell.namespace($zipfile.FullName + "\Variants").items() | Select-Object -first 1
    $files = $shell.namespace($zipfile.FullName + "\Variants\" + $folder.Name).items() | Where-Object { $_.Name -like "*.tsv"}
    foreach($file in $files) {

        Write-Host "Extracting" $file.Name
        $shell.namespace($path).copyhere($file, 16)
    }
} 

Read-Host "`nPress enter to exit"