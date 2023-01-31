
CREATE TABLE gc_gene
(
    gene VARCHAR NOT NULL
);

CREATE UNIQUE INDEX idx_gc_gene ON gc_gene (gene);

