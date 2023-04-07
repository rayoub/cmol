
CREATE OR REPLACE FUNCTION get_ion_query (
    p_assay_folder VARCHAR DEFAULT NULL,
    p_cmol_id VARCHAR DEFAULT NULL,
    p_gene VARCHAR DEFAULT NULL 
    )
RETURNS TABLE (
    assay_folder VARCHAR,
    cmol_id VARCHAR,
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
        INNER JOIN ion_variant v
            ON s.zip_name = v.zip_name
    WHERE 
        (p_assay_folder IS NULL OR s.assay_folder = p_assay_folder)
        AND
        (p_cmol_id IS NULL OR s.cmol_id = p_cmol_id)
        AND 
        (p_gene IS NULL OR v.genes LIKE '%' || p_gene || '%')
    ORDER BY
        s.assay_folder,
        s.cmol_id,    
        v.locus;

END;
$$LANGUAGE plpgsql;

