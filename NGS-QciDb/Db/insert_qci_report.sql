
CREATE OR REPLACE FUNCTION insert_qci_report (p_tab qci_report ARRAY)
RETURNS VOID
AS $$
BEGIN

	INSERT INTO qci_report (
        report_id,
        subject_id,
        accession,
        test_date,
        test_code,
        clinical_finding,
        diagnosis,
        interpretation,
        patient_name,
        sex,
        date_of_birth,
        ordering_physician_client,
        ordering_physicianFacility_name,
        ordering_physician_name,
        pathologist_name,
        primary_tumor_site,
        specimen_id,
        specimen_type,
        specimen_collection_date,
        specimen_dissection,
        specimen_tumor_content,
        lab_tested_cnv_gain,
        lab_tested_genes,
        lab_transcript_ids,
        sample_detected_gene_fusions,
        sample_detected_gene_negative,
        version
    )
	SELECT
        report_id,
        subject_id,
        accession,
        test_date,
        test_code,
        clinical_finding,
        diagnosis,
        interpretation,
        patient_name,
        sex,
        date_of_birth,
        ordering_physician_client,
        ordering_physicianFacility_name,
        ordering_physician_name,
        pathologist_name,
        primary_tumor_site,
        specimen_id,
        specimen_type,
        specimen_collection_date,
        specimen_dissection,
        specimen_tumor_content,
        lab_tested_cnv_gain,
        lab_tested_genes,
        lab_transcript_ids,
        sample_detected_gene_fusions,
        sample_detected_gene_negative,
        version
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

