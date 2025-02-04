
-- *** check diagnosis

--SELECT
--    diagnosis,
--    COUNT(*)
--FROM
--    qci_report
--GROUP BY  
--    diagnosis
--ORDER BY   
--    diagnosis;

-- *** check opc

--SELECT ordering_physician_client, COUNT(*) FROM qci_report WHERE ordering_physician_client !~ '^\d+$' GROUP BY ordering_physician_client;

-- *** check opfn

--SELECT
--    ordering_physician_facility_name,
--    COUNT(*)
--FROM
--    qci_report
--GROUP BY
--    ordering_physician_facility_name
--ORDER BY
--    ordering_physician_facility_name;

-- *** check pts

--SELECT
--    primary_tumor_site,
--    COUNT(*)
--FROM    
--    qci_report
--GROUP BY
--    primary_tumor_site
--ORDER BY
--    primary_tumor_site;

-- *** check specimen_id

--SELECT specimen_id, COUNT(*) FROM qci_report WHERE specimen_id NOT LIKE 'D%' GROUP BY specimen_id ORDER BY specimen_id;

-- *** check specimen_type

--SELECT 
--    specimen_type,
--    COUNT(*)
--FROM    
--    qci_report
--GROUP BY
--    specimen_type
--ORDER BY    
--    specimen_type;

-- *** check test_code

--SELECT
--    test_code,
--    COUNT(*)
--FROM
--    qci_report
--GROUP BY
--    test_code
--ORDER BY   
--    test_code;



