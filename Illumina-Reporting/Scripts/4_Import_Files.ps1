
# copy the result files to directories
$dirNames = Get-ChildItem . -Directory -Filter *BH*-* | Select-Object -ExpandProperty BaseName
foreach($dirName in $dirNames){

    $matchedFiles = Get-ChildItem . -File -Filter ($dirName + "*")
    foreach($matchedFile in $matchedFiles){
        Write-Host ("Copying " + $matchedFile.Name + "`n`tto $dirName directory")
        Move-Item -Path $matchedFile.FullName -Destination ("$dirName\") -Force
    }
    Write-Host "`n"
}

# create excel application
$excel = New-Object -ComObject Excel.Application

$excelFiles = Get-ChildItem -Path . -Directory -Filter BH*_* | Select-Object -ExpandProperty BaseName | Get-ChildItem -Filter *.xlsm 
foreach($excelFile in $excelFiles){

    Write-Host ("Importing data for " + $excelFile.Name + "`n")

    $book = $excel.Workbooks.Open($excelFile.FullName)

    Start-Sleep -Seconds 5

    # populate from the result files 
    $macroName = "ResultPopulate"
    $excel.Run($macroName)

    Start-Sleep -Seconds 5

    # clean up empty rows on the result tab
    $macroName = "Clean"
    $excel.Run($macroName)
    
    Start-Sleep -Seconds 1

    # clean up
    $book.Save()
    $book.Close()
}

# clean up 
$excel.Quit()

Read-Host "`nPress enter to exit"