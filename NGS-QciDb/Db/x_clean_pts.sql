
--SELECT
--    primary_tumor_site,
--    COUNT(*)
--FROM    
--    qci_report
--GROUP BY
--    primary_tumor_site
--ORDER BY
--    primary_tumor_site;

-- only one type of null
UPDATE 
    qci_report 
SET
    primary_tumor_site = 'Not Provided'
WHERE
    primary_tumor_site = ''
    OR primary_tumor_site IS NULL;

-- title case everything that is not all caps
UPDATE
    qci_report
SET
    primary_tumor_site = INITCAP(primary_tumor_site)
WHERE
    primary_tumor_site <> UPPER(primary_tumor_site);

