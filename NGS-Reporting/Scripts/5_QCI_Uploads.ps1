
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

######################################################################################################
### GLOBAL DEFINITION
######################################################################################################

$available = @(
    'Acute Idiopathic Thrombocytopenic Purpura',
    'Acute Leukemia',
    'Acute Lymphoblastic Leukemia',
    'Acute Lymphoid Leukemia',
    'Acute Monocytic Leukemia',
    'Acute Myeloblastic Leukemia',
    'Acute Myeloid Leukemia',
    'Acute Promyelocytic Leukemia',
    'Adenocarcinoma',
    'Adenoid Cystic Carcinoma',
    'Adenosarcoma Of Cervix',
    'AMML',
    'Ampullary Carcinoma',
    'Amyloidosis',
    'Anaplastic Large Cell Lymphoma',
    'Anaplastic Thyroid Carcinoma',
    'Anemia',
    'Angiomyolipoma',
    'Angiosarcoma Of Breast',
    'Aplastic Anemia',
    'Appendiceal Carcinoma',
    'Appendix Cancer',
    'Autoimmune Hemolytic Anemia',
    'Bacteremia',
    'B-Cell Acute Lymphoblastic Leukemia',
    'B-Cell Lymphoma',
    'B-Cell Neoplasm',
    'B-Cell NHL',
    'B-Cell Prolymphocytic Leukemia',
    'Bladder Cancer',
    'Bladder Carcinoma',
    'Blastic Plasmacytoid Dendritic Cell Neoplasm',
    'Bone Tumor',
    'Brain Cancer',
    'Brain Carcinoma',
    'Breast Adenocarcinoma',
    'Breast Cancer',
    'Breast Carcinoma',
    'Cancer',
    'Carcinoma',
    'Cecal Adenocarcinoma',
    'Cecum Cancer',
    'Cerebellar Tumor',
    'Cholangiocarcinoma',
    'Cholangiosarcoma',
    'Chondrosarcoma',
    'Choroid Melanoma',
    'Chronic Idiopathic Thrombocytopenic Purpura',
    'Chronic Lymphoproliferative Disease',
    'Chronic Myelocytic Leukemia',
    'Chronic Myeloid Neoplasm',
    'Chronic Myelomonocytic Leukemia',
    'Chronic Neutropenia',
    'Clear Cell Renal Cell Carcinoma',
    'Clear Cell Sarcoma',
    'CLL',
    'CNS Lymphoma',
    'Colon Adenocarcinoma',
    'Colon Cancer',
    'Colorectal Adenocarcinoma',
    'Colorectal Cancer',
    'Colorectal Carcinoma',
    'Copper Deficiency',
    'Cryoglobulinemia',
    'Cutaneous Tcell Lymphoma',
    'Cytopenia',
    'Desmoplastic Small Round Cell Tumor',
    'Diamond Blackfan Anemia',
    'Diffuse Large B-Cell Lymphoma',
    'Duodenal Adenocarcinoma',
    'Dyskeratosis Congenita',
    'Endometrial Carcinoma',
    'Eosinophilia',
    'Epithelioid Hemangioendothelioma',
    'Epithelioid Sarcoma',
    'Erythrocytosis',
    'Esophageal Adenocarcinoma',
    'Esophageal Cancer',
    'Esophageal Squamous Cell Carcinoma',
    'Essential Thrombocythemia',
    'Essential Thrombocytopenia',
    'Essential Thrombocytosis',
    'ET',
    'Ewings Sarcoma',
    'Extranodal Marginal Zone Lymphoma',
    'Follicular Dendritic Cell Sarcoma',
    'Follicular Lymphoma',
    'Follicular Non-Hodgkins Lymphoma',
    'Follicular Thyroid Carcinoma',
    'Gastroesophageal Neoplasm',
    'GATA2 Deficiency',
    'GBM',
    'GIST',
    'Glioblastoma',
    'Glioma',
    'Hairy Cell Leukemia',
    'Hemangiopericytoma',
    'Hematologic Disorder',
    'Hematologic Disorders',
    'Hematologic Malignancies',
    'Hematologic Neoplasm',
    'Hematological Disorder',
    'Hematological Neoplasm',
    'Hemochromatosis',
    'Hemophagocytic Lymphohistiocytosis',
    'Hepatic Carcinoma',
    'Hepatocholangiocarcinoma',
    'Hepatosplenic T-Cell Lymphoma',
    'Hodgkins Lymphoma',
    'Hurthle Cell Carcinoma',
    'Hypereosinophilia',
    'Hypereosinophilic Syndrome',
    'Idiopathic Aplastic Anemia',
    'Idiopathic Hypereosinophilic Syndrome',
    'Idiopathic Thrombocytopenia Purpura',
    'Idiopathic Thrombocytopenic Purpura',
    'Intrahepatic Cholangiocarcinoma',
    'Iron Deficiency Anemia',
    'Jejunal Adenocarcinoma',
    'Langerhans Cell Histiocytosis',
    'Large Granular Lymphocytic Leukemia',
    'Laryngeal Carcinoma',
    'Leiomyosarcoma',
    'Leukocytosis',
    'Leukopenia',
    'Liposarcoma',
    'Liver Adenocarcinoma',
    'Lung Adenocarcinoma',
    'Lung Cancer',
    'Lung Carcinoma',
    'Lymphoadenopathy',
    'Lymphoblastic Leukemia',
    'Lymphoblastic Lymphoma',
    'Lymphocytopenia',
    'Lymphocytosis',
    'Lymphoma',
    'Lymphomatoid Granulomatosis',
    'Lymphopenia',
    'Lymphoplasmacytic Lymphoma',
    'Macrocytic Anemia',
    'Macrocytosis',
    'Malignant Gastrointestinal Stromal Tumor',
    'Malignant Neoplasm',
    'Malignant Neoplasm Of Stomach',
    'MALT Lymphoma',
    'Mammary Adenocarcinoma',
    'Mantle Cell Lymphoma',
    'Marginal Zone Lymphoma',
    'Mast Cell Activation Syndrome',
    'Mast Cell Disease',
    'Mast Cell Disorder',
    'Mast Cell Leukemia',
    'Mastocytosis',
    'MDS',
    'MDS/MPN',
    'Melanoma',
    'Mesothelioma',
    'Metastatic Breast Cancer',
    'Metastatic Carcinoma',
    'Metastatic Colonic Adenocarcinoma',
    'Metastatic Lung Adenocarcinoma',
    'MGUS',
    'Mixed Phenotype Acute Leukemia',
    'Mixed Phenotype Leukemia',
    'Monoclonal B-Cell Lymphocytosis',
    'Monoclonal Gammopathy',
    'Monocytosis',
    'MPD',
    'MPN',
    'MPNST',
    'Multiple Myeloma',
    'Myelodysplastic Syndrome',
    'Myelofibrosis',
    'Myeloid Neoplasm',
    'Myeloid Sarcoma',
    'Myeloma',
    'Myeloproliferative Disease',
    'Myeloproliferative Disorder',
    'Myeloproliferative Neoplasm',
    'Myoepithelioma',
    'Myxoid Liposarcoma',
    'Neuroendocrine Carcinoma',
    'Neuroendocrine Tumor',
    'Neutropenia',
    'Neutrophilia',
    'NHL',
    'NK/T-Cell Lymphoma',
    'Non-Small Cell Carcinoma',
    'Non-Small Cell Lung Cancer',
    'Normocytic Anemia',
    'Pancreatic Adenocarcinoma',
    'Pancreatic Cancer',
    'Pancytopenia',
    'Papillary Thyroid Carcinoma',
    'Paraproteinemia',
    'Parosteal Osteosarcoma',
    'Parotid Gland Cancer',
    'Paroxysmal Nocturnal Hemoglobinuria',
    'Peripheral Tcell Lymphoma',
    'Peritoneal Carcinomatosis',
    'Pheochromocytoma',
    'Plasma Cell Leukemia',
    'Pleomorphic Sarcoma',
    'Polycythemia',
    'Polycythemia Vera',
    'Posterior Fossa Tumor',
    'Primary Myelofibrosis',
    'Primary Myxofibrosarcoma',
    'Prolymphocytic Leukemia',
    'Promyelocytic Leukemia',
    'Prostate Cancer',
    'Prostatic Adenocarcinoma',
    'Pulmonary Adenocarcinoma',
    'Rectal Adenocarcinoma',
    'Rectal Cancer',
    'Rectal Carcinoma',
    'Red Cell Aplasia',
    'Renal Cell Carcinoma',
    'Retroperitoneal Liposarcoma',
    'Rosai-Dorfman Disease',
    'Round Cell Sarcoma',
    'Salivary Duct Carcinoma',
    'Salivary Gland Adenocarcinoma',
    'Salivary Gland Cancer',
    'Sarcoma',
    'Sarcomatoid Carcinoma',
    'Sarcomatoid Renal Cell Carcinoma',
    'Secondary Myelofibrosis',
    'Small Cell Carcinoma Of Bladder',
    'Small Cell Lung Cancer',
    'Small Lymphocytic Lymphoma',
    'Smoldering Multiple Myeloma',
    'Smoldering Myeloma',
    'Spinal Cord Tumor',
    'Spindle Cell Carcinoma',
    'Splenomegaly',
    'Squamous Cell Carcinoma',
    'Stem Cell Donor',
    'Systemic Mastocytosis',
    'T-Cell ALL',
    'T-Cell Large Granular Lymphocytic Leukemia',
    'T-Cell Leukemia/Lymphoma',
    'T-Cell Lymphoma',
    'T-Cell Lymphoproliferative Disorder',
    'T-Cell Prolymphocytic Leukemia',
    'Thalamic Glioma',
    'Thrombocythemia',
    'Thrombocytopenia',
    'Thrombocytosis',
    'Thymoma',
    'Thyroid Cancer',
    'Thyroid Carcinoma',
    'Undifferentiated Pleomorphic Sarcoma',
    'Urothelial Carcinoma',
    'Uterine Cancer',
    'Uterine Sarcoma',
    'Uveal Melanoma',
    'Vasculitis',
    'Von Willebrand Disease',
    'Waldenstrom Macroglobulinemia'
)

$templateXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ns1:QCISomaticTest xmlns:ns1="http://qci.qiagen.com/xsd/interpret" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.12.0">
    <ns1:TestProduct>
        <ns1:Code></ns1:Code>
        <ns1:Profile></ns1:Profile>
        <ns1:ReportTemplate>KUMC_HemOnc_v2</ns1:ReportTemplate>
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
        <ns1:Type></ns1:Type>
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
    $form.Text = "QCI Upload"
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

    $dims = New-Object System.Drawing.Size(595,172) # width, height
    $padding = New-Object System.Windows.Forms.Padding(6)
    $font = New-Object System.Drawing.Font -ArgumentList 'GenericSanSerif', 12.5

    # create form
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "QCI Upload for $cmolId"
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
    $table.RowCount = 3
    $table.ColumnCount = 2
    $table.AutoSize = $true
    $table.Padding = $padding

    # row styles
    $rowStyle1 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    $rowStyle2 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    $rowStyle3 = New-Object System.Windows.Forms.RowStyle -ArgumentList @([System.Windows.Forms.SizeType]::Absolute, 40)
    [void] $table.RowStyles.Add($rowStyle1)
    [void] $table.RowStyles.Add($rowStyle2)
    [void] $table.RowStyles.Add($rowStyle3)

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

    # flow panel for bottom buttons
    $flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $flow.FlowDirection = [System.Windows.Forms.FlowDirection]::RightToLeft
    $flow.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $flow.Controls.Add($okButton)
    $flow.Controls.Add($abortButton)

    # table third row
    $table.Controls.Add($flow)
    $table.SetRow($flow, 2)
    $table.SetColumn($flow, 0)
    $table.SetColumnSpan($flow, 2)

    $form.Controls.Add($table)

    $form.ShowDialog()

    $available[$comboBox.SelectedIndex]
}

######################################################################################################
### GATHER INPUT
######################################################################################################

$reportType = (Read-Host "Enter the report type (Comp|Heme)").Trim()

$code = $null
$tpp = $null
if ($reportType -ieq "Comp") {
    $code = "Comprehensive 275"
    $tpp = "Comprehensive_Cancer_Panel_275"
}
elseif ($reportType -ieq "Heme") {
    $code = "Heme 141"
    $tpp = "Hematologic_Neoplasms_Panel_141"
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
    Write-Host "`nAborting the creation of QCI upload packages`n" -ForegroundColor Red
    $inputBook.close()
    $excel.quit()
    exit
}

if ($samples.Count -eq 0) {
    Write-Host "`nNo samples selected for processing. Aborting the creation of QCI upload packages`n" -ForegroundColor Red
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

        Write-Host "`nSkipping QCI upload package for: $cmolId. A corresponding directory does not exist." -ForegroundColor Red
        continue
    }

    # the directory does exist
    foreach($row in $patientRows[$cmolId]){

        $xml = [xml] $templateXml 

        $nsmgr = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xml.NameTable
        $nsmgr.AddNamespace("ns1", "http://qci.qiagen.com/xsd/interpret")

        # based on report type
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:TestProduct/ns1:Code", $nsmgr).InnerText = $code
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:TestProduct/ns1:Profile", $nsmgr).InnerText = $tpp

        # based on input excel
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:AccessionId", $nsmgr).InnerText = $row.Columns("D").text.trim()
        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:TestDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("K").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:PrimarySourceTissue", $nsmgr).InnerText = "Unknown"

        $xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:Id", $nsmgr).InnerText = $row.Columns("I").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:CollectionDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("E").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Specimen/ns1:Type", $nsmgr).InnerText = $row.Columns("N").text.trim()

		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Name", $nsmgr).InnerText = $row.Columns("A").text.trim() + ", " + $row.Columns("B").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:BirthDate", $nsmgr).InnerText = Format-Date -DateText $row.Columns("F").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Age", $nsmgr).InnerText = Get-Age $row.Columns("F").text.trim()
        $gender = 'male'
        if ($row.Columns("G").text.trim().toUpper() -ne 'M') {
            $gender = 'female'
        }
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Patient/ns1:Gender", $nsmgr).InnerText = $gender

		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:Name", $nsmgr).InnerText = Format-Providers
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:ClientId", $nsmgr).InnerText = $row.Columns("C").text.trim()
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Physician/ns1:FacilityName", $nsmgr).InnerText = $row.Columns("P").text.trim()

		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Pathologist/ns1:Name", $nsmgr).InnerText = $row.Columns("H").text.trim()

        # diagnosis from input
        $indicated = $row.Columns("AF").text.trim()
        if ([String]::IsNullOrEmpty($indicated)){
            $indicated= "[blank]"
        }
        $result, $selected = Get-Input -CmolId $cmolId -Indicated $indicated
		$xml.SelectSingleNode("//ns1:QCISomaticTest/ns1:Test/ns1:Diagnosis", $nsmgr).InnerText = $selected
        if ($result -eq [System.Windows.Forms.DialogResult]::Abort) {
            Write-Host "`nAborting the creation of QCI upload packages`n" -ForegroundColor Red
            $inputBook.close()
            $excel.quit()
            exit
        }

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
        Write-Host "`nProcessed QCI upload package for: $cmolId" -ForegroundColor Green

        # since this does not handle 'common' reports, ignore subsequent rows
        break
    }
}

# clean up 
$inputBook.close()
$excel.quit()

Read-Host "`nPress enter to exit"