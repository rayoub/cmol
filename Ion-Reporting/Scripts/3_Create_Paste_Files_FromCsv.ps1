
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

######################################################################################################
### GLOBAL DEFINITION
######################################################################################################

$names = @(
    ''
    'Wei Zhang, MD, PhD',
    'Stephen Hyter, PhD',
    'Shivani Golem, PhD, FACMG',
    'Patrick Gonzales, PhD, FACMG, CG(ASCP)'
)

######################################################################################################
### INPUT FORMS
######################################################################################################

function Get-Name {
    param ([String] $cmolId)

    $dims = New-Object System.Drawing.Size(595,242) # width, height
    $padding = New-Object System.Windows.Forms.Padding(6)
    $font = New-Object System.Drawing.Font -ArgumentList 'GenericSanSerif', 12.5

    # create form
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "Create Paste Files for $cmolId"
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

######################################################################################################
### GATHER INPUT
######################################################################################################

$inputFile = Get-ChildItem -Filter *_Input_v?.xlsx | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: An Excel input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

# load input workbook
$excel = New-Object -ComObject Excel.Application
$inputBook = $excel.workbooks.open($inputFile.FullName)
$inputSheet = $inputBook.sheets(1)

# build hash-table of accession #/cmol id combos and patient rows from input workbook
$patientRows = @{} 
for ($i = 2; $i -lt 100; $i++){

    $text = $inputSheet.cells($i,1).text().trim()
    if ([String]::IsNullOrEmpty($text)){

        # no more rows
        break
    }

    # fill in hash-table
    $id = $inputSheet.cells($i, 9).text().trim() + "_" + $inputsheet.cells($i, 4).text().trim()
    $row = $inputSheet.rows($i)
    if ($patientRows.ContainsKey($id)) {

        # some reports may have multiple rows for a single accession #/cmol id combination
        $patientRows[$id] += $row
    }
    else {
        $patientRows.Add($id, @($row))
    }
}

# copy and populate templates
foreach($id in $patientRows.Keys){

    # create file 
    $fileName = ($id + ".txt")
    New-Item -Path . -Name $fileName -ItemType "file" -Force

    foreach($a in $patientRows[$id]) {

        # patient name
        $a.Columns("A").text.trim() + ", " + $a.Columns("B").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # provider name
        $provider = $a.Columns("R").text.trim()
        if (!$provider -eq "") {
            $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
            $provider = (($doctor, $a.Columns("S").text.trim(), $a.Columns("R").text.trim()) | 
                Where-Object {$_ -ne ""}) -join " "
        }
        $provider + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # cmol id        
        $cmolId = $a.Columns("I").text.trim()
        $cmolId + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # MRN
        $a.Columns("C").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # facility 
        $a.Columns("P").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # collection date
        $a.Columns("E").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # dob , sex 
        $a.Columns("F").text.trim() + ", " + $a.Columns("G").text.trim().toupper().substring(0,1) + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # pathoology id        
        $a.Columns("H").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # received date
        $a.Columns("K").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
    
        # name 
        $result, $selectedName = Get-Name 
        if ($result -eq [System.Windows.Forms.DialogResult]::Abort) {
            Write-Host "`nAborting the creation of paste files`n" -ForegroundColor Red
            $inputBook.close()
            $excel.quit()
            exit
        }
        $selectedName + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # report date
        (Get-Date -Format "M/d/yyyy") + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
    }
}

# clean up 
$inputBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"