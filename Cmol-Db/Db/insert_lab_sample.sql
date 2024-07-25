
CREATE OR REPLACE FUNCTION insert_lab_sample (p_tab lab_sample ARRAY)
RETURNS VOID
AS $$
BEGIN

	INSERT INTO lab_sample (
                run_id,
                run_number,
                cmol_id,
                mrn,
                accession,
                test_code ,
                reported_date,
                hospital_name,
                sample_type,
                diagnosis,
                surgpath_id,
                archived
        )
	SELECT
                run_id,
                run_number,
                cmol_id,
                mrn,
                accession,
                test_code ,
                reported_date,
                hospital_name,
                sample_type,
                diagnosis,
                surgpath_id,
                archived
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

