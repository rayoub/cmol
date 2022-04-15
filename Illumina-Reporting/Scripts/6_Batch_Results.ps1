
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

######################################################################################################
### GLOBAL DEFINITION
######################################################################################################

$fields = @(
    'RUN ID',
    'Run Date',
    'CMOL ID',
    'MRN',
    'Accession',	
    'Panel',
    'Mean Coverage (ea sample)',
    'Chromosome',
    'Region',
    'Type',
    'Reference',
    'Allele',
    'Reference allele',
    'Count',
    'Coverage',
    'Frequency',
    'Average quality',
    'Gene',
    'Coding region change',
    'Amino acid change',
    'Amino acid change in longest transcript',
    'Coding region change in longest transcript',
    'Assessment',
    'Reportability',
    'Frequency',
    'Region',
    'Notes',
    'Exon',
    'cDNA variant change',
    'Amino acid change',
    'Tests ordered',
    'Chemistry',
    'Analysis by',
    'Analysis date',
    'Pathogenicity',
    'Transcript',
    'Primary diagnosis',
    'Last name',
    'First name',
    'Ordering facility',
    'Specimen type',
    'Surg path ID',
	'Short Dx',
	'Short Dx Description',
	'Primary or Secondary',
	'Transplant Status',
	'Metastatic To',
	'Relapse Status',
	'Cytogenetics'
)

######################################################################################################
### FUNCTION DEFINITIONS
######################################################################################################

# NONE

######################################################################################################
### INPUT FORMS
######################################################################################################

function Get-Selected {
    param ([String[]] $dirList)

    $dims = New-Object System.Drawing.Size(560,300) # width, height
    $padding = New-Object System.Windows.Forms.Padding(6)
    $font = New-Object System.Drawing.Font -ArgumentList 'GenericSanSerif', 12.5

    # create form
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "Batch Results"
    $form.Font = $font
    $form.ControlBox = $false
    $form.Size = $dims
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.SizeGripStyle = 'Hide'
    $form.StartPosition = "CenterScreen"
    $form.TopMost = $true

    # select label
    $selectText = New-Object System.Windows.Forms.Label 
    $selectText.Text = "Select Directories:"
    $selectText.AutoSize = $true
    $selectText.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left

    # select listbox
    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
    $listBox.Width = 375
    $listBox.Height = 200
    foreach ($dir in $dirList) {
        [void] $listBox.Items.Add($dir)
    }
    $listBox.SelectionMode = 'MultiExtended'
    $listBox.SelectedIndex = 0

    # ok button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = 'OK'
    $okButton.AutoSize = $true
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $okbutton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $form.AcceptButton = $okButton

    # exit button
    $exitButton = New-Object System.Windows.Forms.Button
    $exitButton.Text = 'Exit'
    $exitButton.AutoSize = $true
    $exitButton.DialogResult = [System.Windows.Forms.DialogResult]::Abort
    $exitButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right

    # table panel
    $table = New-Object System.Windows.Forms.TableLayoutPanel
    $table.RowCount = 2
    $table.ColumnCount = 2
    $table.AutoSize = $true
    $table.Padding = $padding

    # table first row
    $table.Controls.Add($selectText)
    $table.SetRow($selectText, 0)
    $table.SetColumn($selectText, 0)
    $table.Controls.Add($listBox)
    $table.SetRow($listBox, 0)
    $table.SetColumn($listBox, 1)

    # flow panel for bottom buttons
    $flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $flow.FlowDirection = [System.Windows.Forms.FlowDirection]::RightToLeft
    $flow.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $flow.Controls.Add($okButton)
    $flow.Controls.Add($exitButton)

    # table third row
    $table.Controls.Add($flow)
    $table.SetRow($flow, 1)
    $table.SetColumn($flow, 0)
    $table.SetColumnSpan($flow, 2)

    $form.Controls.Add($table)

    $form.ShowDialog()

    $listbox.SelectedItems
}

######################################################################################################
### DO THE WORK
######################################################################################################

# build list of directories that start with D
$dirList = @(Get-ChildItem D* | Select-Object -ExpandProperty Name)

if ($dirList.length -eq 0) {
    Write-Host "No result directories found. Exiting.`n" -ForegroundColor Red
    exit
}

$result, $selectedDirList = Get-Selected -DirList $dirList

if ($result -eq [System.Windows.Forms.DialogResult]::Abort) {
    Write-Host "Exiting.`n" -ForegroundColor Green
    exit
}

$excel = New-Object -ComObject Excel.Application

# create the batch results file
$batchBook = $excel.Workbooks.Add()
$batchSheet = $batchBook.Sheets(1)
$batchSheet.Name = 'Results'

# add the header row
for ($i = 0; $i -lt $fields.length; $i++){
    $batchSheet.Cells(1,$i + 1) = $fields[$i]
}

# keep track of row index
$batchIndex = 2

# iterate selected directories 
foreach($selectedDir in $selectedDirList){ 
    
    $resultFile = Get-ChildItem -Path . -Directory -Filter $selectedDir* | Select-Object -ExpandProperty BaseName | Get-ChildItem -Filter *.xlsm  | Select-Object -First 1

    # continue if file does not exist
    if ($null -eq $resultFile) {

        Write-Host "`nSkipping batching results for: $selectedDir. A results file does not exist." -ForegroundColor Red
        continue
    }

    $resultBook = $excel.workbooks.open($resultFile.FullName)

    Start-Sleep -Seconds 1

    if (-not $null -eq $resultBook) {

        $resultSheet = $resultBook.sheets("Result")

        Write-Host Processing $resultBook.Name -ForegroundColor Green

        # get header information
        $runId = $resultSheet.Cells(1,2).text.trim()
        $runDate = $resultSheet.Cells(2,4).text.trim()
        $cmolId = $resultSheet.Cells(1,4).text.trim()
        $MRN = "'" + $resultSheet.Cells(5,4).text.trim().padLeft(7,'0')
        $accession = $resultSheet.Cells(6,2).text.trim()
        $panel = $resultSheet.Cells(3,2).text.trim()
        $meanCoverage = $resultSheet.Cells(4,2).text.trim()
        $notes = $resultSheet.Cells(3,13).text.trim()
        if ([String]::IsNullOrEmpty($notes)) {
            $notes = $resultSheet.Cells(3,14).text.trim()
        }
        $notes = $notes -replace "\s+", " "
        $testOrdered = $resultSheet.Cells(1,13).text.trim()
        if ([String]::IsNullOrEmpty($testOrdered)) {
            $testOrdered = $resultSheet.Cells(1,14).text.trim()
        }
        $testOrdered = $testOrdered.replace(" NGS", ";")
        $chemistry = $resultSheet.Cells(4,4).text.trim()
        $analysisBy = $resultSheet.Cells(2,2).text.trim().toUpper()
        $analysisDate = $resultSheet.Cells(2,4).text.trim()
        $diagnosisG = $resultSheet.Cells(6,7).text.trim()
        $diagnosisH = $resultSheet.Cells(6,8).text.trim()
        $name = $resultSheet.Cells(5,2).text.trim() -split ','
        $lastName = $name[0].trim();
        $firstName = $name[1].trim();
        $facility = ""
        if ($name -match "CAP.*PT") {
            $facility = "CAP"
        }
        # "'" + padded MRN
        elseif ($MRN.length -eq 8) {
            $facility = "KUHA"
        }
        else {
            $facility = "KCVA"
        }
        $specimenType = $resultSheet.Cells(1,27).text.trim()
        $surgPathId = $resultSheet.Cells(2,27).text.trim()
		$cytogenetics = $resultSheet.Cells(6,13).text.trim()
		if ($cytogenetics -match "^\+") {
			$cytogenetics = "'" + $cytogenetics
		}
        
        # iterate result rows
        for ($i = 10; $i -lt 100; $i++){

            # get current result row
            $resultRow = $resultSheet.Rows($i)
          
            # check if row is a section header            
            if ($resultRow.MergeCells) {

                # no more rows
                break
            }

            # check if row is populated
            $chromosome = $resultRow.Columns("A").text.trim()
            if ([String]::IsNullOrEmpty($chromosome) -or $chromosome -eq 'CEBPA'){

                # no more rows
                break
            }

            # gather row specific values
            $region = $resultRow.Columns("B").text.trim()
            $type = $resultRow.Columns("C").text.trim()
            $reference = $resultRow.Columns("D").text.trim()
            $allele = $resultRow.Columns("E").text.trim()
            $referenceAllele = $resultRow.Columns("F").text.trim()
            $count = $resultRow.Columns("G").text.trim()
            $coverage = $resultRow.Columns("H").text.trim()
            $frequency = $resultRow.Columns("I").text.trim()
            $averageQuality = $resultRow.Columns("J").text.trim()
            $gene = $resultRow.Columns("K").text.trim()
            $codingChange = $resultRow.Columns("L").text.trim()
            $aminoChange = $resultRow.Columns("M").text.trim()
            $aminoChangeLongest = $resultRow.Columns("N").text.trim()
            $codingChangeLongest = $resultRow.Columns("O").text.trim()
            $assessment = $resultRow.Columns("P").text.trim()
            $frequency2 = $resultRow.Columns("R").text.trim()
            $region2 = $chromosome + ": " + $region.replace("..", "_") + " " + $reference + "/" + $allele
            $pathogenicity = $resultRow.Columns("T").text.trim()
            $exonDNP = $resultRow.Columns("U").text.trim()
            $variantChangeDNP = $resultRow.Columns("V").text.trim()
            $aminoChangeDNP = $resultRow.Columns("W").text.trim()
            $transcript = $resultRow.Columns("Z").text.trim()
            if (-not [String]::IsNullOrEmpty($transcript)) {
                $transcript = ($transcript -split ' ')[0]
            }
            $codingChangeUD = $resultRow.Columns("AA").text.trim()
            $aminoChangeUD = $resultRow.Columns("AB").text.trim()
            $exonUD = $resultRow.Columns("AC").text.trim()
           
            # reportability logic
            $reportability = $resultRow.Columns("Q").text.trim()
            if ($notes -contains "Cancel") {
                $reportability = "C"
            }
            elseif ($notes -contains "Repeat") {
                $reportability = "R"
            }
            elseif ($gene -ieq 'none'){
                $reportability = "Y"
            }
            elseif ($notes -contains "Artifact") {
                $reportability = "A"
            }
            elseif ($frequency2 -contains 'Second') {
                $reportability = "S"
            }
            elseif ($reportability -eq "Reportable") {
                $reportability = "Y"
            }
            else {
                $reportability = "N"
            }

            # add redundant headers to batch row start
            $batchSheet.Cells($batchIndex, 1).Value = $runId
            $batchSheet.Cells($batchIndex, 2).Value = $runDate
            $batchSheet.Cells($batchIndex, 3).Value = $cmolId
            $batchSheet.Cells($batchIndex, 4).Value = $MRN
            $batchSheet.Cells($batchIndex, 5).Value = $accession
            $batchSheet.Cells($batchIndex, 6).Value = $panel
            $batchSheet.Cells($batchIndex, 7).Value = $meanCoverage

            # add row specific columns (redundant interspersed)
            $batchSheet.Cells($batchIndex, 8).Value = $chromosome
            $batchSheet.Cells($batchIndex, 9).Value = $region
            $batchSheet.Cells($batchIndex, 10).Value = $type
            $batchSheet.Cells($batchIndex, 11).Value = $reference
            $batchSheet.Cells($batchIndex, 12).Value = $allele
            $batchSheet.Cells($batchIndex, 13).Value = $referenceAllele
            $batchSheet.Cells($batchIndex, 14).Value = $count
            $batchSheet.Cells($batchIndex, 15).Value = $coverage
            $batchSheet.Cells($batchIndex, 16).Value = $frequency
            $batchSheet.Cells($batchIndex, 17).Value = $averageQuality
            $batchSheet.Cells($batchIndex, 18).Value = $gene
            $batchSheet.Cells($batchIndex, 19).Value = $codingChange
            $batchSheet.Cells($batchIndex, 20).Value = $aminoChange
            $batchSheet.Cells($batchIndex, 21).Value = $aminoChangeLongest
            $batchSheet.Cells($batchIndex, 22).Value = $codingChangeLongest
            $batchSheet.Cells($batchIndex, 23).Value = $gene + ": " + $assessment
            $batchSheet.Cells($batchIndex, 24).Value = $reportability  
            $batchSheet.Cells($batchIndex, 25).Value = $frequency2  
            $batchSheet.Cells($batchIndex, 26).Value = $region2
            $batchSheet.Cells($batchIndex, 27).Value = $notes
            if ([String]::IsNullOrEmpty($exonDNP)){
                $batchSheet.Cells($batchIndex, 28).Value = $exonUD
            }
            else {
                $batchSheet.Cells($batchIndex, 28).Value = $exonDNP
            }
            if ([String]::IsNullOrEmpty($variantChangeDNP)){
                $batchSheet.Cells($batchIndex, 29).Value = $codingChangeUD
            }
            else {
                $batchSheet.Cells($batchIndex, 29).Value = $variantChangeDNP
            }
            if ([String]::IsNullOrEmpty($aminoChangeDNP)){
                $batchSheet.Cells($batchIndex, 30).Value = $aminoChangeUD
            }
            else {
                $batchSheet.Cells($batchIndex, 30).Value = $aminoChangeDNP
            }
            $batchSheet.Cells($batchIndex, 31).Value = $testOrdered
            $batchSheet.Cells($batchIndex, 32).Value = $chemistry  
            $batchSheet.Cells($batchIndex, 33).Value = $analysisBy  
            $batchSheet.Cells($batchIndex, 34).Value = $analysisDate  
            if ($gene -ieq 'none'){
                $batchSheet.Cells($batchIndex, 35).Value = "Not Detected"
            }
            else {
                $batchSheet.Cells($batchIndex, 35).Value = $pathogenicity
            }
            $batchSheet.Cells($batchIndex, 36).Value = $transcript

            # add redundant headers to batch row end
            if ([String]::IsNullOrEmpty($diagnosisH)) {
                $batchSheet.Cells($batchIndex, 37).Value = $diagnosisG
            }
            else {
                $batchSheet.Cells($batchIndex, 37).Value = $diagnosisH
            }
            $batchSheet.Cells($batchIndex, 38).Value = $lastName  
            $batchSheet.Cells($batchIndex, 39).Value = $firstName  
            $batchSheet.Cells($batchIndex, 40).Value = $facility  
            $batchSheet.Cells($batchIndex, 41).Value = $specimenType  
            $batchSheet.Cells($batchIndex, 42).Value = $surgPathId
			$batchSheet.Cells($batchIndex, 49).Value = $cytogenetics

            $batchIndex++
        }

        $resultBook.close($false)
    }
}

# clean up 
$batchBook.saveAs((Join-Path $PSScriptRoot "Batch Results"))
$batchBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"
