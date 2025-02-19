
CREATE OR REPLACE FUNCTION get_gc_to_notify (
    p_from_date DATE DEFAULT NULL)
RETURNS TABLE (
    accession VARCHAR
)
AS $$
BEGIN

    RETURN QUERY
    SELECT DISTINCT 
        qr.accession
    FROM
        qci_sample qr 
        INNER JOIN qci_variant qv 
            ON qv.sample_id = qr.sample_id
        INNER JOIN gc_gene g 
            ON g.gene = qv.gene
        LEFT JOIN gc_notified n 
            ON n.accession = qr.accession
    WHERE 
        n.accession IS NULL
        AND qr.accession ~* '^[a-z][0-9]+$'
        AND (p_from_date IS NULL OR qr.test_date >= p_from_date)
    ORDER BY
        qr.accession
    LIMIT 3
    ;

END;
$$LANGUAGE plpgsql;

