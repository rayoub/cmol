
$data = New-Object -TypeName System.Collections.ArrayList 

# switch year of file names
$files = Get-Content .\FileNames2020.txt 

foreach($file in $files){

    $a = $file -split '\\'

    $start = ($a[0..($a.length-3)] -join '\')
    $parentDir = $a[-2]
    $fileName = $a[-1]

    $results = $true
    if (-not $start.ToLower().EndsWith("results")) {
        $results = $false
    }

    $h = @{ Start = $start; Parent = $parentDir; FileName = $fileName; Results = $results } 

    [void] $data.Add([PSCustomObject] $h)
}