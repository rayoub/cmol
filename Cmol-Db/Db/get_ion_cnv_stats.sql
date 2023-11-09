
CREATE OR REPLACE FUNCTION get_ion_cnv_stats (p_type_id INTEGER)
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
			v.copy_number::NUMERIC,
			v.copy_number_type
		FROM
			ion_sample AS s
			INNER JOIN ion_variant AS v  -- assumed 1-1
				ON s.zip_name = v.zip_name
		WHERE
			s.download_type = 'Filtered'	
			AND type = 'CNV'
			AND	genes IS NOT NULL
			AND copy_number IS NOT NULL 
			AND subtype IS NULL
	),
	gene_cn_filtered AS 
	(
		SELECT
			g.zip_name,
			g.gene,
			g.copy_number 
		FROM
			gene_cn g 
		WHERE
			(p_type_id = 1 AND g.copy_number_type = 'Amplification')
			OR (p_type_id = 2 AND g.copy_number_type = 'Deletion')
			OR (p_type_id = 3 AND g.copy_number_type IS NULL AND g.copy_number > 4)
			OR (p_type_id = 4 AND g.copy_number_type IS NULL AND g.copy_number < 2)
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
			MIN(g.copy_number) AS min_cn,
			MAX(g.copy_number) AS max_cn,
			AVG(g.copy_number) AS avg_cn
		FROM
			gene_cn_filtered g
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

