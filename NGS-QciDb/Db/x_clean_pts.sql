
SELECT
    primary_tumor_site,
    COUNT(*)
FROM    
    qci_report
GROUP BY
    primary_tumor_site
ORDER BY
    primary_tumor_site;

-- title case everything that is not all caps
UPDATE
    qci_report
SET
    primary_tumor_site = INITCAP(primary_tumor_site)
WHERE
    primary_tumor_site <> UPPER(primary_tumor_site);