CREATE OR REPLACE FUNCTION clean_qci_diagnosis ()
RETURNS VOID
AS $$
BEGIN

    -- sentence casing
    UPDATE qci_sample SET diagnosis = sentence_case(diagnosis);

    -- fix mistakes 
    UPDATE qci_sample SET diagnosis = 'Acute lymphoblastic leukemia' WHERE diagnosis = 'Acute lymphoid leukemia';
    UPDATE qci_sample SET diagnosis = 'Acute myeloid leukemia' WHERE diagnosis = 'Acute myeloblastic leukemia';
    UPDATE qci_sample SET diagnosis = 'Chronic myeloid leukemia' WHERE diagnosis = 'Chronic myelocytic leukemia';
    UPDATE qci_sample SET diagnosis = 'Colon cancer' WHERE diagnosis = 'COLON CANCER';
    UPDATE qci_sample SET diagnosis = 'Esophageal adenocarcinoma' WHERE diagnosis = 'Esophagus adenocarcinoma';
    UPDATE qci_sample SET diagnosis = 'Follicular non-Hodgkins lymphoma' WHERE diagnosis = 'Follicular non-hodgkins lymphoma';
    UPDATE qci_sample SET diagnosis = 'Hematologic disorder' WHERE diagnosis = 'Hematologic disorders';
    UPDATE qci_sample SET diagnosis = 'Hematologic disorder' WHERE diagnosis = 'Hematological disorder';
    UPDATE qci_sample SET diagnosis = 'Hematologic neoplasm' WHERE diagnosis = 'Hematological neoplasm';
    UPDATE qci_sample SET diagnosis = 'Lung cancer' WHERE diagnosis = 'Lung';
    UPDATE qci_sample SET diagnosis = 'Lung cancer' WHERE diagnosis = 'LUNG CANCER';
    UPDATE qci_sample SET diagnosis = 'Myeloid neoplasm' WHERE diagnosis = 'Myloid neoplasm';
    UPDATE qci_sample SET diagnosis = 'NK/T-cell lymphoma' WHERE diagnosis = 'Nk/T-Cell lymphoma';
    UPDATE qci_sample SET diagnosis = 'T-cell large granular lymphocytic leukemia' WHERE diagnosis = 'T-cell large granular lymphocyte leukemia';
    UPDATE qci_sample SET diagnosis = 'Von Willebrand disease' WHERE diagnosis = 'Von willebrand disease';
    UPDATE qci_sample SET diagnosis = 'Waldenstrom macroglobulinemia' WHERE diagnosis = 'Waldenstrom macroglobuilnemia';
    UPDATE qci_sample SET diagnosis = 'Waldenstrom macroglobulinemia' WHERE diagnosis = 'Waldenstrom''S macroglobulinemia';

    TRUNCATE TABLE qci_diagnosis;
    INSERT INTO qci_diagnosis (descr) 
    SELECT DISTINCT diagnosis FROM qci_sample ORDER BY diagnosis;

END;
$$ LANGUAGE plpgsql;
