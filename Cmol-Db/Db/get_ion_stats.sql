
CREATE OR REPLACE FUNCTION get_ion_stats ()
RETURNS TABLE (
    descr VARCHAR,
    stat INTEGER
)
AS $$
BEGIN

    RETURN QUERY
    SELECT
        'sample count'::VARCHAR AS descr,
        COUNT(DISTINCT s.sample_folder)::INTEGER AS stat
    FROM
        ion_sample AS s;

END;
$$LANGUAGE plpgsql;

