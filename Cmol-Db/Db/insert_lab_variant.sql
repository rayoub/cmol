
CREATE OR REPLACE FUNCTION insert_lab_variant (p_tab lab_variant ARRAY)
RETURNS VOID
AS $$
BEGIN
	
    INSERT INTO lab_variant (
        run_id,
        specimen_id,
        chromosome,
        region,
        variation,
        reference,
        alternate,
        allele_fraction,
        read_depth,
        gene,
        tc_transcript,
        tc_change,
        tc_exon_number,
        pc_change,
        assessment,
        reported
    )
	SELECT
        run_id,
        specimen_id,
        chromosome,
        region,
        variation,
        reference,
        alternate,
        allele_fraction,
        read_depth,
        gene,
        tc_transcript,
        tc_change,
        tc_exon_number,
        pc_change,
        assessment,
        reported
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

