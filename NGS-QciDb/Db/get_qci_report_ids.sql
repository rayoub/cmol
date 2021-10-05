
CREATE OR REPLACE FUNCTION get_qci_report_ids ()
RETURNS TABLE (
    report_id VARCHAR
)
AS $$
BEGIN

    RETURN QUERY
    SELECT 
        r.report_id
    FROM
        qci_report r;

END;
$$LANGUAGE plpgsql;
