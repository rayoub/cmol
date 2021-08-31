
function Save-Xml {
    param([String] $dataPackageID, [String] $content)

    $xml = [xml] $Content 
    $nodes = $xml.SelectNodes("//report/clinicaltrial|//report/treatment|//report/article")
    for ($i = $nodes.Count - 1; $i -ge 0; $i = $i - 1) {

        $node = $nodes[$i]
        $parent = $node.ParentNode
        [void]$parent.RemoveChild($node)
    }
    
    $outFile = "C:/Users/r77755/Documents/Git/cmol/NGS-QCI/Data/" + $dataPackageID + ".xml"
    $xml.Save($outFile)
}

$headers = @{ 
    accept = 'application/json'
    Authorization = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzNzE0NjU2IiwibGFzdE5hbWUiOiJBeW91YiIsInVzZXJfbmFtZSI6InJheW91YkBrdW1jLmVkdSIsImlzcyI6Imh0dHBzOi8vYXBwcy5pbmdlbnVpdHkuY29tL3FpYW9hdXRoIiwiaW5zdGl0dXRpb25JZHMiOnt9LCJjbGllbnRfaWQiOiI1MzE1Mjc3MzY0MDEwNDg2MjcteE16SUxZIiwiYXV0aG9yaXRpZXMiOnt9LCJhdWQiOlsiMTk0ODQ4MTQ4LTEwOTQzNjE3MzEtalBhb0dTIl0sImZpcnN0TmFtZSI6IlJvbmFsZCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjpbImh0dHBzOi8vYXBpLmluZ2VudWl0eS5jb20vZGF0YXN0cmVhbS9hcGkvdjIvc2FtcGxlL3tkYXRhUGFja2FnZUlkfS53cml0ZW9ubHkiLCJodHRwczovL2FwaS5pbmdlbnVpdHkuY29tL2RhdGFzdHJlYW0vYXBpL3YxL2V4cG9ydC97ZGF0YVBhY2thZ2VJZH0ucmVhZG9ubHkiLCJodHRwczovL2FwaS5pbmdlbnVpdHkuY29tL2RhdGFzdHJlYW0vYXBpL3YyL3NhbXBsZS53cml0ZW9ubHkiLCJodHRwczovL2FwaS5pbmdlbnVpdHkuY29tL2RhdGFzdHJlYW0vYXBpL3YxL2RhdGFwYWNrYWdlcy97ZGF0YVBhY2thZ2VJZH0vdXNlcnMud3JpdGVvbmx5IiwiaHR0cHM6Ly9hcGkuaW5nZW51aXR5LmNvbS9kYXRhc3RyZWFtL2FwaS92MS90ZXN0UHJvZHVjdFByb2ZpbGVzLnJlYWRvbmx5IiwiaHR0cHM6Ly9hcGkuaW5nZW51aXR5LmNvbS9kYXRhc3RyZWFtL2FwaS92MS9kYXRhcGFja2FnZXMve2RhdGFQYWNrYWdlSWR9LnJlYWRvbmx5IiwiaHR0cHM6Ly9hcGkuaW5nZW51aXR5LmNvbS9kYXRhc3RyZWFtL2FwaS92MS9kYXRhcGFja2FnZXMud3JpdGVvbmx5IiwiaHR0cHM6Ly9hcGkuaW5nZW51aXR5LmNvbS9kYXRhc3RyZWFtL2FwaS92MS9jbGluaWNhbC5yZWFkb25seSIsImh0dHBzOi8vYXBpLmluZ2VudWl0eS5jb20vZGF0YXN0cmVhbS9hcGkvdjEvcWNpR3JvdXBzL3tncm91cE5hbWV9L3Rlc3RQcm9kdWN0UHJvZmlsZXMve3RwcE5hbWV9LnJlYWRvbmx5Il0sImV4cCI6MTYzMDUwMTEzOCwianRpIjoiMitGalZkaldaZGFWT0RzVi9yTkNpZDZla0Y4PSJ9.COygDBt04y8iVm0xdr0UU9xYgA3qSiBeqVo1Uc5KmWsjDR75DDs-CCrm_mvgX8OolqUTJgQKfWhJ27k0cTz2r7krRHDO5N2K8oRJuM2pzXX_p7AdI3P5Bfp-RTFcEs7MT7UJyk2YK4O-P-Ov6YUII1HtwNtbR3o0jzDxcFLHZOA99yPPre4emhPk-cWQT4Yf0hH_CFcyVpM8b6Cd4I1ue6opaGzhSGBKaGTw9tCw6uKvgBD9mdB6yhmrwFQ5ptRGckSGeygbv6VvyNnCY-dVAs2Z0erq2WsG3f2-3b8KODu9fHMSGnYyGdCJWIY9Rh2Fvn1WJZ0QdjphRMEfgUx0hw'
}

$response = $null
$tests = Get-Content -Path ./exported_tests.json -Raw | ConvertFrom-Json 
foreach ($test in $tests) {

    $uri = $test.exportUrl + '?view=reportXml'
    $response = Invoke-WebRequest `
        -URI $uri `
        -Method 'Get' `
        -Headers $headers 

    Save-Xml -Content $response -DataPackageID $test.dataPackageID
}