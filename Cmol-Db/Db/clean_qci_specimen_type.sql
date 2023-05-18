CREATE OR REPLACE FUNCTION clean_qci_specimen_type ()
RETURNS VOID
AS $$
BEGIN

    UPDATE
        qci_sample
    SET 
        specimen_type = null
    WHERE
        specimen_type LIKE 'D0%' OR
        specimen_type IN (
            '8025712',
            'H55625',
            'n/a',
            'specimen type'
        );

    UPDATE
        qci_sample
    SET 
        specimen_type = INITCAP(specimen_type)
    WHERE
        specimen_type IN (
            'biopsy',
            'blood',
            'bone marrow',
            'Stem cells'
        );

    -- ugh typos

    UPDATE qci_sample SET specimen_type = 'Blood (57% blasts)' WHERE specimen_type = 'Blood (57% blasts in blood)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (3% blasts)' WHERE specimen_type = 'Bone marrow  (3% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (>90% lymphomatous infiltrate)' WHERE specimen_type = 'Bone Marrow (>90% lymphomatous infiltrate';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (0% blasts)' WHERE specimen_type = 'Bone Marrow (0% blasts';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (0% blasts)' WHERE specimen_type = 'Bone Marrow (0% blast)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (0% blasts)' WHERE specimen_type = 'Bone marrow (0% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (1% blasts)' WHERE specimen_type = 'Bone marrow (1% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (1% blasts)' WHERE specimen_type = 'Bone Marrow (1% blasts)v';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (1% blasts)' WHERE specimen_type = 'Bone Marrow (1% blasts0';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (16% neoplastic T-cells)' WHERE specimen_type = 'Bone Marrow (16% neoplastic Tcells)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (2% blasts)' WHERE specimen_type = 'Bone Marrow (2% blast)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (2% blasts)' WHERE specimen_type = 'Bone marrow (2% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (2% blasts)' WHERE specimen_type = 'Bone Marrow (2% blasts0';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (24% blasts)' WHERE specimen_type = 'Bone marrow (24% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (25% blasts)' WHERE specimen_type = 'Bone Marrow (25%)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (3% blasts)' WHERE specimen_type = 'Bone marrow (3% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (3% blasts)' WHERE specimen_type = 'Bone Marrow (3% blasts0';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (31% blasts)' WHERE specimen_type = 'Bone Marrow (31% blast)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (32% atypical T-cells)' WHERE specimen_type = 'Bone Marrow (32% atypical T cells)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (35% blasts)' WHERE specimen_type = 'Bone marrow (35% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (4% blasts)' WHERE specimen_type = 'Bone Marrow (4% blasts0';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (4% tumor content)' WHERE specimen_type = 'Bone marrow (4% tumor content)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (54% blasts)' WHERE specimen_type = 'Bone Marrow (54% blast)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (7% neoplastic T-cell lymphoblasts)' WHERE specimen_type = 'Bone Marrow (7% neoplastic Tcell lymphoblasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (70% blasts)' WHERE specimen_type = 'Bone marrow (70% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (72% blasts)' WHERE specimen_type = 'Bone marrow (72% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (80% blasts)' WHERE specimen_type = 'Bone marrow (80% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (83% blasts)' WHERE specimen_type = 'Bone marrow (83% blasts)';
    UPDATE qci_sample SET specimen_type = 'Blood or Bone Marrow' WHERE specimen_type = 'Blood or Bone marrow';
    UPDATE qci_sample SET specimen_type = 'Blood or Bone Marrow' WHERE specimen_type = 'Bone Marrow or Blood';
    UPDATE qci_sample SET specimen_type = 'Biopsy' WHERE specimen_type = 'Bone Marrow Biopsy';
    UPDATE qci_sample SET specimen_type = 'FFPE (40% tumor content)' WHERE specimen_type = 'FFPE  (40% tumor content)';
    UPDATE qci_sample SET specimen_type = 'FFPE (70% tumor content)' WHERE specimen_type = 'FFPE  (70% tumor content)';
    UPDATE qci_sample SET specimen_type = 'FFPE' WHERE specimen_type = 'FFPE (% tumor content)';
    UPDATE qci_sample SET specimen_type = 'FFPE (0% tumor content)' WHERE specimen_type = 'FFPE (00% tumor content)';
    UPDATE qci_sample SET specimen_type = 'FFPE (10% tumor content)' WHERE specimen_type = 'FFPE (10% tumor content';
    UPDATE qci_sample SET specimen_type = 'FFPE' WHERE specimen_type = 'FFPE (20';
    UPDATE qci_sample SET specimen_type = 'FFPE (30% tumor content)' WHERE specimen_type = 'FFPE (30% tumor content0';
    UPDATE qci_sample SET specimen_type = 'FFPE (50% tumor content)' WHERE specimen_type = 'FFPE (50 % tumor content)';
    UPDATE qci_sample SET specimen_type = 'FFPE (50% tumor content)' WHERE specimen_type = 'FFPE (50% tumor content';
    UPDATE qci_sample SET specimen_type = 'FFPE (50% tumor content)' WHERE specimen_type = 'FFPE (50% tumor content_';
    UPDATE qci_sample SET specimen_type = 'FFPE (60% tumor content)' WHERE specimen_type = 'FFPE (60% tumor)';
    UPDATE qci_sample SET specimen_type = 'FFPE (75% tumor content)' WHERE specimen_type = 'FFPE (75 % tumor content)';
    UPDATE qci_sample SET specimen_type = 'FFPE (85% tumor content)' WHERE specimen_type = 'FFPE (85%)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (18% blasts)' WHERE specimen_type = 'Marrow (18% blasts)';
    UPDATE qci_sample SET specimen_type = 'Bone Marrow (46% blasts)' WHERE specimen_type = 'Marrow (46% blasts)';

END;
$$ LANGUAGE plpgsql;