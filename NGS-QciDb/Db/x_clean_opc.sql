

UPDATE qci_report SET ordering_physician_client = null WHERE ordering_physician_client !~ '^\d+$';

SELECT ordering_physician_client, COUNT(*) FROM qci_report WHERE ordering_physician_client !~ '^\d+$' GROUP BY ordering_physician_client;