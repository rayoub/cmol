
SELECT
    diagnosis,
    COUNT(*)
FROM
    qci_report
GROUP BY  
    diagnosis
ORDER BY   
    diagnosis;

-- sentence casing
--UPDATE qci_report SET diagnosis = sentence_case(diagnosis);
--
---- fix mistakes 
--UPDATE qci_report SET diagnosis = 'Acute lymphoblastic leukemia' WHERE diagnosis = 'Acute lymphoid leukemia';
--UPDATE qci_report SET diagnosis = 'Acute myeloid leukemia' WHERE diagnosis = 'Acute myeloblastic leukemia';
--UPDATE qci_report SET diagnosis = 'Chronic myeloid leukemia' WHERE diagnosis = 'Chronic myelocytic leukemia';
--UPDATE qci_report SET diagnosis = 'Colon cancer' WHERE diagnosis = 'COLON CANCER';
--UPDATE qci_report SET diagnosis = 'Esophageal adenocarcinoma' WHERE diagnosis = 'Esophagus adenocarcinoma';
--UPDATE qci_report SET diagnosis = 'Follicular non-Hodgkins lymphoma' WHERE diagnosis = 'Follicular non-hodgkins lymphoma';
--UPDATE qci_report SET diagnosis = 'Hematologic disorder' WHERE diagnosis = 'Hematologic disorders';
--UPDATE qci_report SET diagnosis = 'Hematologic disorder' WHERE diagnosis = 'Hematological disorder';
--UPDATE qci_report SET diagnosis = 'Hematologic neoplasm' WHERE diagnosis = 'Hematological neoplasm';
--UPDATE qci_report SET diagnosis = 'Lung cancer' WHERE diagnosis = 'Lung';
--UPDATE qci_report SET diagnosis = 'Lung cancer' WHERE diagnosis = 'LUNG CANCER';
--UPDATE qci_report SET diagnosis = 'Myeloid neoplasm' WHERE diagnosis = 'Myloid neoplasm';
--UPDATE qci_report SET diagnosis = 'NK/T-cell lymphoma' WHERE diagnosis = 'Nk/T-Cell lymphoma';
--UPDATE qci_report SET diagnosis = 'T-cell large granular lymphocytic leukemia' WHERE diagnosis = 'T-cell large granular lymphocyte leukemia';
--UPDATE qci_report SET diagnosis = 'Von Willebrand disease' WHERE diagnosis = 'Von willebrand disease';
--UPDATE qci_report SET diagnosis = 'Waldenstrom macroglobulinemia' WHERE diagnosis = 'Waldenstrom macroglobuilnemia';
--UPDATE qci_report SET diagnosis = 'Waldenstrom macroglobulinemia' WHERE diagnosis = 'Waldenstrom''S macroglobulinemia';




