
$root = "\\kumc.edu\data\Research\CANCTR RSCH\CMOL\Assay Results\Clinical Data\NGS Comprehensive Plus\"
$paths = 
    ($root + "2022 (Run 001-015)"),
    ($root + "2023 (Run 016- )")

$data = "E:\git\cmol\Cmol-Db\Data"

$files = @()
foreach($path in $paths) {

    $files += Get-ChildItem -Path $path -Filter CP*.zip -Recurse -Depth 2
}
$zips = @($null) * $files.Length
for($i = 0; $i -lt $files.Length; $i++){
    $zips[$i] = [PSCustomObject]@{ 
        FileName = $files[$i].Name;
        SampleFolder = $files[$i].Directory.Name;
        AssayFolder = $files[$i].Directory.Parent.Name
    }
}

$zips = $zips | Sort-Object -Property AssayFolder,SampleFolder,FileName | Select-Object -Property AssayFolder,SampleFolder,FileName