
CREATE OR REPLACE FUNCTION insert_gc_notified (p_tab VARCHAR ARRAY)
RETURNS VOID
AS $$
BEGIN

	INSERT INTO gc_notified (
        accession
    )
	SELECT
        accession
	FROM
		UNNEST(p_tab) accession;

END;
$$ LANGUAGE plpgsql;
