
CREATE OR REPLACE FUNCTION get_qci_query (
    p_diagnoses INTEGER ARRAY DEFAULT NULL,
    p_from_date DATE DEFAULT NULL,
    p_to_date DATE DEFAULT NULL,
    p_mrns VARCHAR ARRAY DEFAULT NULL, 
    p_genes VARCHAR ARRAY DEFAULT NULL, 
    p_tc_change VARCHAR DEFAULT NULL, 
    p_pc_change VARCHAR DEFAULT NULL)
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
    transcript_exon INTEGER,
    protein VARCHAR,
    protein_change VARCHAR,
    assessment VARCHAR
)
AS $$
BEGIN

    IF p_diagnoses IS NULL THEN 

        RETURN QUERY
        SELECT
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
            qv.tc_exon_number AS transcript_exon,
            qv.pc_protein AS protein,
            qv.pc_change AS protein_change,
            qv.assessment
        FROM
            qci_report qr 
            INNER JOIN qci_variant qv 
                ON qv.report_id = qr.report_id
            LEFT JOIN UNNEST(p_mrns) pm(mrn)
                ON pm.mrn = qr.ordering_physician_client
            LEFT JOIN UNNEST(p_genes) pg(gene)
                ON LOWER(pg.gene) = LOWER(qv.gene)
        WHERE 
            qr.ordering_physician_client IS NOT NULL
            AND (p_from_date IS NULL OR qr.test_date >= p_from_date)
            AND (p_to_date IS NULL OR qr.test_date <= p_to_date)
            AND (p_mrns IS NULL OR pm.mrn IS NOT NULL)
            AND (p_genes IS NULL OR pg.gene IS NOT NULL)
            AND (p_tc_change IS NULL OR qv.tc_change LIKE '%' || p_tc_change || '%')
            AND (p_pc_change IS NULL OR qv.pc_change LIKE '%' || p_pc_change || '%')
            AND qr.test_code NOT LIKE '%Common%'
        ORDER BY    
            qr.test_date DESC;

    ELSE

        RETURN QUERY
        SELECT
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
            qv.tc_exon_number AS transcript_exon,
            qv.pc_protein AS protein,
            qv.pc_change AS protein_change,
            qv.assessment
        FROM
            qci_report qr 
            INNER JOIN qci_variant qv 
                ON qv.report_id = qr.report_id
            INNER JOIN qci_diagnosis qd 
                ON qd.descr = qr.diagnosis
            INNER JOIN UNNEST(p_diagnoses) pd(diagnosis)
                ON pd.diagnosis = qd.id
            LEFT JOIN UNNEST(p_mrns) pm(mrn)
                ON pm.mrn = qr.ordering_physician_client
            LEFT JOIN UNNEST(p_genes) pg(gene)
                ON LOWER(pg.gene) = LOWER(qv.gene)
        WHERE 
            qr.ordering_physician_client IS NOT NULL
            AND (p_from_date IS NULL OR qr.test_date >= p_from_date)
            AND (p_to_date IS NULL OR qr.test_date <= p_to_date)
            AND (p_mrns IS NULL OR pm.mrn IS NOT NULL)
            AND (p_genes IS NULL OR pg.gene IS NOT NULL)
            AND (p_tc_change IS NULL OR qv.tc_change LIKE '%' || p_tc_change || '%')
            AND (p_pc_change IS NULL OR qv.pc_change LIKE '%' || p_pc_change || '%')
            AND qr.test_code NOT LIKE '%Common%'
        ORDER BY    
            qr.test_date DESC;

    END IF;

END;
$$LANGUAGE plpgsql;

