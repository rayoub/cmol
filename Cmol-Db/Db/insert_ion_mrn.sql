
CREATE OR REPLACE FUNCTION insert_ion_mrn (p_tab ion_mrn ARRAY)
RETURNS VOID
AS $$
BEGIN

    TRUNCATE TABLE ion_mrn;

    INSERT INTO ion_mrn (
        mrn,
        accn
    )
	SELECT
        mrn, 
        accn
	FROM
		UNNEST(p_tab);

END;
$$ LANGUAGE plpgsql;

