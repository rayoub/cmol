SELECT 
    test_code, 
    COALESCE(primary_tumor_site, 'NULL') AS primary_tumor_site,
    count(*),
    STRING_AGG(ordering_physician_client,';') AS MRNs
FROM 
    qci_report 
WHERE
    ordering_physician_client IS NOT NULL
    AND (primary_tumor_site IN ('Unknown','Not Provided') OR primary_tumor_site IS NULL)
GROUP BY 
    test_code, 
    primary_tumor_site 
ORDER BY    
    test_code, 
    primary_tumor_site;