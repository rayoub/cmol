
CREATE TABLE qci_sample
(
    sample_id VARCHAR NOT NULL,
    mrn VARCHAR NULL, 
    received_date DATE NOT NULL,
    test_date DATE NOT NULL,
    test_code VARCHAR NULL,
    clinical_finding VARCHAR NULL,
    diagnosis VARCHAR NULL,
    interpretation VARCHAR NULL,
    sex VARCHAR NULL,
    date_of_birth DATE NULL,
    hospital_name VARCHAR NULL,
    physician_name VARCHAR NULL,
    primary_tumor_site VARCHAR NULL,
    specimen_id VARCHAR NULL, 
    specimen_type VARCHAR NULL,
    specimen_collection_date DATE NULL, 
    lab_tested_cnv_gain VARCHAR NULL,
    lab_tested_genes VARCHAR NULL
);

CREATE UNIQUE INDEX idx_qci_sample_unique ON qci_sample (sample_id);



