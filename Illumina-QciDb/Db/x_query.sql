
WITH multiples AS
(
    SELECT
        report_id,
        gene,
        tc_transcript
    FROM
        qci_variant
    GROUP BY
        report_id,
        gene,
        tc_transcript
    HAVING
        COUNT(*) > 1
)
SELECT
    r.test_code,
    r.test_date,
    r.report_id,
    r.accession,
    r.diagnosis,
    v.gene,
    v.tc_transcript,
    v.tc_change,
    v.pc_protein,
    v.pc_change
FROM
    qci_report r 
    INNER JOIN qci_variant v 
        ON r.report_id = v.report_id
    INNER JOIN multiples m
        ON v.report_id = m.report_id 
        AND v.gene = m.gene 
        AND v.tc_transcript = m.tc_transcript
ORDER BY
    r.test_code,
    r.test_date,
    r.report_id,
    v.gene,
    v.tc_transcript
;