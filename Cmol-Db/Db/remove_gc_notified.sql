
CREATE OR REPLACE FUNCTION remove_gc_notified (p_tab VARCHAR ARRAY)
RETURNS VOID
AS $$
BEGIN

    DELETE FROM gc_notified WHERE accession IN (SELECT accession FROM UNNEST(p_tab) accession);

END;
$$ LANGUAGE plpgsql;
