
$summaryFiles = Get-Content Review2018.txt

$excel = New-Object -ComObject Excel.Application

# iterate through summary files
$data = New-Object -TypeName System.Collections.ArrayList 
foreach($file in $summaryFiles[3,5,100,124]){

    $book = $excel.workbooks.open($file,0,$true)
    
    # wait for it to open
    Start-Sleep -Seconds 5

    $sheet = $book.sheets("Result")
  
    # init info
    $info = @{
        "FileName" = $file
    }

    # get info common to all panels
    foreach($def in $panelHeaderDefs) {
       $info[$def.Name] = $sheet.cells($def.Row, $def.Column).text.trim() 
    }

    # get panel specific header defs
    $panel = $info["Panel"]
    if ($panel -ilike "*heme*") {
        $headerDefs = $hemeHeaderDefs
    }
    elseif ($panel -ilike "*common*") {
        $headerDefs = $commonHeaderDefs
    }
    elseif ($panel -ilike "*comp*") {
        $headerDefs = $compHeaderDefs
    }
    else {
        Write-Host "`nInvalid Panel: $panel" -ForegroundColor Red
        continue
    }
       
    # get panel specific info
    foreach($headerDef in $headerDefs) {
        $info[$headerDef.Name] = ($sheet.cells($headerDef.Row, $headerDef.Column).text.trim() -split '\s+') -join ' '
    }

    "------------------------------------------------------------"
    $info.values -join ','

    # don't save changes
    $book.close($false)
}

$excel.quit()