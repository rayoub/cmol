
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

######################################################################################################
### GLOBAL DEFINITION
######################################################################################################

$sources = @(
    'Bone Marrow',
    'Not Provided',
    'Unknown',
    'Abdomen',
    'Acinar Cell Carcinoma',
    'Adrenal Gland',
    'Anus',
    'Appendix',
    'Axilla',
    'Biliary Tree',
    'Blood Vessel',
    'Bone',
    'Bone Marrow',
    'Brain',
    'Breast',
    'Bronchus',
    'Cauda Equina',
    'Cervix Uteri',
    'Colon',
    'Colon / Rectum',
    'Duodenum',
    'Ear',
    'Endometrium',
    'Esophagus',
    'Eye',
    'Gallbladder',
    'Gastroesophageal Junction',
    'GIST',
    'Head and Neck',
    'Heart',
    'Kidney',
    'Larynx',
    'Left Colon',
    'Liver',
    'Lower Limb and Hip',
    'Lung',
    'Lymph Node',
    'Lymphoid Tissue',
    'Meninges',
    'Mouth',
    'Mucous Membrane',
    'Nasopharynx',
    'Nose',
    'Olfactory Nerve',
    'Optic Nerve',
    'Oropharynx',
    'Other',
    'Ovary',
    'Pancreas',
    'Paranasal Sinus',
    'Parathyroid Gland',
    'Penis',
    'Pharynx',
    'Pineal Gland',
    'Pituitary Gland',
    'Placenta',
    'Prostate Gland',
    'Gland',
    'Rectum',
    'Salivary Gland',
    'Scrotum',
    'Sigmoid Colon', 
    'Skin',
    'Small Intestine',
    'Soft Tissue',
    'Spinal Cord',
    'Spleen',
    'Stomach',
    'Testis',
    'Thorax',
    'Thymus',
    'Thyroid',
    'Tonsil',
    'Trachea',
    'Upper Limb and Shoulder',
    'Urinary Bladder',
    'Urinary Tract',
    'Uterus',
    'Vagina',
    'Vestibular Nerve',
    'Vulva'
)

$available = @(
    'Acute myeloid leukemia',
	'Myelodysplastic neoplasm',
	'Myeloproliferative neoplasm',
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
	'Burkitt lymphoma',
    'Cancer',
    'Carcinoma',
	'CCUS',
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
	'Myelodysplastic neoplasm',
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
	'Plasmablastic lymphoma',
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
	'Sickle cell anemia',
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

$templateXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ns1:QCISomaticTest xmlns:ns1="http://qci.qiagen.com/xsd/interpret" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.12.0">
    <ns1:TestProduct> 
        <ns1:Code></ns1:Code>
        <ns1:Profile></ns1:Profile>
        <ns1:ReportTemplate>KUMC_v1</ns1:ReportTemplate>
    </ns1:TestProduct>
    <ns1:Test>
        <ns1:AccessionId></ns1:AccessionId>
        <ns1:VariantsFilename></ns1:VariantsFilename>
        <ns1:TestDate></ns1:TestDate>
        <ns1:Diagnosis></ns1:Diagnosis>
        <ns1:PrimarySourceTissue></ns1:PrimarySourceTissue>
    </ns1:Test>
    <ns1:Patient> 
        <ns1:Name></ns1:Name>
        <ns1:BirthDate></ns1:BirthDate>
        <ns1:Age></ns1:Age>
        <ns1:Gender></ns1:Gender>
    </ns1:Patient>
    <ns1:Specimen> 
        <ns1:Id></ns1:Id>
        <ns1:CollectionDate></ns1:CollectionDate>
        <ns1:Dissection></ns1:Dissection>
    </ns1:Specimen>
    <ns1:Physician> 
        <ns1:Name></ns1:Name>
        <ns1:ClientId></ns1:ClientId>
        <ns1:FacilityName></ns1:FacilityName>
    </ns1:Physician>
    <ns1:Pathologist>
        <ns1:Name></ns1:Name>
    </ns1:Pathologist>
</ns1:QCISomaticTest>
"@

######################################################################################################
### FUNCTION DEFINITIONS
######################################################################################################

function Format-Date {
    param ([String] $dateText)

    if (-not [String]::isNullOrEmpty($dateText)) {
        $dateObj = [DateTime] $dateText
        Get-Date -Date $dateObj -Format 'yyyy-MM-dd'
    }
    else {
        ""
    }
}

function Get-Age {
    param ([String] $birthDateText)

    if (-not [String]::isNullOrEmpty($birthDateText)) {
        $birthDateObj = [DateTime] $birthDateText
        $todayDateObj = Get-Date 
        $age = $todayDateObj.Year - $birthDateObj.Year
        if ($birthDateObj.Date -gt $todayDateObj.AddYears(-$age)) {
            $age = $age - 1
        }
        $age
    }
    else {
        ""
    }
}
function Format-Provider {

    $providers = @()
    
    $provider = $row.Columns("R").text.trim()
    if (!$provider -eq "") {
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("S").text.trim(), $row.Columns("R").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    ($providers -join "; ")
}

function Format-Providers {

    $providers = @()
    
    $provider = $row.Columns("R").text.trim()
    if (!$provider -eq "") {
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("S").text.trim(), $row.Columns("R").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }
    
    $provider = $row.Columns("AG").text.trim()
    if (!$provider -eq ""){
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("AH").text.trim(), $row.Columns("AG").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    $provider = $row.Columns("AI").text.trim()
    if (!$provider -eq ""){
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("AJ").text.trim(), $row.Columns("AI").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    $provider = $row.Columns("AK").text.trim()
    if (!$provider -eq ""){
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("AL").text.trim(), $row.Columns("AK").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    $provider = $row.Columns("AM").text.trim()
    if (!$provider -eq ""){
        $doctor = if ($provider.contains(",")) { "" } else { "Dr." }
        $providers += (($doctor, $row.Columns("AN").text.trim(), $row.Columns("AM").text.trim()) | 
            Where-Object {$_ -ne ""}) -join " "
    }

    ($providers -join "; ")
}

function Get-FileName
{
    param([String] $initialDirectory, [String] $cmolId)

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Variant Call File (*.vcf) | *.vcf"
    $OpenFileDialog.Title = "Select Variant Call File for $cmolId"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

######################################################################################################
### INPUT FORMS
######################################################################################################

function Get-Selected {
    param ([String[]] $idList)

    $dims = New-Object System.Drawing.Size(560,300) # width, height
    $padding = New-Object System.Windows.Forms.Padding(6)
    $font = New-Object System.Drawing.Font -ArgumentList 'GenericSanSerif', 12.5

    # create form
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "QCIIOne Upload"
    $form.Font = $font
    $form.ControlBox = $false
    $form.Size = $dims
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.SizeGripStyle = 'Hide'
    $form.StartPosition = "CenterScreen"
    $form.TopMost = $true

    # select label
    $selectText = New-Object System.Windows.Forms.Label 
    $selectText.Text = "Select Samples:"
    $selectText.AutoSize = $true
    $selectText.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left

    # select listbox
    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
    $listBox.Width = 375
    $listBox.Height = 200
    foreach ($cmolId in $idList) {
        [void] $listBox.Items.Add($cmolId)
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
    $flow.Controls.Add($abortButton)

    # table third row
    $table.Controls.Add($flow)
    $table.SetRow($flow, 1)
    $table.SetColumn($flow, 0)
    $table.SetColumnSpan($flow, 2)

    $form.Controls.Add($table)

    $form.ShowDialog()

    $listbox.SelectedItems
}

function Get-Input {
    param ([String] $cmolId, [String] $indicated)

    $dims = New-Object System.Drawing.Size(595,242) # width, height
    $padding = New-Object System.Windows.Forms.Padding(6)
    $font = New-Object System.Drawing.Font -ArgumentList 'GenericSanSerif', 12.5

    # create form
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "QCIIOne Upload for $cmolId"
    $form.Font = $font
    $form.ControlBox = $false
    $form.Size = $dims
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.SizeGripStyle = 'Hide'
    $form.StartPosition = "CenterScreen"
    $form.TopMost = $true

    # labels
    $indicatedText = New-Object System.Windows.Forms.Label 
    $indicatedText.Text = "Receipt Log Diagnosis:"
    $indicatedText.AutoSize = $true
    $indicatedText.Anchor = [System.Windows.Forms.AnchorStyles]::Left
    $indicatedValue = New-Object System.Windows.Forms.Label 
    $indicatedValue.Text = $indicated
    $indicatedValue.AutoSize = $false
    $indicatedValue.Width = 375
    $indicatedValue.Anchor = [System.Windows.Forms.AnchorStyles]::Left
    $availableText = New-Object System.Windows.Forms.Label
    $availableText.Text = "Available Diagnoses:"
    $availableText.AutoSize = $true
    $availableText.Anchor = [System.Windows.Forms.AnchorStyles]::Left
    $sourceText = New-Object System.Windows.Forms.label
    $sourceText.Text = "Tumor Site:"
    $sourceText.AutoSize = $true
    $sourceText.Anchor = [System.Windows.Forms.AnchorStyles]::Left

    # diagnoses combobox
    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $comboBox.Anchor = [System.Windows.Forms.AnchorStyles]::Right
    $comboBox.Width = 375
    foreach ($diagnosis in $available) {
        [void] $comboBox.Items.Add($diagnosis)
    }
    if ($available -contains $indicated) {
        $comboBox.SelectedItem = $indicated
    }
    else {
        $comboBox.SelectedIndex = 0
    }

    # sources combobox
    $sourceCombo = New-Object System.Windows.Forms.ComboBox
    $sourceCombo.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $sourceCombo.Anchor = [System.Windows.Forms.AnchorStyles]::Right
    $sourceCombo.Width = 375
    foreach ($source in $sources) {
        [void] $sourceCombo.Items.Add($source)
    }
    $sourceCombo.SelectedIndex = 0

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
    $table.RowCount = 4
    $table.ColumnCount = 2
    $table.AutoSize = $true
    $table.Padding = $padding

    # row styles
    $rowStyle1 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    $rowStyle2 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    $rowStyle3 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    $rowStyle4 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    [void] $table.RowStyles.Add($rowStyle1)
    [void] $table.RowStyles.Add($rowStyle2)
    [void] $table.RowStyles.Add($rowStyle3)
    [void] $table.RowStyles.Add($rowStyle4)

    # table first row
    $table.Controls.Add($indicatedText)
    $table.SetRow($indicatedText, 0)
    $table.SetColumn($indicatedText, 0)
    $table.Controls.Add($indicatedValue)
    $table.SetRow($indicatedValue, 0)
    $table.SetColumn($indicatedValue, 1)

    # table second row
    $table.Controls.Add($availableText)
    $table.SetRow($availableText, 1)
    $table.SetColumn($availableText, 0)
    $table.Controls.Add($comboBox)
    $table.SetRow($comboBox, 1)
    $table.SetColumn($comboBox, 1)

    # table third row
    $table.Controls.Add($sourceText)
    $table.SetRow($sourceText, 2)
    $table.SetColumn($sourceText, 0)
    $table.Controls.Add($sourceCombo)
    $table.SetRow($sourceCombo, 2)
    $table.SetColumn($sourceCombo, 1)

    # flow panel for bottom buttons
    $flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $flow.FlowDirection = [System.Windows.Forms.FlowDirection]::RightToLeft
    $flow.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $flow.Controls.Add($okButton)
    $flow.Controls.Add($abortButton)

    # table bottom row
    $table.Controls.Add($flow)
    $table.SetRow($flow, 3)
    $table.SetColumn($flow, 0)
    $table.SetColumnSpan($flow, 2)

    $form.Controls.Add($table)

    $form.ShowDialog()

    $available[$comboBox.SelectedIndex]

    $sources[$sourceCombo.SelectedIndex]
}

######################################################################################################
### GATHER INPUT
######################################################################################################

$reportType = (Read-Host "Enter the report type (Comp|Heme)").Trim()

$code = $null
$tpp = $null
if ($reportType -ieq "Comp") {
    $code = "Comprehensive 275"
    $tpp = "QCIIOne_Comprehensive_Cancer_Panel_275"
}
elseif ($reportType -ieq "Heme141") {
    $code = "Heme 141_One"
    $tpp = "QCIIOne_Hematologic_Neoplasms_Panel_141"
}
elseif ($reportType -ieq "Heme50") {
    $code = "Heme 50_One"
    $tpp = "QCIIOne_Hematologic_Neoplasms_Panel_50"
}
else {
    Write-Host "`nERROR: An invalid report type was entered." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

$inputFile = Get-ChildItem -Filter *_Input_v?.xlsx | Select-Object -First 1
if ($null -eq $inputFile){
    Write-Host "`nERROR: An Excel input file was not found in the current directory." -ForegroundColor Red
    Read-Host "`nPress enter to exit"
    exit
}

######################################################################################################
### DO THE WORK
######################################################################################################

# load input workbook
$excel = New-Object -ComObject Excel.Application
$inputBook = $excel.workbooks.open($inputFile.FullName)
$inputSheet = $inputBook.sheets(1)

# build hash-table of accession #/cmol id combos and patient rows from input workbook
$idList = @()
$patientRows = @{} 
for ($i = 2; $i -lt 100; $i++){

    $text = $inputSheet.cells($i,1).text().trim()
    if ([String]::IsNullOrEmpty($text)){

        # no more rows
        break
    }

    # fill in hash-table
    $cmolId = $inputSheet.cells($i, 9).text().trim() + "_" + $inputsheet.cells($i, 4).text().trim()
    $row = $inputSheet.rows($i)
    if ($patientRows.ContainsKey($cmolId)) {

        # some reports may have multiple rows for a single accession #/cmol id combination
        $patientRows[$cmolId] += $row
    }
    else {
        $patientRows.Add($cmolId, @($row))
    }
    $idList += $cmolId
}

$result, $samples = Get-Selected -IdList $idList
if ($result -eq [System.Windows.Forms.DialogResult]::Abort) {
    Write-Host "`nAborting the creation of QCIIOne upload packages`n" -ForegroundColor Red
    $inputBook.close()
    $excel.quit()
    exit
}

if ($samples.Count -eq 0) {
    Write-Host "`nNo samples selected for processing. Aborting the creation of QCIIOne upload packages`n" -ForegroundColor Red
    $inputBook.close()
    $excel.quit()
    exit
}

# iterate input rows
foreach($cmolId in $samples){
    
    # get directory corresponding to cmol id
    $dirName = Get-ChildItem -Path . -Directory -Filter $cmolId* | Select-Object -First 1 | Select-Object -ExpandProperty Name

    # continue if directory does not exist
    if ($null -eq $dirName) {

        Write-Host "`nSkipping QCIIOne upload package for: $cmolId. A corresponding directory does not exist." -ForegroundColor Red
        continue
    }

    # the directory does exist
    foreach($row in $patientRows[$cmolId]){

        $xml = [xml] $templateXml 

        $nsmgr = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xml.NameTable
        $nsmgr.AddNamespace("ns1", "http://qci.qiagen.com/xsd/interpret")

        # TestProduct element - based on prompted inputs
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:TestProduct/ns1:Code", $nsmgr).InnerText = $code
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:TestProduct/ns1:Profile", $nsmgr).InnerText = $tpp	

        # Test element
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:AccessionId", $nsmgr).InnerText = $row.Columns("D").text.trim()
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:TestDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("K").text.trim()

        # Patient element
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Name", $nsmgr).InnerText = $row.Columns("A").text.trim() + ", " + $row.Columns("B").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:BirthDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("F").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Age", $nsmgr).InnerText = Get-Age $row.Columns("F").text.trim()
        $gender = 'male'
        if ($row.Columns("G").text.trim().toUpper() -ne 'M') {
            $gender = 'female'
        }
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Gender", $nsmgr).InnerText = $gender

        # Specimen element
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:Id", $nsmgr).InnerText = $row.Columns("I").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:CollectionDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("E").text.trim()
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:Dissection", $nsmgr).InnerText = $row.Columns("C").text.trim() 

        # Physician element
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:Name", $nsmgr).InnerText = $row.Columns("P").text.trim()
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:ClientId", $nsmgr).InnerText = $row.Columns("P").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:FacilityName", $nsmgr).InnerText = Format-Provider

        # Pathologist element
        $pathologist = $row.Columns("H").text.trim()
        if ([String]::IsNullOrEmpty($pathologist) -or $pathologist -ieq 'n/a') {
            $pathologist = $row.Columns("N").text.trim()
        }
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Pathologist/ns1:Name", $nsmgr).InnerText = $pathologist

        # diagnosis from input excel
        $indicated = $row.Columns("AF").text.trim()
        if ([String]::IsNullOrEmpty($indicated)){
            $indicated= "[blank]"
        }

        # get inputs from input form
        $result, $selectedDiagnosis, $selectedSource = Get-Input -CmolId $cmolId -Indicated $indicated
        if ($result -eq [System.Windows.Forms.DialogResult]::Abort) {
            Write-Host "`nAborting the creation of QCIIOne upload packages`n" -ForegroundColor Red
            $inputBook.close()
            $excel.quit()
            exit
        }
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:Diagnosis", $nsmgr).InnerText = $selectedDiagnosis
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:PrimarySourceTissue", $nsmgr).InnerText =  $selectedSource

        # get the VCF file
        $dirPath = (Join-Path $PSScriptRoot -ChildPath $dirName)
        $file = Get-FileName -initialDirectory $dirPath -cmolId $cmolId
        if ([String]::IsNullOrEmpty($file)) {
            Write-Host "`nNo Vcf file selected for: $cmolId. Skipping to the next sample." -ForegroundColor Red
            continue
        }
        $fileName = (Split-Path -Path $file -Leaf)
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:VariantsFilename", $nsmgr).InnerText = $fileName
        
        # file names
        $saveVcf = $file
        $saveXml = (Join-Path $dirPath -ChildPath ($cmolId + ".xml"))
        $saveZip = (Join-Path $dirPath -ChildPath ($cmolId + ".zip"))

        # create archive
        $xml.Save($saveXml)
        $compress = @{
            Path = $saveVcf, $saveXml
            DestinationPath = $saveZip 
            CompressionLevel = "Optimal"
        }
        Compress-Archive @compress -Force

        # confirmation
        Write-Host "`nProcessed QCIIOne upload package for: $cmolId" -ForegroundColor Green

        # since this does not handle 'common' reports, ignore subsequent rows
        break
    }
}

# clean up 
$inputBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"