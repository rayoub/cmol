CREATE OR REPLACE FUNCTION clean_lab_all ()
RETURNS VOID
AS $$
BEGIN

    PERFORM clean_lab_diagnosis();

END;
$$ LANGUAGE plpgsql;
