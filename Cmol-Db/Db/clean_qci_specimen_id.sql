CREATE OR REPLACE FUNCTION clean_qci_specimen_id ()
RETURNS VOID
AS $$
BEGIN

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

END;
$$ LANGUAGE plpgsql;
