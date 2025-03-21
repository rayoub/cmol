CREATE TABLE lab_sample ( 
	run_id VARCHAR NOT NULL,
	specimen_id	VARCHAR NOT NULL,
	mrn VARCHAR NULL,
	accession VARCHAR NULL,
	test_code VARCHAR NOT NULL,
	reported_date DATE NULL,
	hospital_name VARCHAR NULL,
	sample_type VARCHAR NULL,
	diagnosis VARCHAR NULL,
	surgpath_id VARCHAR NULL,
	archived VARCHAR NOT NULL
);

CREATE UNIQUE INDEX idx_lab_sample_unique ON lab_sample (run_id, specimen_id);