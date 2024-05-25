
CREATE OR REPLACE FUNCTION get_lab_query (
    p_from_date DATE DEFAULT NULL,
    p_to_date DATE DEFAULT NULL,
    p_mrns VARCHAR ARRAY DEFAULT NULL, 
    p_genes VARCHAR ARRAY DEFAULT NULL, 
    p_exon VARCHAR DEFAULT NULL, 
    p_tc_change VARCHAR DEFAULT NULL, 
    p_pc_change VARCHAR DEFAULT NULL)
RETURNS TABLE (
	run_id VARCHAR,
	cmol_id	VARCHAR,
	mrn VARCHAR,
	accession VARCHAR,
	reported_date DATE,
	test_code VARCHAR,
	sample_type VARCHAR,
	diagnosis VARCHAR,
	surgpath_id VARCHAR,
	archived VARCHAR,
    locus VARCHAR,
	gene VARCHAR,
	allele_fraction NUMERIC,
	transcript VARCHAR,
    transcript_change VARCHAR,
    transcript_exon VARCHAR,
    protein_change VARCHAR,
	assessment VARCHAR,
	reported VARCHAR
)
AS $$
BEGIN

    RETURN QUERY
    SELECT
        ls.run_id,
        ls.cmol_id,
        ls.mrn,
        ls.accession,
        ls.reported_date,
        ls.test_code,
        ls.sample_type,
        ls.diagnosis,
        ls.surgpath_id,
        ls.archived,
        ('chr' || lv.chromosome || ':' || lv.region::VARCHAR)::VARCHAR AS locus,
        lv.gene,
        lv.allele_fraction,
        lv.tc_transcript AS transcript,
        lv.tc_change AS trasnscript_change,
        lv.tc_exon_number AS transcript_exon,
        lv.pc_change AS protein_change,
        lv.assessment,
        lv.reported
    FROM
        lab_sample ls 
        INNER JOIN lab_variant lv 
            ON lv.run_id = ls.run_id AND lv.cmol_id = ls.cmol_id
        LEFT JOIN UNNEST(p_mrns) pm(mrn)
            ON pm.mrn = ls.mrn
        LEFT JOIN UNNEST(p_genes) pg(gene)
            ON LOWER(pg.gene) = LOWER(lv.gene)
    WHERE 
        ls.mrn IS NOT NULL
        AND (p_from_date IS NULL OR ls.reported_date >= p_from_date)
        AND (p_to_date IS NULL OR ls.reported_date <= p_to_date)
        AND (p_mrns IS NULL OR pm.mrn IS NOT NULL)
        AND (p_genes IS NULL OR pg.gene IS NOT NULL)
        AND (p_exon IS NULL OR lv.tc_exon_number LIKE '%' || p_exon || '%')
        AND (p_tc_change IS NULL OR lv.tc_change LIKE '%' || p_tc_change || '%')
        AND (p_pc_change IS NULL OR lv.pc_change LIKE '%' || p_pc_change || '%')
        AND ls.test_code NOT LIKE '%Common%'
    ORDER BY    
        ls.reported_date DESC;

END;
$$LANGUAGE plpgsql;

