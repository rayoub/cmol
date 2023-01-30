
CREATE TABLE ion_variant
(
    sample VARCHAR NOT NULL,
    locus VARCHAR NOT NULL,
    genotype VARCHAR NULL,
    filter VARCHAR NULL,
    ref VARCHAR NULL,
    genes VARCHAR NULL,
    transcript VARCHAR NULL,
    coding VARCHAR NULL,
    protein VARCHAR NULL
);

CREATE UNIQUE INDEX idx_ion_variant_unique ON ion_variant (sample, locus);
