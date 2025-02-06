
CREATE OR REPLACE FUNCTION get_ion_query (
    p_download_type VARCHAR,
    p_from_date DATE DEFAULT NULL,
    p_to_date DATE DEFAULT NULL,
    p_specimen_id VARCHAR DEFAULT NULL,
    p_mrns VARCHAR ARRAY DEFAULT NULL, 
    p_genes VARCHAR ARRAY DEFAULT NULL,
    p_tc_change VARCHAR DEFAULT NULL, 
    p_pc_change VARCHAR DEFAULT NULL)
RETURNS TABLE (
    analysis_date DATE,
    assay_folder VARCHAR,
    specimen_id VARCHAR,
    mrn VARCHAR,
    locus VARCHAR,
    type VARCHAR,
    subtype VARCHAR,
    genotype VARCHAR,
    filter VARCHAR,
    ref VARCHAR,
    normalized_alt VARCHAR,
    coverage VARCHAR,
    allele_coverage VARCHAR,
    allele_ratio VARCHAR,
    allele_frequency VARCHAR,
    genes VARCHAR,
    transcript VARCHAR,
    location VARCHAR,
    function VARCHAR,
    exon VARCHAR,
    coding VARCHAR,
    protein VARCHAR,
    copy_number VARCHAR,
    copy_number_type VARCHAR,
    fold_diff VARCHAR
)
AS $$
BEGIN

    RETURN QUERY
    SELECT
        s.analysis_date,
        s.assay_folder,
        s.specimen_id,
        m.mrn,
        v.locus,
        v.type, 
        v.subtype,
        v.genotype,
        v.filter,
        v.ref,
        v.normalized_alt,
        v.coverage,
        v.allele_coverage,
        v.allele_ratio,
        v.allele_frequency,
        v.genes,
        v.transcript,
        v.location,
        v.function,
        v.exon,
        v.coding,
        v.protein,
        v.copy_number,
        v.copy_number_type,
        v.fold_diff
    FROM
        ion_sample s
        INNER JOIN ion_variant v
            ON s.zip_name = v.zip_name
        LEFT JOIN ion_mrn m
            ON m.accn = s.accession_id
        LEFT JOIN UNNEST(p_mrns) pm(mrn)
                ON pm.mrn = m.mrn
        LEFT JOIN UNNEST(p_genes) pg(gene)
            ON LOWER(v.genes) LIKE '%' || LOWER(pg.gene) || '%'
    WHERE 
        s.download_type = p_download_type
        AND (p_from_date IS NULL OR s.analysis_date >= p_from_date)
        AND (p_to_date IS NULL OR s.analysis_date <= p_to_date)
        AND (p_specimen_id IS NULL OR s.specimen_id = p_specimen_id)
        AND (p_mrns IS NULL OR pm.mrn IS NOT NULL)
        AND (p_genes IS NULL OR pg.gene IS NOT NULL)
        AND (p_tc_change IS NULL OR v.coding LIKE '%' || p_tc_change || '%')
        AND (p_pc_change IS NULL OR v.protein LIKE '%' || p_pc_change || '%')
    ORDER BY
        s.analysis_date DESC,
        s.assay_folder,
        s.specimen_id,    
        v.locus;

END;
$$LANGUAGE plpgsql;

