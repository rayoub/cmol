
SELECT
    qr.ordering_physician_client AS mrn,
    qr.accession,
    qr.test_date,
    qr.test_code,
    qr.diagnosis,
    qr.interpretation,
    SUBSTRING(REPLACE(qr.ordering_physician_name, ',', ''), 0, 16) AS ordering_physician_name,
    qv.gene,
    qv.allele_fraction,
    qv.tc_transcript,
    qv.tc_change,
    qv.pc_protein,
    qv.pc_change,
    qv.assessment
FROM
    qci_report qr 
    INNER JOIN qci_variant qv 
        ON qv.report_id = qr.report_id
WHERE
    qv.gene = 'KRAS' AND qv.pc_change LIKE '%G12C%' AND qr.ordering_physician_client IS NOT NULL
ORDER BY    
    qr.ordering_physician_client, -- MRN
    qr.accession,
    qr.test_date;