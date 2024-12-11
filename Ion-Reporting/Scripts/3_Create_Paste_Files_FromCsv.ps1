
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

######################################################################################################
### DEFINITION
######################################################################################################

$names = @(
    ''
    'Wei Zhang, MD, PhD',
    'Stephen Hyter, PhD',
    'Shivani Golem, PhD, FACMG',
    'Patrick Gonzales, PhD, FACMG, CG(ASCP)'
)

######################################################################################################
### FUNCTIONS
######################################################################################################

function Get-Name {
    param ([String] $sampleID)

    $dims = New-Object System.Drawing.Size(595,242) # width, height
    $padding = New-Object System.Windows.Forms.Padding(6)
    $font = New-Object System.Drawing.Font -ArgumentList 'GenericSanSerif', 12.5

    # create form
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "Create Paste File for " + $sampleID
    $form.Font = $font
    $form.ControlBox = $false
    $form.Size = $dims
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.SizeGripStyle = 'Hide'
    $form.StartPosition = "CenterScreen"
    $form.TopMost = $true

    # labels
    $nameText = New-Object System.Windows.Forms.Label
    $nameText.Text = "Name:"
    $nameText.AutoSize = $true
    $nameText.Anchor = [System.Windows.Forms.AnchorStyles]::Left

    # name combobox
    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $comboBox.Anchor = [System.Windows.Forms.AnchorStyles]::Right
    $comboBox.Width = 375
    foreach ($name in $names) {
        [void] $comboBox.Items.Add($name)
    }
    $comboBox.SelectedIndex = 0

    # ok button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = 'OK'
    $okButton.AutoSize = $true
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $okbutton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $form.AcceptButton = $okButton

    # abort button
    $abortButton = New-Object System.Windows.Forms.Button
    $abortButton.Text = 'Abort'
    $abortButton.AutoSize = $true
    $abortButton.DialogResult = [System.Windows.Forms.DialogResult]::Abort
    $abortButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right

    # table panel
    $table = New-Object System.Windows.Forms.TableLayoutPanel
    $table.RowCount = 2
    $table.ColumnCount = 2
    $table.AutoSize = $true
    $table.Padding = $padding

    # row styles
    $rowStyle1 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    $rowStyle2 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    [void] $table.RowStyles.Add($rowStyle1)
    [void] $table.RowStyles.Add($rowStyle2)

    # table first row
    $table.Controls.Add($nameText)
    $table.SetRow($nameText, 0)
    $table.SetColumn($nameText, 0)
    $table.Controls.Add($comboBox)
    $table.SetRow($comboBox, 0)
    $table.SetColumn($comboBox, 1)

    # flow panel for bottom buttons
    $flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $flow.FlowDirection = [System.Windows.Forms.FlowDirection]::RightToLeft
    $flow.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $flow.Controls.Add($okButton)
    $flow.Controls.Add($abortButton)

    # table bottom row
    $table.Controls.Add($flow)
    $table.SetRow($flow, 1)
    $table.SetColumn($flow, 0)
    $table.SetColumnSpan($flow, 2)

    $form.Controls.Add($table)

    $form.ShowDialog()

    $names[$comboBox.SelectedIndex]
}

function Get-StringField {
    param ([String] $fieldValue)

    if (-not [String]::isNullOrEmpty($fieldValue) -and $fieldValue.contains(":")) {
        ($fieldValue -split ":")[1]
    }
    else {
        $fieldValue
    }
}

function Get-DateField {
    param ([String] $fieldValue)

    if (-not [String]::isNullOrEmpty($fieldValue) -and $fieldValue.contains(":")) {
        if ($fieldValue.endsWith("M")) {
            $fieldValue = $fieldValue.substring(0, $fieldValue.LastIndexOf("/"))
        }
        $fieldValue = ($fieldValue -split ":")[1]
        Get-Date -Date $fieldValue -Format 'yyyy-MM-dd'
    }
    else {
        $fieldValue
    }
}

function Get-CsvFileName
{
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $PSScriptRoot
    $OpenFileDialog.filter = "Comma delimited (*.csv) | *.csv"
    $OpenFileDialog.Title = "Select CSV file"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

######################################################################################################
### DO THE WORK
######################################################################################################

$suffix = "-Comprehensive Plus Assay Summary Result.docx"
$submitDir = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Patient Reports\NGS Comprehensive Plus\Comprehensive Plus To Be Submitted"

$inputFile = Get-CsvFileName
if ([String]::IsNullOrEmpty($inputFile)) {
    Write-Host "`nERROR: No CSV file was selected" -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input csv 
$header = 'Ignore','SampleID','PatientName','MRN','SEX','DOB','Type','Collection','Received','DNAConcentration','DNAPurity',
    'RNA','RNAPurity','AuthorizingProvider','OrderingProvider', 'Facility','Comments','Ignore2','Ignore3','DNAPurity2'
$inputCsv = Import-Csv -Path $inputFile -Header $header

# build hash-table of accession #/cmol id combos and patient rows from input csv
$patientRows = @{} 
foreach ($row in $inputCsv) {

    $sampleID = Get-StringField $row.SampleID
    if ([String]::IsNullOrEmpty($sampleID)){

        # no more rows
        break
    }

    # fill in hash-table
    $dirName = $sampleID  + "-" + (Get-StringField $row.PatientName)
    if ($patientRows.ContainsKey($dirName)) {

        # some reports may have multiple rows for a single accession #/cmol id combination
        $patientRows[$dirName] += $row
    }
    else {
        $patientRows.Add($dirName, @($row))
    }
}

# load word app
$word = New-Object -ComObject Word.Application
$word.Visible = $false

# create word docs
foreach($dirName in $patientRows.Keys){

    Write-Host "Processing $dirName"

    # path name for report
    $pathName = $submitDir + "\" + $dirName 

    # create path if it doesn't already exist
    if (!(Test-Path -Path $pathName)){
        mkdir $pathName
    }
    
    $doc = $word.documents.add()

    $row = $patientRows[$dirName][0]

    # parse fields
    $patientName = Get-StringField $row.PatientName
    $MRN = Get-StringField $row.MRN
    $DOB = Get-DateField $row.DOB
    $sex = Get-StringField $row.SEX
    $sampleID = Get-StringField $row.SampleID
    $provider = Get-StringField $row.AuthorizingProvider
    $facility = Get-StringField $row.Facility
    $collectionDate = Get-DateField $row.Collection
    $receivedDate = Get-DateField $row.Received
    
    # name 
    $result, $selectedName = Get-Name $sampleID
    if ($result -eq [System.Windows.Forms.DialogResult]::Abort) {
        Write-Host "`nAborting the creation of paste files`n" -ForegroundColor Red
        $word.quit()
        exit
    }

    # build text
    $text = "" + 
        $patientName + "`v" + "`v" +
        $provider + "`v" + "`v" +
        $sampleID + "`v" + "`v" +
        $MRN + "`v" +"`v" +
        $facility + "`v" + "`v" +
        $collectionDate + "`v" + "`v" +
        $DOB + ", " + $sex.toupper().substring(0,1) + "`v" + "`v" +
        "[surgepath_id]" + "`v" + "`v" +
        $receivedDate + "`v" + "`v" +
        $selectedName + "`v" + "`v" +
        (Get-Date -Format "M/d/yyyy") + "`v"

    # output text
    $selection = $word.Selection
    $selection.TypeText($text)
    $selection.TypeParagraph()
        
    # save template
    $doc.saveas($pathName + "\" + $dirName + $suffix) 

    # clean up
    $doc.close()
}

# clean up
$word.quit()

#Write-Host "`nDone writing documents to:" $submitDir -ForegroundColor Green
Read-Host "`nPress enter to exit"