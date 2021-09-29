
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
        sex,
        date_of_birth,
        ordering_physician_client,
        ordering_physician_facility_name,
        ordering_physician_name,
        pathologist_name,
        primary_tumor_site,
        specimen_id,
        specimen_type,
        specimen_collection_date,
        lab_tested_cnv_gain,
        lab_tested_genes,
        lab_transcript_ids
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
        sex,
        date_of_birth,
        ordering_physician_client,
        ordering_physician_facility_name,
        ordering_physician_name,
        pathologist_name,
        primary_tumor_site,
        specimen_id,
        specimen_type,
        specimen_collection_date,
        lab_tested_cnv_gain,
        lab_tested_genes,
        lab_transcript_ids
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

