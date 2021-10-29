
CREATE OR REPLACE FUNCTION sentence_case (p_text VARCHAR)
RETURNS VARCHAR
AS $$
DECLARE
    x_text VARCHAR DEFAULT '';
BEGIN

    WITH terms AS
    (
        SELECT
            ROW_NUMBER() OVER() AS n,
            term
        FROM    
            regexp_split_to_table(TRIM(BOTH ' ' FROM p_text), '\s+') term
    ),
    x1_terms AS 
    (
        SELECT 
            n,
            CASE
            WHEN n = 1 AND term <> UPPER(term) THEN INITCAP(LOWER(term))
            WHEN n = 1 AND term = UPPER(term) THEN expand_acronym(term, 1)
            WHEN n <> 1 AND term <> UPPER(term) THEN LOWER(term)
            WHEN n <> 1 AND term = UPPER(term) THEN expand_acronym(term, 2)
            ELSE 'THIS SHOULD NOT HAPPEN'
            END AS term
        FROM 
            terms
    ),
    x2_terms AS
    (
        SELECT
            n,
            CASE
            WHEN LOWER(term) IN ('tcell', 't-cell') THEN 'T-cell'
            WHEN LOWER(term) IN ('bcell', 'b-cell') THEN 'B-cell'
            WHEN LOWER(term) IN ('non-small') THEN 'Non-small'
            ELSE term
            END AS term
        FROM
            x1_terms
    )
    SELECT 
        string_agg(term, ' ' ORDER BY n) 
    INTO
        x_text
    FROM 
        x2_terms;

    SELECT
        replace(x_text, 'B cell', 'B-cell')
    INTO
        x_text;
    
    SELECT
        replace(x_text, 'T cell', 'T-cell')
    INTO
        x_text;

    RETURN x_text;

END;
$$ LANGUAGE plpgsql;
