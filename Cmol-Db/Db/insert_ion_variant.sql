
CREATE OR REPLACE FUNCTION insert_ion_variant (p_tab ion_variant ARRAY)
RETURNS VOID
AS $$
BEGIN
	
    INSERT INTO ion_variant (
        sample,
        locus,
        genotype,
        filter,
        ref,
        genes,
        transcript,
        coding,
        protein
    )
	SELECT
        sample, 
        locus,
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

