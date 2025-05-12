
CREATE TABLE ion_sample
(
    download_type VARCHAR NOT NULL,
    zip_hash VARCHAR NOT NULL,
    assay_folder VARCHAR NOT NULL,
    sample_folder VARCHAR NULL,
    specimen_id VARCHAR NULL,
    accession_id VARCHAR NULL,
    analysis_date DATE NULL,
    mrn VARCHAR NULL
);

CREATE UNIQUE INDEX idx_ion_sample_unique ON ion_sample (zip_hash);
