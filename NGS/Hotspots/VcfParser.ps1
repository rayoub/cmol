

function Get-Status {
    param([int] $position, [String] $refAllele, [String] $altAllele) 

    $REF_FIELD = 3
    $ALT_FIELD = 4
    $SAMP_FIELD = 9
    
    $lines = Select-String -Path ./variants.vcf -Pattern $position

    $res = $null
    if ($null -ne $lines6 -and $null -ne $lines8) {
        foreach ($line in $lines) {
            $fields = -split $line
            if ($fields.length -gt $SAMP_FIELD) {
                if ($fields[$REF_FIELD] -eq $refAllele -and $fields[$ALT_FIELD] -eq $altAllele) {
                    $samp = $fields[$SAMP_FIELD] -split ':'
                    $alts = ($samp[1] -split ',')[1]
                    $reads = $samp[2]
                    $res = $position, $refAllele, $altAllele, $alts, $reads
                    break
                }
            }
        }
    }
    $res
} 

# get counts for specific variants
$status6 = Get-Status -Position 115258746 -RefAllele 'A' -AltAllele 'C'
$status8 = Get-Status -Position 115258748 -RefAllele 'C' -AltAllele 'A'

# report counts
if ($null -eq $status6 -and $null -eq $status8) {

    Write-Host "Something bad happened!"
}
else {

    Write-Host $status6 
    Write-Host $status8 
}