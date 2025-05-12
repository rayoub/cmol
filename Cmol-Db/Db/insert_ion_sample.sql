
CREATE OR REPLACE FUNCTION insert_ion_sample (p_tab ion_sample ARRAY)
RETURNS VOID
AS $$
BEGIN
	
    INSERT INTO ion_sample (
        download_type,
        zip_hash,
        assay_folder,
        sample_folder,
        specimen_id,
        accession_id,
        analysis_date,
        mrn
    )
	SELECT
        download_type,
        zip_hash, 
        assay_folder,
        sample_folder,
        specimen_id,
        accession_id,
        analysis_date,
        mrn
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

