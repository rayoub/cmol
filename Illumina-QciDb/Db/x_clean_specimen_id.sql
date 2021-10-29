
--SELECT specimen_id, COUNT(*) FROM qci_report WHERE specimen_id NOT LIKE 'D%' GROUP BY specimen_id ORDER BY specimen_id;

UPDATE 
    qci_report
SET 
    specimen_type = specimen_id,
    specimen_id = null
WHERE 
    specimen_id LIKE 'Bone Marrow%'
    OR specimen_id LIKE 'FFPE%'
    OR specimen_id LIKE 'Blood%'
    OR specimen_id = 'Buccal Swab';

UPDATE 
    qci_report 
SET 
    specimen_id = null
WHERE   
    specimen_id IN ('specimen ID');