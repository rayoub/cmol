
CREATE OR REPLACE FUNCTION get_ion_cnv_stats ()
RETURNS TABLE (
    gene VARCHAR,
	sn INTEGER,
	gn INTEGER,
	gn_pct NUMERIC,
    min_cn NUMERIC,
	max_cn NUMERIC,
	avg_cn NUMERIC
)
AS $$
BEGIN

    RETURN QUERY
	WITH gene_cn AS 
	(
		SELECT
			s.zip_name,
			v.genes AS gene, -- only one in all cases for cnv
			v.copy_number::NUMERIC AS cn
		FROM
			ion_sample AS s
			INNER JOIN ion_variant AS v  -- assumed 1-1
				ON s.zip_name = v.zip_name
		WHERE
			s.download_type = 'Filtered'	
			AND	genes IS NOT NULL
			AND copy_number IS NOT NULL AND copy_number <> 'null'
	),
	sample_n AS
	(
		SELECT 
			COUNT(DISTINCT s.zip_name) AS n
		FROM
			ion_sample s
		WHERE
			s.download_type = 'Filtered'
	),
	dat AS 
	(
		SELECT 
			g.gene,
			(SELECT s.n FROM sample_n s) AS sn,
			COUNT(DISTINCT g.zip_name) AS gn,
			MIN(cn) AS min_cn,
			MAX(cn) AS max_cn,
			AVG(cn) AS avg_cn
		FROM
			gene_cn g
		GROUP BY 
			g.gene
		ORDER BY
			g.gene
	)
	SELECT 
		d.gene,
		d.sn::INTEGER,
		d.gn::INTEGER, 
		d.gn::NUMERIC / d.sn AS gn_pct,
		d.min_cn,
		d.max_cn,
		d.avg_cn
	FROM
		dat d;

END;
$$LANGUAGE plpgsql;

