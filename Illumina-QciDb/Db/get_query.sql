
CREATE OR REPLACE FUNCTION get_query (p_tc_change VARCHAR DEFAULT NULL, p_pc_change VARCHAR DEFAULT NULL)
RETURNS TABLE (
    report_id VARCHAR,
    mrn VARCHAR,
    accession VARCHAR,
    test_date DATE,
    test_code VARCHAR,
    diagnosis VARCHAR,
    interpretation VARCHAR,
    physician VARCHAR,
    gene VARCHAR,
    allele_fraction NUMERIC,
    transcript VARCHAR,
    transcript_change VARCHAR,
    protein VARCHAR,
    protein_change VARCHAR,
    assessment VARCHAR
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
        SUBSTRING(REPLACE(qr.ordering_physician_name, ',', ''), 0, 16)::VARCHAR AS physician,
        qv.gene,
        qv.allele_fraction,
        qv.tc_transcript AS transcript,
        qv.tc_change AS trasnscript_change,
        qv.pc_protein AS protein,
        qv.pc_change AS protein_change,
        qv.assessment
    FROM
        qci_report qr 
        INNER JOIN qci_variant qv 
            ON qv.report_id = qr.report_id
    WHERE 
        1 = 1
        AND (p_tc_change IS NULL OR qv.tc_change LIKE '%' || p_tc_change || '%')
        AND (p_pc_change IS NULL OR qv.pc_change LIKE '%' || p_pc_change || '%')
    ORDER BY    
        qr.ordering_physician_client, -- MRN
        qr.accession,
        qr.test_date;

END;
$$LANGUAGE plpgsql;

