
CREATE TABLE ion_mrn
(
    mrn VARCHAR NOT NULL,
    accn VARCHAR NOT NULL
);

CREATE UNIQUE INDEX idx_ion_mrn_unique ON ion_mrn (mrn);
