
--SELECT
--    test_code,
--    COUNT(*)
--FROM
--    qci_report
--GROUP BY
--    test_code
--ORDER BY   
--    test_code;

-- don't waste time with low frequency junk data from a long time ago

DELETE FROM 
    qci_variant 
WHERE 
    report_id IN
        (
            SELECT
                report_id
            FROM    
                qci_report
            WHERE   
                test_code IS NULL OR
                test_code IN (
                    '1561898', 
                    '7816695',
                    'common', 
                    'EGFR', 
                    'GIST',
                    'heme',
                    'HEME',
                    'Hematologic Neoplasms Targeted Gene Panel (65) by NGS',
                    'Hot Start',
                    'KUMC_HemOnc_v1',
                    'NGS 17 gene panel',
                    'NGS HEME or NGS Common (type the appropriate code for each sample)',
                    'Uterine cancer'
                )
        );

DELETE FROM    
    qci_report
WHERE   
    test_code IS NULL OR
    test_code IN (
        '1561898', 
        '7816695',
        'common', 
        'EGFR', 
        'GIST',
        'heme',
        'HEME',
        'Hematologic Neoplasms Targeted Gene Panel (65) by NGS',
        'Hot Start',
        'KUMC_HemOnc_v1',
        'NGS 17 gene panel',
        'NGS HEME or NGS Common (type the appropriate code for each sample)',
        'Uterine cancer'
    );

-- combine test codes

UPDATE 
    qci_report 
SET 
    test_code = 'NGS Common' 
WHERE
    test_code IN (
        'NGS COMMON',
        'ngs common',
        'NGS common',
        'NGS COMMOM',
        'Common 14',
        'Common 24'
    );

UPDATE 
    qci_report 
SET 
    test_code = 'NGS Heme' 
WHERE
    test_code IN (
        'ngs heme',
        'NGS HEME'
    );

UPDATE 
    qci_report
SET
    test_code = 'NGS Heme One'
WHERE
    test_code IN (
        'Heme 141_One'
    );

UPDATE 
    qci_report
SET
    test_code = 'NGS Comprehensive One'
WHERE
    test_code IN (
        'Comprehensive 275_One'
    );

UPDATE 
    qci_report
SET
    test_code = 'NGS Common One'
WHERE
    test_code IN (
        'Common 24_One'
    );


-- panel numbering is not accurate, use lab tested genes instead
-- however, preserve 'Common 14' for now since that is a special case

UPDATE
    qci_report
SET
    test_code = 'NGS Heme'
WHERE   
    test_code = 'Heme 141';

UPDATE
    qci_report
SET
    test_code = 'NGS Comprehensive'
WHERE   
    test_code = 'Comprehensive 275';


