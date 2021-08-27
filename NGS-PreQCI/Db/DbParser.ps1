
$fileFullNames = @(
    'C:\Users\r77755\Documents\git\Code\NGS\Data\NGS Results (001-261).xlsx',
    'C:\Users\r77755\Documents\git\Code\NGS\Data\NGS Results (262-584, Panc 003-040).xlsx',
    'C:\Users\r77755\Documents\git\Code\NGS\Data\NGS Results (585-, Panc 041- ).xlsx'
)

$excel = New-Object -ComObject Excel.Application
$bookOut = $excel.workbooks.open('C:\Users\r77755\Documents\git\Code\NGS\Db\FieldDefs.xlsx')
$sheetOut = $bookOut.sheets[1]

for($i = 1; $i -le $fileFullNames.Length; $i++){

    $fileFullName = $fileFullNames[$i - 1]
    Write-Host Processing $fileFullName
    $fileName = Split-Path -Path $fileFullName -Leaf 
    
    $bookIn = $excel.workbooks.open($fileFullName,0,$true)
    Start-Sleep -Seconds 5

    $sheetIn = $bookIn.sheets("Patient Sample Variant Lookup")

    $j = 1
    $sheetOut.cells($j,$i).value = $fileName

    $k = 0
    while ($true) {

        $k++
        $fieldName = $sheetIn.cells(2,$k).text.trim()
        if (-not [String]::IsNullOrEmpty($fieldName)) {
            $j++
            $sheetOut.cells($j,$i).value = $fieldName
        }
        else {
            break
        }
    }
    

    $bookIn.close($false)
}

$bookOut.save()
$bookOut.close()
$excel.quit()
