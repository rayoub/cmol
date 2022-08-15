
--WITH multiples AS
--(
--    SELECT
--        report_id,
--        gene,
--        tc_transcript
--    FROM
--        qci_variant
--    GROUP BY
--        report_id,
--        gene,
--        tc_transcript
--    HAVING
--        COUNT(*) > 1
--)
--SELECT
--    r.test_code,
--    r.test_date,
--    r.report_id,
--    r.accession,
--    r.diagnosis,
--    v.gene,
--    v.tc_transcript,
--    v.tc_change,
--    v.pc_protein,
--    v.pc_change
--FROM
--    qci_report r 
--    INNER JOIN qci_variant v 
--        ON r.report_id = v.report_id
--    INNER JOIN multiples m
--        ON v.report_id = m.report_id 
--        AND v.gene = m.gene 
--        AND v.tc_transcript = m.tc_transcript
--ORDER BY
--    r.test_code,
--    r.test_date,
--    r.report_id,
--    v.gene,
--    v.tc_transcript
--;

SELECT
    r.accession,
    r.test_date,
    r.test_code,
    r.clinical_finding,
    r.diagnosis,
    r.primary_tumor_site,
    r.specimen_type,
    v.gene,
    v.variation,
    v.chromosome,
    v.position,
    v.reference,
    v.alternate,
    v.tc_transcript,
    v.tc_change,
    v.pc_protein,
    v.pc_change,
    v.read_depth,
    v.allele_fraction,
    v.assessment
FROM    
    qci_report r
    INNER JOIN qci_variant v 
        ON r.report_id = v.report_id
WHERE
    accession 
IN 
    ('M23811', 'T74011')
ORDER BY
    --CASE WHEN assessment = 'Pathogenic' THEN 1 WHEN assessment = 'Likely Pathogenic' THEN 2 ELSE 3 END, 
    chromosome::INTEGER,
    position::INTEGER
;

