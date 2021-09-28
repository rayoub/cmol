
CREATE TABLE qci_variant
(
    report_id VARCHAR NOT NULL,
    chromosome VARCHAR NOT NULL,
    position VARCHAR NOT NULL,
    reference VARCHAR NOT NULL,
    alternate VARCHAR NOT NULL,
    genotype VARCHAR NOT NULL,
    assessment VARCHAR NOT NULL,
    actionability VARCHAR NOT NULL,
    phenotype_id VARCHAR NOT NULL,
    phenotype_name VARCHAR NOT NULL,
    dbsnp VARCHAR NOT NULL,
    cadd VARCHAR NOT NULL,
    allele_fraction VARCHAR NOT NULL,
    read_depth VARCHAR NOT NULL,
    variation VARCHAR NOT NULL,
    gene VARCHAR NOT NULL,
    tc_transcript VARCHAR NOT NULL,
    tc_change VARCHAR NOT NULL,
    tc_exon_number VARCHAR NOT NULL,
    tc_region VARCHAR NOT NULL,
    pc_protein VARCHAR NOT NULL,
    pc_change VARCHAR NOT NULL,
    pc_translation_impact VARCHAR NOT NULL,
    gc_change VARCHAR NOT NULL,
    genomic_change VARCHAR NOT NULL,
    function VARCHAR NOT NULL,
    reference_count VARCHAR NOT NULL
);

CREATE UNIQUE INDEX idx_qci_variant_unique ON qci_variant (report_id);
