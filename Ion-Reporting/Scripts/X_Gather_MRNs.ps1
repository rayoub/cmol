
# set locations 
$data = "E:\git\cmol\Cmol-Db\Data\Ion\"
$srlSrc = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Sample Receipt Logs\Clinical Sample Receipt Log.xlsx"
$srl = $data + "Clinical Sample Receipt Log.xlsx"
$map = $data + "mrnmap.csv"

# copy srl
Copy-Item $srlSrc $srl

& {

    # load srl
    $excel = New-Object -ComObject Excel.Application
    $book = $excel.workbooks.open($srl, $null, $true)
    $sheet = $book.sheets("Oncomine Comp DNA RNA")

    # output accn/mrn map
    if (Test-Path $map) {
        Remove-Item $map
    }
    for ($i = 7; $i -lt 10000; $i++){

        $mrn = $sheet.cells($i,3).text().trim()
        if (-not [String]::IsNullOrEmpty($mrn)) {
            $accn = $sheet.cells($i,4).text().trim()
            $line = $mrn + "," + $accn
            Add-Content -Path $map -Value $line
        }
    }

    # clean up 
    $book.close()
    $excel.quit()
}

[GC]::Collect()
