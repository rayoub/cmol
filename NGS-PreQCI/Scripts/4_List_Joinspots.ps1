

function Get-Joinspots {
    param([String[]] $variants, [int] $position, [String] $refAllele, [String] $altAllele) 

    $REF_FIELD = 3
    $ALT_FIELD = 4
    $SAMP_FIELD = 9
  
    # someday may need to distinguish with chromosome number
    $lines = $variants | Select-String -Pattern $position

    $res = $null
    if ($null -ne $lines) {
        foreach ($line in $lines) {
            $fields = -split $line
            if ($fields.length -gt $SAMP_FIELD) {
                if ($fields[$REF_FIELD] -eq $refAllele -and $fields[$ALT_FIELD] -eq $altAllele) {
                    $samp = $fields[$SAMP_FIELD] -split ':'
                    $reads = $samp[2]
                    $count = ($samp[1] -split ',')[1]
                    $res = @{ Position = $position; Ref = $refAllele; Alt = $altAllele; Reads = $reads; Count = $count }
                    break
                }
            }
        }
    }
    $res
} 

$files = Get-ChildItem -Path . -Directory -Filter D*_* | Select-Object -ExpandProperty BaseName | Get-ChildItem -Filter *Joinspots*
foreach ($file in $files) {

    $variants = Get-Content  $file.FullName
    $table = @()
    
    # add joinspots here
    $table += Get-Joinspots -Variants $variants -Position 115258746 -RefAllele 'A' -AltAllele 'C'
    $table += Get-Joinspots -Variants $variants -Position 115258748 -RefAllele 'C' -AltAllele 'A'

    # remove nulls
    $table = $table | Where-Object { $null -ne $_ }

    # output joinspots for current directory
    Write-Host ($file.DirectoryName + "`n")
    if ($table.Count -eq 0) {
        Write-Host "No Joinspots`n" -ForegroundColor Green
    }
    else {
        Write-Host "Joinspots Present" -ForegroundColor Red
        $table | ForEach-Object { [PSCustomObject]$_ } | Format-Table -AutoSize -Property Position, Ref, Alt, Reads, Count
    }
}



