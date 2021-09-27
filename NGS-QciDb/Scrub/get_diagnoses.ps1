
$a = New-Object -TypeName System.Collections.ArrayList 

$files = Get-ChildItem -Path './Data/*.xml'
foreach ($file in $files) {
    $xml = [xml] (Get-Content -Path $file.FullName -Raw)
    $node = $xml.SelectSingleNode("//report/diagnosis")
    $diagnosis = (Get-Culture).TextInfo.ToTitleCase($node.InnerText)
    [void] $a.Add($diagnosis)
}

$a | Sort-Object -Unique