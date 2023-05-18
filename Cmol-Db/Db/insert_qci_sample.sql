
CREATE OR REPLACE FUNCTION insert_qci_sample (p_tab qci_sample ARRAY)
RETURNS VOID
AS $$
BEGIN

	INSERT INTO qci_sample (
                sample_id,
                mrn,
                accession,
                received_date,
                test_date,
                test_code,
                clinical_finding,
                diagnosis,
                interpretation,
                sex,
                date_of_birth,
                hospital_name,
                physician_name,
                primary_tumor_site,
                specimen_id,
                specimen_type,
                specimen_collection_date,
                lab_tested_cnv_gain,
                lab_tested_genes
        )
	SELECT
                sample_id,
                mrn,
                accession,
                received_date,
                test_date,
                test_code,
                clinical_finding,
                diagnosis,
                interpretation,
                sex,
                date_of_birth,
                hospital_name,
                physician_name,
                primary_tumor_site,
                specimen_id,
                specimen_type,
                specimen_collection_date,
                lab_tested_cnv_gain,
                lab_tested_genes
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

