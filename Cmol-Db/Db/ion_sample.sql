
CREATE TABLE ion_sample
(
    zip_name VARCHAR NOT NULL,
    assay_folder VARCHAR NOT NULL,
    sample_folder VARCHAR NULL,
    cmol_id VARCHAR NULL,
    accession_id VARCHAR NULL,
    analysis_date DATE NULL
);

CREATE UNIQUE INDEX idx_ion_sample_unique ON ion_sample (zip_name);
