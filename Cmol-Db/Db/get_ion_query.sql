
CREATE OR REPLACE FUNCTION get_ion_query (
    p_cmol_id VARCHAR DEFAULT NULL,
    p_mrns VARCHAR ARRAY DEFAULT NULL, 
    p_genes VARCHAR ARRAY DEFAULT NULL
    )
RETURNS TABLE (
    assay_folder VARCHAR,
    cmol_id VARCHAR,
    mrn VARCHAR,
    accession_id VARCHAR,
    locus VARCHAR,
    type VARCHAR,
    subtype VARCHAR,
    genotype VARCHAR,
    filter VARCHAR,
    ref VARCHAR,
    genes VARCHAR,
    transcript VARCHAR,
    coding VARCHAR,
    protein VARCHAR
)
AS $$
BEGIN

    RETURN QUERY
    SELECT
        s.assay_folder,
        s.cmol_id,
        m.mrn,
        s.accession_id,
        v.locus,
        v.type, 
        v.subtype,
        v.genotype,
        v.filter,
        v.ref,
        v.genes,
        v.transcript,
        v.coding,
        v.protein
    FROM
        ion_sample s
        INNER JOIN ion_mrn m
            ON m.accn = s.accession_id
        INNER JOIN ion_variant v
            ON s.zip_name = v.zip_name
        LEFT JOIN UNNEST(p_mrns) pm(mrn)
                ON pm.mrn = m.mrn
        LEFT JOIN UNNEST(p_genes) pg(gene)
            ON LOWER(v.genes) LIKE '%' || LOWER(pg.gene) || '%'
    WHERE 
        (p_cmol_id IS NULL OR s.cmol_id = p_cmol_id)
        AND (p_mrns IS NULL OR pm.mrn IS NOT NULL)
        AND (p_genes IS NULL OR pg.gene IS NOT NULL)
    ORDER BY
        s.assay_folder,
        s.cmol_id,    
        v.locus;

END;
$$LANGUAGE plpgsql;

