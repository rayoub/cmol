SELECT
    qr.ordering_physician_client AS mrn,
    qr.report_id,
    qr.accession,
    qr.test_date,
    qr.test_code,
    qr.diagnosis,
    qr.interpretation,
    REPLACE(qr.ordering_physician_name, ',', '') AS ordering_physician_name,
    REPLACE(qr.ordering_physician_facility_name, ',', '') AS ordering_physician_facility_name,
    qv.gene,
    qv.allele_fraction,
    qv.tc_transcript,
    qv.tc_change,
    qv.tc_exon_number,
    qv.pc_protein,
    qv.pc_change,
    qv.assessment
FROM
    qci_report qr 
    INNER JOIN qci_variant qv 
        ON qv.report_id = qr.report_id
WHERE
    qr.diagnosis = 'Acute myeloid leukemia'
    AND qr.ordering_physician_client IS NOT NULL
    AND qv.gene = 'TP53'
ORDER BY    
    qr.ordering_physician_client,
    qr.report_id,
    qr.accession;