Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# assume this script runs from the Heme directory

######################################################################################################
### GLOBALS
######################################################################################################

$baseDir = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Patient Reports\"
$sourceDir = $baseDir + "FLT3 ITD and TK\FLT3 ITD and TK to submit"
$submitDir = $baseDir + "NGS HEME\NGS HEME To Be Submitted"

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
    $form.Text = "Pdf Converter"
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

# gather directories that start with D 
$dirList = @(Get-ChildItem D* | Select-Object -ExpandProperty Name)
if ($dirList.length -eq 0) {
    Write-Host "No result directories found. Exiting.`n" -ForegroundColor Red
    exit
}

# select directories that start with D
$result, $selectedDirList = Get-Selected -DirList $dirList
if ($result -eq [System.Windows.Forms.DialogResult]::Abort) {
    Write-Host "Exiting.`n" -ForegroundColor Green
    exit
}

# load word app
$word = New-Object -ComObject Word.Application
$word.visible = $false

# iterate selected directories 
foreach($selectedDir in $selectedDirList){ 

    # get the cmol id
    $index = $selectedDir.IndexOf("_")
    $cmolId = $selectedDir.Substring(0, $index)

    $template = Get-ChildItem -Path -File $sourceDir -Filter "$cmolId*Letter Head*.docx" -Depth 1

    # continue if file does not exist
    if ($null -eq $template) {
        Write-Host "`nSkipping pdf conversion for: $selectedDir. A Letter Head word template does not exist." -ForegroundColor Red
        continue
    }

    # open template
    $formatPdf = 17
    $docName = ($submitDir + "\" + [System.IO.Path]::GetFileNameWithoutExtension($template.Name)) + ".pdf"

    # save as pdf 
    $doc = $word.documents.open($template.FullName, $false, $true)
    $doc.saveas($template, $formatPdf)
    $doc.close($false)

    # output 
    Write-Host Converted $template.Name to Pdf Format
}

# clean up<A
$word.quit()

Read-Host "`nPress enter to exit"