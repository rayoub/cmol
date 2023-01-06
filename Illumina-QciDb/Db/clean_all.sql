CREATE OR REPLACE FUNCTION clean_all ()
RETURNS VOID
AS $$
BEGIN

    -- these first few must be in order
    PERFORM clean_test_code();
    PERFORM clean_accession();
    PERFORM clean_specimen_id();

    -- must come after the first few
    PERFORM clean_specimen_type();
    PERFORM clean_pts();
    PERFORM clean_opfn();
    PERFORM clean_opc();
    PERFORM clean_diagnosis();

END;
$$ LANGUAGE plpgsql;
