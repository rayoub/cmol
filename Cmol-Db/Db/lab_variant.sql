
CREATE TABLE lab_variant
(
	run_id VARCHAR NOT NULL,
	cmol_id VARCHAR NOT NULL,
	chromosome VARCHAR NULL,
	region VARCHAR NULL,
	variation VARCHAR NULL,
	reference VARCHAR NULL,
	alternate VARCHAR NULL,
	allele_fraction NUMERIC NULL,
	read_depth INTEGER NULL,
	gene VARCHAR NULL,
	tc_transcript VARCHAR NULL,
	tc_change VARCHAR NULL,
	tc_exon_number VARCHAR NULL,
	pc_change VARCHAR NULL,
	assessment VARCHAR NULL,
	reported VARCHAR NULL
);