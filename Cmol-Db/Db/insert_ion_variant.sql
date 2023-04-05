
CREATE OR REPLACE FUNCTION insert_ion_variant (p_tab ion_variant ARRAY)
RETURNS VOID
AS $$
BEGIN
	
    INSERT INTO ion_variant (
        zip_name,
        locus,
        type, 
        subtype,
        genotype,
        filter,
        ref,
        genes,
        transcript,
        coding,
        protein
    )
	SELECT
        zip_name, 
        locus,
        type,
        subtype,
        genotype,
        filter,
        ref,
        genes,
        transcript,
        coding,
        protein
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

