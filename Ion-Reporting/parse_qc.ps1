
# load itextsharp dll
$dllPath = Join-Path $PSScriptRoot itextsharp.dll
Add-Type -LiteralPath $dllPath

# field names
$fieldNames = @(
'% BED region > threshold'
'% amplicons > threshold'
'Coverage Threshold'
'Total number of Reads'
'Total number of Bases\(Mbp\)'
'Total number of Bases\(AQ20\)\(Mbp\)'
'Mean Coverage Depth\(fold\)'
'Coverage within Target Region'
'Mean Read Length\(AQ20\)'
'Mean Read Length\(AQ30\)'
'Number of Homozygous SNVs'
'Number of Homozygous INDELs'
'Number of Heterozygous SNVs'
'Number of Homozygous MNVs'
'Number of Heterozygous MNVs'
'Number of Heterozygous INDELs'
'Ti/Tv Ratio \(SNPs\)'
'dbSNP concordance'
'Heterozygotes/Homozygotes'
'Indels/Total'
'Indels/kb'
'SNPs/kb'
'CNV/Total'
'LongDels/Total'
'Number of CNVs'
'Number of LongDels'
'MAPD'
'BRCA CNV QC'
'Fusions/Total'
'Number of Fusions'
'Total Mapped Fusion Panel Reads'
'Fusion Sample QC'
'Total Unmapped Reads'
'Average Read Length'
'POOL-1 Mapped Fusion Reads'
'POOL-2 Mapped Fusion Reads'
'POOL-1,2 Mapped Fusion Reads'
'Expression Controls Total Reads'
'POOL-1 Expression Control Total Reads'
'POOL-2 Expression Control Total Reads'
Coverage metrics
This section provides the sample name, barcode and coverage report information.
Sample Name
BarCode
Mapped Reads
On Target
Mean Depth
Uniformity
V005-DNA2_v1
IonCode_0102
31670988
90.95%
2339
94.17%

)


$reader = New-Object iTextSharp.text.pdf.pdfreader -ArgumentList (Join-Path $PSScriptRoot 'qc.pdf')
for ($page = 1; $page -le 2; $page++) {

    $lines = [char[]]$reader.GetPageContent($page) -join "" -split "`n"
    foreach ($line in $lines) {
        if ($line -match "Tm \[\((.*)\)\]") {   
            $matches[1]
           # $line = $line -replace "\\([\S])", $matches[1]
    #        $line -replace "^\[\(|\)\]TJ$", "" -split "\)\-?\d+\.?\d*\(" -join ""
           # $line
        }
    }
}