
CREATE OR REPLACE FUNCTION get_query (p_tab VARCHAR ARRAY DEFAULT NULL, p_tc_change VARCHAR DEFAULT NULL, p_pc_change VARCHAR DEFAULT NULL)
RETURNS TABLE (
    n INTEGER,
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

    IF p_tab IS NULL THEN 
    
        RETURN QUERY
        SELECT
            ROW_NUMBER() OVER (ORDER BY qr.test_date DESC)::INTEGER AS n,
            qr.report_id,
            qr.ordering_physician_client AS mrn,
            qr.accession,
            qr.test_date,
            qr.test_code,
            qr.diagnosis,
            qr.interpretation,
            REPLACE(qr.ordering_physician_name, ',', '')::VARCHAR AS physician,
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
            qr.ordering_physician_client IS NOT NULL
            AND (p_tc_change IS NULL OR qv.tc_change LIKE '%' || p_tc_change || '%')
            AND (p_pc_change IS NULL OR qv.pc_change LIKE '%' || p_pc_change || '%')
            AND qr.test_code NOT LIKE '%Common%'
        ORDER BY    
            qr.test_date DESC;

    ELSE
        
        RETURN QUERY
        SELECT
            ROW_NUMBER() OVER (ORDER BY qr.test_date DESC)::INTEGER AS n,
            qr.report_id,
            qr.ordering_physician_client AS mrn,
            qr.accession,
            qr.test_date,
            qr.test_code,
            qr.diagnosis,
            qr.interpretation,
            REPLACE(qr.ordering_physician_name, ',', '')::VARCHAR AS physician,
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
            -- this is the only difference
            INNER JOIN UNNEST(p_tab) p(gene)
                ON LOWER(p.gene) = LOWER(qv.gene)
        WHERE 
            qr.ordering_physician_client IS NOT NULL
            AND (p_tc_change IS NULL OR qv.tc_change LIKE '%' || p_tc_change || '%')
            AND (p_pc_change IS NULL OR qv.pc_change LIKE '%' || p_pc_change || '%')
            AND qr.test_code NOT LIKE '%Common%'
        ORDER BY    
            qr.test_date DESC;

    END IF;

END;
$$LANGUAGE plpgsql;

