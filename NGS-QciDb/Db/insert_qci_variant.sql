
CREATE OR REPLACE FUNCTION insert_qci_variant (p_tab qci_variant ARRAY)
RETURNS VOID
AS $$
BEGIN
	
    INSERT INTO qci_variant (
        report_id,
        chromosome,
        position,
        reference,
        alternate,
        genotype,
        assessment,
        actionability,
        phenotype_id,
        phenotype_name,
        dbsnp,
        cadd,
        allele_fraction,
        read_depth,
        variation,
        gene,
        tc_transcript,
        tc_change,
        tc_exon_number,
        tc_region,
        pc_protein,
        pc_change,
        pc_translation_impact,
        gc_change,
        function,
        reference_count
    )
	SELECT
        report_id,
        chromosome,
        position,
        reference,
        alternate,
        genotype,
        assessment,
        actionability,
        phenotype_id,
        phenotype_name,
        dbsnp,
        cadd,
        allele_fraction,
        read_depth,
        variation,
        gene,
        tc_transcript,
        tc_change,
        tc_exon_number,
        tc_region,
        pc_protein,
        pc_change,
        pc_translation_impact,
        gc_change,
        function,
        reference_count
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

