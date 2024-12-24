
$genes = @(
	'ABL1',
	'ANKRD26',
	'ASXL1',
	'BCR',
	'BLM',
	'BRAF',
	'CALR',
	'CBL',
	'CEBPA',
	'CSF3R',
	'CUX1',
	'DDX41',
	'DNMT3A',
	'ELANE',
	'ETNK1',
	'ETV6',
	'EZH2',
	'FBXW7',
	'FLT3',
	'GATA2',
	'IDH1',
	'IDH2',
	'IKZF1',
	'JAK2',
	'KIT',
	'KRAS',
	'MPL',
	'MYD88',
	'NF1',
	'NOTCH1',
	'NPM1',
	'NRAS',
	'PAX5',
	'PDGFRA',
	'PTPN11',
	'RUNX1',
	'SETBP1',
	'SF3B1',
	'SH2B3',
	'SRP72',
	'SRSF2',
	'STAG2',
	'STAT3',
	'TERC',
	'TERT',
	'TET2',
	'TP53',
	'U2AF1',
	'WT1',
	'ZRSR2'
)

$currentDir = Get-Location | Split-Path -Leaf
if ($currentDir -ne "results"){
    Write-Host "`nERROR: You must be in a 'results' folder to run this script." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
   exit
}

$header = "Chromosome","Region","Name","RegionLen","RegionLenAbove100","PercentRegionAbove100","ReadCount","BaseCount","GCPercent",
"MinCoverage","MaxCoverage","MeanCoverage","MedianCoverage","ZeroCoverageBases","MeanCoverageExclude0","MedianCoverageExclude0"

$inputFiles = Get-ChildItem -Path . -Directory -Filter *BH*-* | Select-Object -ExpandProperty BaseName | Get-ChildItem -Filter *Per-region*.csv
foreach ($inputFile in $inputFiles) {

	$reportType = (Read-Host "Enter the report type (Heme141|Heme50) for" $inputFile.Directory.Name).Trim()

	# import csv file
	$inputCsv = Import-Csv -Path $inputFile.FullName -Header $header | Where-Object { $_.PercentRegionAbove100 -ne '100' -and $_.Name -ne 'Name' } | Sort-Object Name

	$filteredGenes = @()
	foreach ($row in $inputCsv) {

		if ($reportType -ieq 'Heme50') {
			if ($genes -contains $row.Name) {
				$filteredGenes += $row.Name
			}
		}
		else {
			$filteredGenes += $row.Name
		}
	}
	$filteredGenes = $filteredGenes | Select-Object -Unique
	$boilerPlate = 'Genes tested with one or more targeted regions of low sequencing coverage: '
	$filteredGenesStr = $boilerPlate + [System.String]::Join(", ", $filteredGenes)
	$filteredGenesStr | Out-File -FilePath (Join-Path $inputFile.Directory "LowCoverageRegions.txt")

	Write-Host "The low-coverage regions have been successfully written to a file for" $inputFile.Directory.Name -ForegroundColor Green
}

Read-Host "`nPress enter to exit"








