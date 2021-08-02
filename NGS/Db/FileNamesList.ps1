
$summaryDirs = @(
    '//kumc.edu/data/research/canctr rsch/cmol/assay results/clinical data/ngs/2018 (Run 111-252)/',                    
    '//kumc.edu/data/research/canctr rsch/cmol/assay results/clinical data/ngs/2019 (Run 253-412 )/',                    
    '//kumc.edu/data/research/canctr rsch/cmol/assay results/clinical data/ngs/2020 (Run 413-578)/',                    
    '//kumc.edu/data/research/canctr rsch/cmol/assay results/clinical data/ngs/2021 (Run 579- )/'
)

# switch index of $summaryDirs
$summaryFiles = Get-ChildItem -Path $summaryDirs[3] -Include *.xlsm -Recurse | Where-Object Name -match 'd\d\d\d\d\d' 


