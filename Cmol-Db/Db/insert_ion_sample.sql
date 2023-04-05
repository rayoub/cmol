
CREATE OR REPLACE FUNCTION insert_ion_sample (p_tab ion_sample ARRAY)
RETURNS VOID
AS $$
BEGIN
	
    INSERT INTO ion_sample (
        zip_name,
        assay_folder,
        sample_folder,
        cmol_id,
        accession_id
    )
	SELECT
        zip_name, 
        assay_folder,
        sample_folder,
        cmol_id,
        accession_id
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

