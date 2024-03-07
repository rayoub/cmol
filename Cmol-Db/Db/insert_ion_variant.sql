
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
        normalized_alt,
        coverage,
        allele_coverage,
        allele_ratio,
        allele_frequency,
        genes,
        transcript,
        location,
        function,
        exon,
        coding,
        protein,
        copy_number,
        copy_number_type,
        fold_diff
    )
	SELECT
        zip_name,
        locus,
        type,
        subtype,
        genotype,
        filter,
        ref,
        normalized_alt,
        coverage,
        allele_coverage,
        allele_ratio,
        allele_frequency,
        genes,
        transcript,
        location,
        function,
        exon,
        coding,
        protein,
        copy_number,
        copy_number_type,
        fold_diff
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

