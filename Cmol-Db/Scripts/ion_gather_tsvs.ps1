
# set locations 
$root = "R:\CMOL\Assay Results\Clinical Data\NGS Comprehensive Plus\"
$paths = @(($root + "2022 (Run 001-015)"), ($root + "2023 (Run 016-090)"), ($root + "2024 (Run 091-226)")), ($root + "2025 (Run 227-)")
$data = "E:\git\cmol\Cmol-Db\Data\Ion"

# get zip files
$files = @()
foreach($path in $paths) {
    if ($path.StartsWith("2022") -or $path.StartsWith("2023") -or $path.StartsWith("2024")) {
        $files += Get-ChildItem -Path $path -Filter "C*.zip" -Depth 2 | Where-Object { $_.Name -like "*SelectedVariants*" -or $_.Name -like "*Filtered*" }
    }
    else {
        $files += Get-ChildItem -Path $path -Filter "C*.zip" -Depth 3 | Where-Object { $_.Name -like "*SelectedVariants*" -or $_.Name -like "*Filtered*" }
    }
}

# create zip objects
$zips = @($null) * $files.Length
for($i = 0; $i -lt $files.Length; $i++){
    if ($files[$i].Directory.Name.Split(" ").Length -eq 1) {

        # hash the file name
        $fileName = $files[$i].Name
        $fileStream = [IO.MemoryStream]::new([byte[]][char[]][io.path]::GetFileNameWithoutExtension($fileName))
        $fileNameHash = Get-FileHash -InputStream $fileStream -Algorithm SHA256

        $zips[$i] = [PSCustomObject]@{ 
            DirectoryName = $files[$i].DirectoryName;
            FileName = $fileName
            FileNameHash = $fileNameHash.Hash;
            SampleFolder = $files[$i].Directory.Name;
            AssayFolder = $files[$i].Directory.Parent.Name
        }
    }
}

# sort zip objects
$zips = $zips | Sort-Object -Property AssayFolder,SampleFolder,DirectoryName,FileName,FileNameHash | Select-Object -Property AssayFolder,SampleFolder,DirectoryName,FileName,FileNameHash

# file name hashes we already did
$existingTsvs = Get-ChildItem -Path $data -Include ('*Selected*.tsv', '*Filtered*.tsv') -Recurse
$existingHashes = New-Object System.Collections.Generic.HashSet[String]
foreach($existingTsv in $existingTsvs) {
    $existingHashes.Add(($existingTsv.Name -split ' ')[2]) | Out-Null
}

# iterate zip objects
foreach($zip in $zips) {
    if ($existingHashes -notcontains $zip.FileNameHash) {

        Write-Host "Processing a zip file for" $zip.AssayFolder $zip.SampleFolder 

        $shell = New-Object -com shell.application

        $variantsFolder = $zip.DirectoryName + "\" + $zip.FileName + "\Variants"
        $tsvFolder = $shell.namespace($variantsFolder).items() | Select-Object -First 1
        $tsvFile = $shell.namespace($variantsFolder + "\" + $tsvFolder.Name).items() | Where-Object { $_.Name -like "*full.tsv"} | Select-Object -First 1
      
        if ($null -ne $tsvFile) {

            $analysisDate = "1900-01-01"
            $zipParts = $fileName -split "_"
            foreach ($zipPart in $zipParts) {
                if ($zipPart.startsWith("20") -and $zipPart.length -eq 10) {
                    $analysisDate = $zipPart
                }
            }

            $tsvFileName = $tsvFile.Name.replace(":","_")
            $tsvFullName = $data + "\" + $tsvFileName
            $tsvNewFullName = $zip.AssayFolder + " " + $zip.SampleFolder + " " + $zip.FileNameHash + " " + $analysisDate + " " + $tsvFileName

            if (-not (Test-Path $tsvNewFullName -PathType Leaf)) {
                Write-Host "Extracting" $tsvFileName
                $shell.namespace($data).copyhere($tsvFile, 16) | Out-Null
                Rename-Item -Path $tsvFullName -NewName $tsvNewFullName
            }
        }
    }
}