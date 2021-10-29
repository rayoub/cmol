
CREATE TABLE qci_report
(
    report_id VARCHAR NOT NULL,
    subject_id VARCHAR NULL,
    accession VARCHAR NULL,
    test_date DATE NULL,
    test_code VARCHAR NULL,
    clinical_finding VARCHAR NULL,
    diagnosis VARCHAR NULL,
    interpretation VARCHAR NULL,
    sex VARCHAR NULL,
    date_of_birth DATE NULL,
    ordering_physician_client VARCHAR NULL,
    ordering_physician_facility_name VARCHAR NULL,
    ordering_physician_name VARCHAR NULL,
    pathologist_name VARCHAR NULL,
    primary_tumor_site VARCHAR NULL,
    specimen_id VARCHAR NULL,
    specimen_type VARCHAR NULL,
    specimen_collection_date DATE NULL,
    lab_tested_cnv_gain VARCHAR NULL,
    lab_tested_genes VARCHAR NULL
);

CREATE UNIQUE INDEX idx_qci_report_unique ON qci_report (report_id);





