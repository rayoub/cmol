
# set locations 
$root = "R:\CMOL\Assay Results\Clinical Data\NGS Comprehensive Plus\"
$paths = @(($root + "2022 (Run 001-015)"), ($root + "2023 (Run 016- )"))
$data = "E:\git\cmol\Cmol-Db\Data\Ion"

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

# assays we already did
$existingVcfs = Get-ChildItem -Path $data -Filter *SelectedVariants*.vcf 
$assayFolders = New-Object System.Collections.Generic.HashSet[String]
foreach($existingVcf in $existingVcfs) {
    $assayFolders.Add(($existingVcf.Name -split ' ')[0]) | Out-Null
}

# iterate zip objects
foreach($zip in $zips) {

    if ($assayFolders -notcontains $zip.AssayFolder) {

        Write-Host "Processing a zip file for" $zip.SampleFolder 

        $shell = New-Object -com shell.application

        $variantsFolder = $zip.DirectoryName + "\" + $zip.FileName + "\Variants"
        $vcfFolder = $shell.namespace($variantsFolder).items() | Select-Object -First 1
        $vcfFile = $shell.namespace($variantsFolder + "\" + $vcfFolder.Name).items() | Where-Object { $_.Name -like "*SelectedVariants*.vcf"} | Select-Object -First 1
      
		if ($null -ne $vcfFile) {
            
			$vcfFileName = $vcfFile.Name.replace(":","_")
            Write-Host "Extracting" $vcfFileName
            $shell.namespace($data).copyhere($vcfFile, 16) | Out-Null
        
            $vcfFullName = $data + "\" + $vcfFileName
            $vcfNewFullName = $data + "\" + $zip.AssayFolder + " " + $zip.SampleFolder + " " + [io.path]::GetFileNameWithoutExtension($zip.FileName) + " " + $vcfFileName

            Rename-Item -Path $vcfFullName -NewName $vcfNewFullName
		}
    }
}