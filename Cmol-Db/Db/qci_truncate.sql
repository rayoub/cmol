CREATE OR REPLACE FUNCTION qci_truncate ()
RETURNS VOID
AS $$
BEGIN

    TRUNCATE TABLE qci_report;
    TRUNCATE TABLE qci_variant;

END;
$$ LANGUAGE plpgsql;
