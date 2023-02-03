
CREATE OR REPLACE FUNCTION get_gc_referrals (
    p_from_date DATE DEFAULT NULL,
    p_to_date DATE DEFAULT NULL)
RETURNS TABLE (
    report_id VARCHAR,
    mrn VARCHAR,
    accession VARCHAR,
    test_date DATE,
    test_code VARCHAR,
    diagnosis VARCHAR,
    interpretation VARCHAR,
    physician VARCHAR
)
AS $$
BEGIN

    RETURN QUERY
    SELECT
        qr.report_id,
        qr.ordering_physician_client AS mrn,
        qr.accession,
        qr.test_date,
        qr.test_code,
        qr.diagnosis,
        qr.interpretation,
        REPLACE(qr.ordering_physician_name, ',', '')::VARCHAR AS physician
    FROM
        qci_report qr 
    WHERE 
        qr.ordering_physician_client IS NOT NULL
        AND (p_from_date IS NULL OR qr.test_date >= p_from_date)
        AND (p_to_date IS NULL OR qr.test_date <= p_to_date)
    ORDER BY    
        qr.test_date DESC;

END;
$$LANGUAGE plpgsql;

