
CREATE OR REPLACE FUNCTION clean_qci_mrn ()
RETURNS VOID
AS $$
BEGIN

    UPDATE qci_sample SET mrn = null WHERE mrn !~ '^\d+$';

END;
$$ LANGUAGE plpgsql;