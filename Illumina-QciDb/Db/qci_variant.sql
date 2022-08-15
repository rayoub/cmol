
CREATE TABLE qci_variant
(
    report_id VARCHAR NOT NULL,
    chromosome VARCHAR NULL,
    position INTEGER NULL,
    reference VARCHAR NULL,
    alternate VARCHAR NULL,
    genotype VARCHAR NULL,
    assessment VARCHAR NULL,
    actionability VARCHAR NULL,
    phenotype_id VARCHAR NULL,
    phenotype_name VARCHAR NULL,
    dbsnp VARCHAR NULL,
    cadd NUMERIC NULL,
    allele_fraction NUMERIC NULL,
    read_depth INTEGER NULL,
    variation VARCHAR NULL,
    gene VARCHAR NULL,
    tc_transcript VARCHAR NULL,
    tc_change VARCHAR NULL,
    tc_exon_number INTEGER NULL,
    tc_region VARCHAR NULL,
    pc_protein VARCHAR NULL,
    pc_change VARCHAR NULL,
    pc_translation_impact VARCHAR NULL,
    gc_change VARCHAR NULL,
    function VARCHAR NULL,
    reference_count INTEGER NULL
);
