
CREATE TABLE gc_gene
(
    gene VARCHAR NOT NULL,
    age_restricted INTEGER NOT NULL,
    exclude_brain INTEGER NOT NULL,
    exclude_renal INTEGER NOT NULL,
    biallelic_only INTEGER NOT NULL
);

CREATE UNIQUE INDEX idx_gc_gene ON gc_gene (gene);

