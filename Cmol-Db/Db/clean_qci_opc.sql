
CREATE OR REPLACE FUNCTION clean_qci_opc ()
RETURNS VOID
AS $$
BEGIN

    UPDATE qci_report SET ordering_physician_client = null WHERE ordering_physician_client !~ '^\d+$';

END;
$$ LANGUAGE plpgsql;