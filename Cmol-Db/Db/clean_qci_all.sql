CREATE OR REPLACE FUNCTION clean_qci_all ()
RETURNS VOID
AS $$
BEGIN

    -- these first few must be in order
    PERFORM clean_qci_test_code();
    PERFORM clean_qci_specimen_id();

    -- must come after the first few
    PERFORM clean_qci_specimen_type();
    PERFORM clean_qci_pts();
    PERFORM clean_qci_hospital_name();
    PERFORM clean_qci_mrn();
    PERFORM clean_qci_diagnosis();

END;
$$ LANGUAGE plpgsql;
