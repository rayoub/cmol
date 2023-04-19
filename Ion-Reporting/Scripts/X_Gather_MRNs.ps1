
$srl = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Sample Receipt Logs\Clinical Sample Receipt Log.xlsx"

# load srl
$excel = New-Object -ComObject Excel.Application
$book = $excel.workbooks.open($srl)
$sheet = $book.sheets("Oncomine Comp DNA RNA")

# output accn/mrn map
for ($i = 7; $i -lt 10000; $i++){

    $mrn = $sheet.cells($i,3).text().trim()
    $accn = $sheet.cells($i,4).text().trim()
    if ([String]::IsNullOrEmpty($mrn)){

        # no more rows
        break
    }

    Write-Host $accn $mrn
}

# clean up 
$book.close()
$excel.quit()
