
# set locations 
$root = "R:\CMOL\Assay Results\Clinical Data\NGS Comprehensive Plus\"
$paths = @(($root + "2022 (Run 001-015)"), ($root + "2023 (Run 016-090)"), ($root + "2024 (Run 091-226)")), ($root + "2025 (Run 227-)")
$data = "E:\git\cmol\Cmol-Db\Data\Ion"

# get zip files
$files = @()
foreach($path in $paths) {
    $files += Get-ChildItem -Path $path -Filter "CP*.zip" -Depth 2 | Where-Object { $_.Name -like "*SelectedVariants*" -or $_.Name -like "*Filtered*" }
}

# create zip objects
$zips = @($null) * $files.Length
for($i = 0; $i -lt $files.Length; $i++){
    if ($files[$i].Directory.Name.Split(" ").Length -eq 1) {
        $zips[$i] = [PSCustomObject]@{ 
            DirectoryName = $files[$i].DirectoryName;
            FileName = $files[$i].Name;
            SampleFolder = $files[$i].Directory.Name;
            AssayFolder = $files[$i].Directory.Parent.Name
        }
    }
}

# sort zip objects
$zips = $zips | Sort-Object -Property AssayFolder,SampleFolder,DirectoryName,FileName | Select-Object -Property AssayFolder,SampleFolder,DirectoryName,FileName

# zips we already did
$existingVcfs = Get-ChildItem -Path $data -Include ('*Selected*.vcf', '*Filtered*.vcf') -Recurse
$existingZips = New-Object System.Collections.Generic.HashSet[String]
foreach($existingVcf in $existingVcfs) {
    $existingZips.Add(($existingVcf.Name -split ' ')[2]) | Out-Null
}

# iterate zip objects
foreach($zip in $zips) {

    if ($existingZips -notcontains [io.path]::GetFileNameWithoutExtension($zip.FileName)) {

        Write-Host "Processing a zip file for" $zip.AssayFolder $zip.SampleFolder 

        $shell = New-Object -com shell.application

        $variantsFolder = $zip.DirectoryName + "\" + $zip.FileName + "\Variants"
        $vcfFolder = $shell.namespace($variantsFolder).items() | Select-Object -First 1
        $vcfFile = $shell.namespace($variantsFolder + "\" + $vcfFolder.Name).items() | Where-Object { $_.Name -like "CP*.vcf"} | Select-Object -First 1
      
		if ($null -ne $vcfFile) {
            
			$vcfFileName = $vcfFile.Name.replace(":","_")
            $vcfFullName = $data + "\" + $vcfFileName
            $vcfNewFullName = $data + "\" + $zip.AssayFolder + " " + $zip.SampleFolder + " " + [io.path]::GetFileNameWithoutExtension($zip.FileName) + " " + $vcfFileName

            if (-not (Test-Path $vcfNewFullName -PathType Leaf)) {
                Write-Host "Extracting" $vcfFileName
                $shell.namespace($data).copyhere($vcfFile, 16) | Out-Null
                Rename-Item -Path $vcfFullName -NewName $vcfNewFullName
            }
		}
    }
}