CREATE OR REPLACE FUNCTION clean_qci_hospital_name ()
RETURNS VOID
AS $$
BEGIN

    UPDATE 
        qci_sample
    SET 
        hospital_name = 'The University of Kansas Hospital'
    WHERE
        hospital_name IN 
        (   
            'he University of Kansas Hospital',
            'The University of Kansa',
            'The University of Kansa Hospital',
            'The University of Kansasl',
            'The University of Kansass',
            'the University of Kansas Hospital',
            'University of Kansas',
            'University of Kansas Hospital'
        );

    UPDATE 
        qci_sample
    SET 
        hospital_name = null
    WHERE
        hospital_name LIKE 'Dr. %'
        OR hospital_name = 'n/a'
        OR hospital_name = 'Middleton, Clarice Yvette';

    UPDATE 
        qci_sample
    SET 
        hospital_name = 'UKCC-West'
    WHERE
        hospital_name = 'UKCC- West';

    UPDATE 
        qci_sample
    SET 
        hospital_name = 'The University of Kansas Hospital, Cancer Center, Westwood'
    WHERE
        hospital_name = 'The University of Kansas Hospital, Cancer center, Westwood';

END;
$$ LANGUAGE plpgsql;