
CREATE TABLE qci_diagnosis
(
    id SERIAL,
    descr VARCHAR NOT NULL
);

CREATE UNIQUE INDEX idx_qci_diagnosis_unique ON qci_diagnosis (id);





