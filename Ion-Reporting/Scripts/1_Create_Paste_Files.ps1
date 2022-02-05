
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

######################################################################################################
### GLOBAL DEFINITION
######################################################################################################

$available = @(
    '',
    'Acute idiopathic thrombocytopenic purpura',
    'Acute leukemia',
    'Acute lymphoblastic leukemia',
    'Acute monocytic leukemia',
    'Acute myeloid leukemia',
    'Acute myelomonocytic leukemia',
    'Acute promyelocytic leukemia',
    'Adenocarcinoma',
    'Adenoid cystic carcinoma',
    'Adenosarcoma of cervix',
    'Ampullary carcinoma',
    'Amyloidosis',
    'Anaplastic large cell lymphoma',
    'Anaplastic thyroid carcinoma',
    'Anemia',
    'Angiomyolipoma',
    'Angiosarcoma of breast',
    'Aplastic anemia',
    'Appendiceal carcinoma',
    'Appendix cancer',
    'Autoimmune hemolytic anemia',
    'B-cell acute lymphoblastic leukemia',
    'B-cell lymphoma',
    'B-cell neoplasm',
    'B-cell non-hodgkins lymphoma',
    'B-cell non-Hodgkins lymphoma',
    'B-cell prolymphocytic leukemia',
    'Bacteremia',
    'Bladder cancer',
    'Bladder carcinoma',
    'Blastic plasmacytoid dendritic cell neoplasm',
    'Bone tumor',
    'Brain cancer',
    'Brain carcinoma',
    'Breast adenocarcinoma',
    'Breast cancer',
    'Breast carcinoma',
    'Cancer',
    'Carcinoma',
    'Cecal adenocarcinoma',
    'Cecum cancer',
    'Cerebellar tumor',
    'Cholangiocarcinoma',
    'Cholangiosarcoma',
    'Chondrosarcoma',
    'Choroid melanoma',
    'Chronic idiopathic thrombocytopenic purpura',
    'Chronic lymphocytic leukemia',
    'Chronic lymphoproliferative disease',
    'Chronic myeloid leukemia',
    'Chronic myeloid neoplasm',
    'Chronic myelomonocytic leukemia',
    'Chronic neutropenia',
    'Clear cell renal cell carcinoma',
    'Clear cell sarcoma',
    'CNS lymphoma',
    'Colon adenocarcinoma',
    'Colon cancer',
    'Colorectal',
    'Colorectal adenocarcinoma',
    'Colorectal cancer',
    'Colorectal carcinoma',
    'Copper deficiency',
    'Cryoglobulinemia',
    'Cutaneous T-cell lymphoma',
    'Cytopenia',
    'Desmoplastic small round cell tumor',
    'Diamond blackfan anemia',
    'Diffuse large B-cell lymphoma',
    'Duodenal adenocarcinoma',
    'Dyskeratosis congenita',
    'Endometrial carcinoma',
    'Eosinophilia',
    'Epithelioid hemangioendothelioma',
    'Epithelioid sarcoma',
    'Erythrocytosis',
    'Esophageal adenocarcinoma',
    'Esophageal cancer',
    'Esophageal squamous cell carcinoma',
    'Essential thrombocythemia',
    'Essential thrombocytopenia',
    'Essential thrombocytosis',
    'Ewings sarcoma',
    'Extranodal marginal zone lymphoma',
    'Follicular dendritic cell sarcoma',
    'Follicular lymphoma',
    'Follicular non-Hodgkins lymphoma',
    'Follicular thyroid carcinoma',
    'Gastroesophageal neoplasm',
    'GATA2 deficiency',
    'GIST',
    'Glioblastoma',
    'Glioma',
    'Hairy cell leukemia',
    'Hemangiopericytoma',
    'Hematologic disorder',
    'Hematologic malignancies',
    'Hematologic neoplasm',
    'Hemochromatosis',
    'Hemophagocytic lymphohistiocytosis',
    'Hepatic carcinoma',
    'Hepatocholangiocarcinoma',
    'Hepatosplenic T-cell lymphoma',
    'Hodgkins lymphoma',
    'Hurthle cell carcinoma',
    'Hypereosinophilia',
    'Hypereosinophilic syndrome',
    'Idiopathic aplastic anemia',
    'Idiopathic hypereosinophilic syndrome',
    'Idiopathic thrombocytopenia purpura',
    'Idiopathic thrombocytopenic purpura',
    'Immune thrombocytopenia',
    'Intrahepatic cholangiocarcinoma',
    'Iron deficiency anemia',
    'Jejunal adenocarcinoma',
    'Langerhans cell histiocytosis',
    'Large granular lymphocytic leukemia',
    'Laryngeal carcinoma',
    'Leiomyosarcoma',
    'Leukocytosis',
    'Leukopenia',
    'Liposarcoma',
    'Liver adenocarcinoma',
    'Lung adenocarcinoma',
    'Lung cancer',
    'Lung carcinoma', 
    'Lymphoadenopathy',
    'Lymphoblastic leukemia',
    'Lymphoblastic lymphoma',
    'Lymphocytopenia',
    'Lymphocytosis',
    'Lymphoma',
    'Lymphomatoid granulomatosis',
    'Lymphopenia',
    'Lymphoplasmacytic lymphoma',
    'Macrocytic anemia',
    'Macrocytosis',
    'Malignant gastrointestinal stromal tumor',
    'Malignant neoplasm',
    'Malignant neoplasm of stomach',
    'MALT lymphoma',
    'Mammary adenocarcinoma',
    'Mantle cell lymphoma',
    'Marginal zone lymphoma',
    'Mast cell activation syndrome',
    'Mast cell disease',
    'Mast cell disorder',
    'Mast cell leukemia',
    'Mastocytosis',
    'MDS/MPN',
    'Melanoma',
    'Mesothelioma',
    'Metastatic breast cancer',
    'Metastatic carcinoma',
    'Metastatic colonic adenocarcinoma',
    'Metastatic lung adenocarcinoma',
    'MGUS',
    'Mixed phenotype acute leukemia',
    'Mixed phenotype leukemia',
    'Monoclonal B-cell lymphocytosis',
    'Monoclonal gammopathy',
    'Monocytosis',
    'MPNST',
    'Myelodysplastic syndrome',
    'Myelofibrosis',
    'Myeloid neoplasm',
    'Myeloid sarcoma',
    'Myeloma',
    'Myeloproliferative disease',
    'Myeloproliferative disorder',
    'Myeloproliferative neoplasm',
    'Myoepithelioma',
    'Myxofibrosarcoma',
    'Myxoid liposarcoma',
    'Neuroendocrine carcinoma',
    'Neuroendocrine tumor',
    'Neutropenia',
    'Neutrophilia',
    'NK/T-cell lymphoma',
    'Non-Hodgkins lymphoma',
    'Non-small cell carcinoma',
    'Non-small cell lung cancer',
    'Normocytic anemia',
    'Pancreatic adenocarcinoma',
    'Pancreatic cancer',
    'Pancytopenia',
    'Papillary thyroid carcinoma',
    'Paraproteinemia',
    'Parosteal osteosarcoma',
    'Parotid gland cancer',
    'Paroxysmal nocturnal hemoglobinuria',
    'Peripheral T-cell lymphoma',
    'Peritoneal carcinomatosis',
    'Pheochromocytoma',
    'Plasma cell leukemia',
    'Plasma cell myeloma',
    'Plasma cell neoplasm',
    'Pleomorphic sarcoma',
    'Polycythemia',
    'Polycythemia vera',
    'Posterior fossa tumor',
    'Primary myelofibrosis',
    'Primary myxofibrosarcoma',
    'Prolymphocytic leukemia',
    'Promyelocytic leukemia',
    'Prostate cancer',
    'Prostatic adenocarcinoma',
    'Pulmonary adenocarcinoma',
    'Rectal adenocarcinoma',
    'Rectal cancer',
    'Rectal carcinoma',
    'Red cell aplasia',
    'Renal cell carcinoma',
    'Retroperitoneal liposarcoma',
    'Rosai-Dorfman disease',
    'Round cell sarcoma',
    'Salivary duct carcinoma',
    'Salivary gland adenocarcinoma',
    'Salivary gland cancer',
    'Sarcoma',
    'Sarcomatoid carcinoma',
    'Sarcomatoid renal cell carcinoma',
    'Secondary myelofibrosis',
    'Small cell carcinoma',
    'Small cell carcinoma of bladder',
    'Small cell lung cancer',
    'Small lymphocytic lymphoma',
    'Smoldering multiple myeloma',
    'Smoldering myeloma',
    'Spinal cord tumor',
    'Spindle cell carcinoma',
    'Splenomegaly',
    'Squamous cell carcinoma',
    'Stem cell donor',
    'Systemic mastocytosis',
    'T-cell acute lymphoblastic leukemia',
    'T-cell large granular lymphocytic leukemia',
    'T-cell leukemia/lymphoma',
    'T-cell lymphoma',
    'T-cell lymphoproliferative disorder',
    'T-cell prolymphocytic leukemia',
    'Thalamic glioma',
    'Thrombocythemia',
    'Thrombocytopenia',
    'Thrombocytosis',
    'Thymoma',
    'Thyroid cancer',
    'Thyroid carcinoma',
    'Undifferentiated pleomorphic sarcoma',
    'Urothelial carcinoma',
    'Uterine sarcoma',
    'Uveal melanoma',
    'Vasculitis',
    'Von Willebrand disease',
    'Waldenstrom macroglobulinemia'
)

######################################################################################################
### INPUT FORMS
######################################################################################################

function Get-Input {
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
    $availableText = New-Object System.Windows.Forms.Label
    $availableText.Text = "Available Diagnoses:"
    $availableText.AutoSize = $true
    $availableText.Anchor = [System.Windows.Forms.AnchorStyles]::Left

    # diagnoses combobox
    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $comboBox.Anchor = [System.Windows.Forms.AnchorStyles]::Right
    $comboBox.Width = 375
    foreach ($diagnosis in $available) {
        [void] $comboBox.Items.Add($diagnosis)
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
    $table.Controls.Add($availableText)
    $table.SetRow($availableText, 0)
    $table.SetColumn($availableText, 0)
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

    $available[$comboBox.SelectedIndex]
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

        # dob
        $a.Columns("F").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # sex
        $a.Columns("G").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # accession #
        $a.Columns("D").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # received date
        $a.Columns("K").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
    
        # diagnosis 
        $result, $selectedDiagnosis = Get-Input -CmolId $cmolId
        if ($result -eq [System.Windows.Forms.DialogResult]::Abort) {
            Write-Host "`nAborting the creation of paste files`n" -ForegroundColor Red
            $inputBook.close()
            $excel.quit()
            exit
        }
        $selectedDiagnosis + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # pathoology id        
        $a.Columns("H").text.trim() + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append

        # report date
        (Get-Date -Format "M/d/yyyy") + "`n" | Out-File -Force -FilePath (Join-Path $PSScriptRoot $fileName) -Append
    }
}

# clean up 
$inputBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"