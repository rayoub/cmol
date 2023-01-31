
CREATE TABLE gc_notified
(
    accession VARCHAR NOT NULL
);

CREATE UNIQUE INDEX idx_gc_notified ON gc_notified (accession);

