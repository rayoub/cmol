
CREATE OR REPLACE FUNCTION get_gc_referrals (
    p_from_date DATE DEFAULT NULL,
    p_to_date DATE DEFAULT NULL)
RETURNS TABLE (
    sample_id VARCHAR,
    mrn VARCHAR,
    accession VARCHAR,
    age INTEGER,
    test_date DATE,
    test_code VARCHAR,
    tumor_site VARCHAR,
    diagnosis VARCHAR,
    interpretation VARCHAR,
    physician VARCHAR,
    genes VARCHAR,
    notified INTEGER
)
AS $$
BEGIN

    RETURN QUERY
    WITH reports AS 
    (
        SELECT
            qr.sample_id,
            qr.mrn,
            qr.accession,
            DATE_PART('year', AGE(qr.date_of_birth))::INTEGER AS age,
            qr.test_date,
            qr.test_code,
            qr.primary_tumor_site AS tumor_site,
            qr.diagnosis,
            qr.interpretation,
            REPLACE(qr.physician_name, ',', '')::VARCHAR AS physician,
            qr.primary_tumor_site
        FROM
            qci_sample qr 
        WHERE 
            qr.accession ~* '^[a-z][0-9]+$'
            AND qr.mrn IS NOT NULL
            AND (p_from_date IS NULL OR qr.test_date >= p_from_date)
            AND (p_to_date IS NULL OR qr.test_date <= p_to_date)
    ),
    genes AS 
    (
        SELECT
            g.gene,
            g.age_restricted,
            g.exclude_brain,
            g.exclude_renal,
            g.biallelic_only,
            g.gene 
            ||
            CASE WHEN g.age_restricted = 1 THEN '<span class="badge rounded-pill bg-primary" style="margin-left:5px;" title="age restricted to < 30">1</span>' ELSE '' END
            ||
            CASE WHEN g.exclude_brain = 1 THEN '<span class="badge rounded-pill bg-primary" style="margin-left:5px;" title="excluding brain tumors">2</span>' ELSE '' END
            ||
            CASE WHEN g.exclude_renal = 1 THEN '<span class="badge rounded-pill bg-primary" style="margin-left:5px;" title="excluding kideny tumors">3</span>' ELSE '' END
            ||
            CASE WHEN g.exclude_renal = 1 THEN '<span class="badge rounded-pill bg-primary" style="margin-left:5px;" title="further investigation required to determine biallelic only">4</span>' ELSE '' END
            AS gene_html
        FROM
            gc_gene g
    ),
    grouped AS 
    (
        SELECT
            r.sample_id,
            r.mrn,
            r.accession,
            r.age,
            r.test_date,
            r.test_code,
            r.tumor_site,
            r.diagnosis,
            r.interpretation,
            r.physician,
            STRING_AGG(DISTINCT g.gene_html, ', ' ORDER BY g.gene_html)::VARCHAR AS genes
        FROM
            reports r
            INNER JOIN qci_variant qv 
                ON qv.sample_id = r.sample_id
            INNER JOIN genes g 
                ON g.gene = qv.gene
        WHERE 
            (g.age_restricted = 0 OR r.age < 30)
            AND (g.exclude_brain = 0 OR r.tumor_site <> 'Brain')
            AND (g.exclude_renal = 0 OR r.tumor_site <> 'Kidney')
        GROUP BY
            r.sample_id,
            r.mrn,
            r.accession,
            r.age,
            r.test_date,
            r.test_code,
            r.tumor_site,
            r.diagnosis,
            r.interpretation,
            r.physician
    )
    SELECT
        g.sample_id,
        g.mrn,
        g.accession,
        g.age,
        g.test_date,
        g.test_code,
        g.tumor_site,
        g.diagnosis,
        g.interpretation,
        g.physician,
        g.genes,
        CASE WHEN n.accession IS NOT NULL THEN 1 ELSE 0 END AS notified
    FROM
        grouped g
        LEFT JOIN gc_notified n 
            ON n.accession = g.accession
    ORDER BY    
        g.test_date DESC,
        g.accession;

END;
$$LANGUAGE plpgsql;

