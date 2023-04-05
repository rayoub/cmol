
CREATE OR REPLACE FUNCTION get_ion_query (
    p_sample VARCHAR DEFAULT NULL)
RETURNS TABLE (
    zip_name VARCHAR,
    locus VARCHAR,
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
        iv.zip_name,
        iv.locus,
        iv.genotype,
        iv.filter,
        iv.ref,
        iv.genes,
        iv.transcript,
        iv.coding,
        iv.protein
    FROM
        ion_variant iv
    WHERE 
        (p_sample IS NULL OR iv.sample LIKE '%' || p_sample || '%')
    ORDER BY    
        iv.sample;

END;
$$LANGUAGE plpgsql;

