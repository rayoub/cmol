CREATE OR REPLACE FUNCTION clean_lab_diagnosis ()
RETURNS VOID
AS $$
BEGIN

    UPDATE 
        lab_sample
    SET 
        diagnosis = 'Missing'
    WHERE
		diagnosis = '0'
		AND test_code = 'NGS Heme';

    UPDATE 
        lab_sample
    SET 
        diagnosis = 'Cancer'
    WHERE
		diagnosis = '0'
		AND test_code = 'NGS Common';

END;
$$ LANGUAGE plpgsql;