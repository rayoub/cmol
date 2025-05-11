Write-Host "Importing Lab loose files"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -b
Write-Host "Cleaning Lab tables"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -c
Write-Host "Getting QCI XML files"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -q
Write-Host "Importing QCI XML files"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -r
Write-Host "Cleaning QCI tables"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -s
E:\git\cmol\Cmol-Db\Scripts\ion_gather_tsvs.ps1
E:\git\cmol\Cmol-Db\Scripts\ion_gather_vcfs.ps1
Write-Host "Importing Ion selected variants"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -i
Write-Host "Importing Ion filtered variants"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -j
Write-Host "Importing Ion MRNs"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -k
