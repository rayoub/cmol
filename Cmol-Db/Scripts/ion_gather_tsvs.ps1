
# set locations 
$root = "R:\CMOL\Assay Results\Clinical Data\NGS Comprehensive Plus\"
$paths = @(($root + "2022 (Run 001-015)"), ($root + "2023 (Run 016- )"))
$data = "E:\git\cmol\Cmol-Db\Data\Ion"

# assays we already did
$assayFolders = New-Object System.Collections.Generic.HashSet[String]
$existingTsvs = Get-ChildItem -Path $data -Filter *.tsv 
foreach($existingTsv in $existingTsvs) {
    $assayFolders.Add(($existingTsv.Name -split ' ')[0]) | Out-Null
}

# get zip files
$files = @()
foreach($path in $paths) {
    $files += Get-ChildItem -Path $path -Filter CP*.zip -Recurse -Depth 2
}

# create zip objects
$zips = @($null) * $files.Length
for($i = 0; $i -lt $files.Length; $i++){
    $zips[$i] = [PSCustomObject]@{ 
        DirectoryName = $files[$i].DirectoryName;
        FileName = $files[$i].Name;
        SampleFolder = $files[$i].Directory.Name;
        AssayFolder = $files[$i].Directory.Parent.Name
    }
}

# sort zip objects
$zips = $zips | Sort-Object -Property AssayFolder,SampleFolder,DirectoryName,FileName | Select-Object -Property AssayFolder,SampleFolder,DirectoryName,FileName

# iterate zip objects
foreach($zip in $zips) {

    if ($assayFolders -notcontains $zip.AssayFolder) {

        Write-Host "Processing a zip file for" $zip.SampleFolder 

        $shell = New-Object -com shell.application

        $variantsFolder = $zip.DirectoryName + "\" + $zip.FileName + "\Variants"
        $tsvFolder = $shell.namespace($variantsFolder).items() | Select-Object -First 1
        $tsvFile = $shell.namespace($variantsFolder + "\" + $tsvFolder.Name).items() | Where-Object { $_.Name -like "*full.tsv"} | Select-Object -First 1
        
        Write-Host "Extracting" $tsvFile.Name
        $shell.namespace($data).copyhere($tsvFile, 16)
    
        $tsvFullName = $data + "\" + $tsvFile.Name
        $tsvNewFullName = $data + "\" + $zip.AssayFolder + " " + $zip.SampleFolder + " " + [io.path]::GetFileNameWithoutExtension($zip.FileName) + " " + $tsvFile.Name

        Rename-Item -Path $tsvFullName -NewName $tsvNewFullName
    }
}