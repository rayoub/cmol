
-- fix the other clean scripts and then do a reimport of everything


SELECT  
    diagnosis,
    COUNT(*)
FROM    
    qci_report
GROUP BY  
    diagnosis
ORDER BY   
    diagnosis;

UPDATE qci_report SET diagnosis = INITCAP(diagnosis);

UPDATE qci_report SET diagnosis = 'B-Cell Acute Lymphoblastic Leukemia' WHERE diagnosis = 'B Cell ALL'; 
UPDATE qci_report SET diagnosis = 'B-Cell Acute Lymphoblastic Leukemia' WHERE diagnosis = 'Bcell ALL'; 
UPDATE qci_report SET diagnosis = 'B-Cell Acute Lymphoblastic Leukemia' WHERE diagnosis = 'B-Cell ALL'; 
UPDATE qci_report SET diagnosis = 'B-Cell Lymphoma' WHERE diagnosis = 'Bcell Lymphoma';
UPDATE qci_report SET diagnosis = 'B-Cell NHL' WHERE diagnosis = 'Bcell NHL';
UPDATE qci_report SET diagnosis = 'Chronic Myelomonocytic Leukemia' WHERE diagnosis = 'CMML';
UPDATE qci_report SET diagnosis = 'Diffuse Large B-Cell Lymphoma' WHERE diagnosis = 'DLBCL';
UPDATE qci_report SET diagnosis = 'Esophageal Adenocarcinoma' WHERE diagnosis = 'Esophagus Adenocarcinoma';
UPDATE qci_report SET diagnosis = 'Hepatosplenic T-Cell Lymphoma' WHERE diagnosis = 'Hepatosplenic Tcell Lymphoma'; 
UPDATE qci_report SET diagnosis = 'Large Granular Lymphocytic Leukemia' WHERE diagnosis = 'LGL Leukemia';
UPDATE qci_report SET diagnosis = 'Lung Cancer' WHERE diagnosis = 'Lung';
UPDATE qci_report SET diagnosis = 'Monoclonal B-Cell Lymphocytosis' WHERE diagnosis = 'Monoclonal B Cell Lymphocytosis';
UPDATE qci_report SET diagnosis = 'Monoclonal B-Cell Lymphocytosis' WHERE diagnosis = 'Monoclonal Bcell Lymphocytosis';
UPDATE qci_report SET diagnosis = 'Myeloid Neoplasm' WHERE diagnosis = 'Myloid Neoplasm';
UPDATE qci_report SET diagnosis = 'Non-Small Cell Lung Cancer' WHERE diagnosis = 'NSCLC';
UPDATE qci_report SET diagnosis = 'Prolymphocytic Leukemia' WHERE diagnosis = 'PLL';
UPDATE qci_report SET diagnosis = 'T-Cell ALL' WHERE diagnosis = 'Tcell ALL';
UPDATE qci_report SET diagnosis = 'T-Cell Large Granular Lymphocytic Leukemia' WHERE diagnosis = 'T-Cell Large Granular Lymphocyte Leukemia';
UPDATE qci_report SET diagnosis = 'T-Cell Large Granular Lymphocytic Leukemia' WHERE diagnosis = 'Tcell Large Granular Lymphocytic Leukemia';
UPDATE qci_report SET diagnosis = 'T-Cell Leukemia/Lymphoma' WHERE diagnosis = 'Tcell Leukemia/Lymphoma'; 
UPDATE qci_report SET diagnosis = 'T-Cell Lymphoma' WHERE diagnosis = 'Tcell Lymphoma';
UPDATE qci_report SET diagnosis = 'T-Cell Lymphoproliferative Disorder' WHERE diagnosis = 'Tcell Lymphoproliferative Disorder';
UPDATE qci_report SET diagnosis = 'Waldenstrom Macroglobulinemia' WHERE diagnosis = 'Waldenstrom Macroglobuilnemia';
UPDATE qci_report SET diagnosis = 'Waldenstrom Macroglobulinemia' WHERE diagnosis = 'Waldenstrom''s Macroglobulinemia';