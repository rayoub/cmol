CREATE OR REPLACE FUNCTION ion_truncate ()
RETURNS VOID
AS $$
BEGIN

    TRUNCATE TABLE ion_variant;

END;
$$ LANGUAGE plpgsql;
