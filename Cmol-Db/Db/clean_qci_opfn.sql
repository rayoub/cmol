CREATE OR REPLACE FUNCTION clean_qci_opfn ()
RETURNS VOID
AS $$
BEGIN

    UPDATE 
        qci_report
    SET 
        ordering_physician_facility_name = 'The University of Kansas Hospital'
    WHERE
        ordering_physician_facility_name IN 
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
        qci_report
    SET 
        ordering_physician_facility_name = null
    WHERE
        ordering_physician_facility_name LIKE 'Dr. %'
        OR ordering_physician_facility_name = 'n/a'
        OR ordering_physician_facility_name = 'Middleton, Clarice Yvette';

    UPDATE 
        qci_report
    SET 
        ordering_physician_facility_name = 'UKCC-West'
    WHERE
        ordering_physician_facility_name = 'UKCC- West';

    UPDATE 
        qci_report
    SET 
        ordering_physician_facility_name = 'The University of Kansas Hospital, Cancer Center, Westwood'
    WHERE
        ordering_physician_facility_name = 'The University of Kansas Hospital, Cancer center, Westwood';

END;
$$ LANGUAGE plpgsql;