
# set locations 
$root = "R:\CMOL\Assay Results\Clinical Data\NGS Comprehensive Plus\"
$paths = @(($root + "2024 (Run 091-226)"), ($root + "2025 (Run 227-)"))

# get zip files
$files = @()
foreach($path in $paths) {
    $files += Get-ChildItem -Path $path -Filter "CP*.zip" -Depth 2 | Where-Object { $_.Name -like "*SelectedVariants*" -or $_.Name -like "*Filtered*" }
}

# collect directories to fix
$pathsToFix = New-Object System.Collections.Generic.HashSet[System.String]
$dirsToFix = New-Object System.Collections.Generic.HashSet[System.IO.DirectoryInfo]
for($i = 0; $i -lt $files.Length; $i++){
    if ($files[$i].Directory.Name.Split(" ").Length -eq 1) {
        if ($files[$i].Directory.Name.contains(".")) {
            if ($pathsToFix -notcontains $files[$i].Directory.FullName) {
                $dirsToFix.Add($files[$i].Directory) | Out-Null
                $pathsToFix.Add($files[$i].Directory.FullName) | Out-Null
            }
        }
    }
}

# rename misnamed directories
foreach ($dir in $dirsToFix) {
    Write-Host ("renaming " + $dir.FullName)
    Write-Host ("to " + (Join-Path $dir.Parent.FullName ($dir.Name -split '_')[1]))
    Rename-Item $dir.FullName (Join-Path $dir.Parent.FullName ($dir.Name -split '_')[1])
}