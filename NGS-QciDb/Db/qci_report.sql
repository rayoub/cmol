
CREATE TABLE qci_report
(
    report_id VARCHAR NOT NULL,
    subject_id VARCHAR NOT NULL,
    accession VARCHAR NOT NULL,
    test_date VARCHAR NOT NULL,
    test_code VARCHAR NOT NULL,
    clinical_finding VARCHAR NOT NULL,
    diagnosis VARCHAR NOT NULL,
    interpretation VARCHAR NOT NULL,
    patient_name VARCHAR NOT NULL,
    sex VARCHAR NOT NULL,
    date_of_birth VARCHAR NOT NULL,
    ordering_physician_client VARCHAR NOT NULL,
    ordering_physicianFacility_name VARCHAR NOT NULL,
    ordering_physician_name VARCHAR NOT NULL,
    pathologist_name VARCHAR NOT NULL,
    primary_tumor_site VARCHAR NOT NULL,
    specimen_id VARCHAR NOT NULL,
    specimen_type VARCHAR NOT NULL,
    specimen_collection_date VARCHAR NOT NULL,
    specimen_dissection VARCHAR NOT NULL,
    specimen_tumor_content VARCHAR NOT NULL,
    lab_tested_cnv_gain VARCHAR NOT NULL,
    lab_tested_genes VARCHAR NOT NULL,
    lab_transcript_ids VARCHAR NOT NULL,
    sample_detected_gene_fusions VARCHAR NOT NULL,
    sample_detected_gene_negative VARCHAR NOT NULL,
    version VARCHAR NOT NULL
);

CREATE UNIQUE INDEX idx_qci_report_unique ON qci_report (report_id);





