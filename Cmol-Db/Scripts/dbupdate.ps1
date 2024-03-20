
Write-Host "geting QCI XML files"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -q
Write-Host "importing QCI XML files"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -r
Write-Host "cleaning QCI tables"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -s
E:\git\cmol\Cmol-Db\Scripts\ion_gather_mrns.ps1
E:\git\cmol\Cmol-Db\Scripts\ion_gather_tsvs.ps1
E:\git\cmol\Cmol-Db\Scripts\ion_gather_vcfs.ps1
Write-Host "importing Ion selected variants"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -i
Write-Host "importing Ion filtered variants"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -j
Write-Host "importing Ion MRNs"
java -jar E:\git\cmol\Cmol-Db\CmolDbApp\target\CmolDbApp-0.0.1-SNAPSHOT-jar-with-dependencies.jar -k




