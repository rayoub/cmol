CREATE OR REPLACE FUNCTION clean_pts ()
RETURNS VOID
AS $$
BEGIN

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

END;
$$ LANGUAGE plpgsql;
