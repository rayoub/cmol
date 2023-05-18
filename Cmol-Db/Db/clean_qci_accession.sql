CREATE OR REPLACE FUNCTION clean_qci_accession ()
RETURNS VOID
AS $$
BEGIN

    DELETE FROM 
        qci_variant 
    WHERE 
        sample_id IN
            (
                SELECT
                    sample_id
                FROM    
                    qci_sample
                WHERE   
                    LOWER(accession) LIKE 'val_%'
            );

    DELETE FROM
        qci_sample 
    WHERE 
        LOWER(accession) LIKE 'val_%';

END;
$$ LANGUAGE plpgsql;
