
DELETE FROM 
    qci_variant 
WHERE 
    report_id IN
        (
            SELECT
                report_id
            FROM    
                qci_report
            WHERE   
                LOWER(accession) LIKE 'val_%'
        );

DELETE FROM
    qci_report 
WHERE 
    LOWER(accession) LIKE 'val_%';