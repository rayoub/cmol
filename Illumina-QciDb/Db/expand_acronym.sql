
CREATE OR REPLACE FUNCTION expand_acronym(p_term VARCHAR, p_position INTEGER)
RETURNS VARCHAR
AS $$
DECLARE
    x_text VARCHAR DEFAULT p_term;
BEGIN

    IF p_term = 'ALL' THEN
        x_text := 'acute lymphoblastic leukemia';
    ELSIF p_term = 'AML' THEN
        x_text := 'acute myeloid leukemia';
    ELSIF p_term = 'AMML' THEN
        x_text := 'acute myelomonocytic leukemia';
    ELSIF p_term = 'APL' THEN
        x_text := 'acute promyelocytic leukemia';
    ELSIF p_term = 'NHL' THEN
        x_text := 'non-Hodgkins lymphoma';
    ELSIF p_term = 'CLL' THEN
        x_text := 'chronic lymphocytic leukemia';
    ELSIF p_term = 'CML' THEN
        x_text := 'chronic myeloid leukemia';
    ELSIF p_term = 'CMML' THEN
        x_text := 'chronic myelomonocytic leukemia';
    ELSIF p_term = 'DLBCL' THEN
        x_text := 'diffuse large B-cell lymphoma';
    ELSIF p_term = 'ET' THEN
        x_text := 'essential thrombocytosis';
    ELSIF p_term = 'GBM' THEN
        x_text := 'glioblastoma';
    ELSIF p_term = 'ITP' THEN
        x_text := 'immune thrombocytopenia';
    ELSIF p_term = 'LGL' THEN
        x_text := 'large granular lymphocytic';
    ELSIF p_term = 'MDS' THEN
        x_text := 'myelodysplastic syndrome';
    ELSIF p_term = 'MPD' THEN
        x_text := 'myeloproliferative disease';
    ELSIF p_term = 'MPN' THEN
        x_text := 'myeloproliferative neoplasm';
    ELSIF p_term = 'NSCLC' THEN
        x_text := 'non-small cell lung cancer';
    ELSIF p_term = 'PLL' THEN
        x_text := 'prolymphocytic leukemia';
    END IF;

    IF p_position = 1 THEN
        x_text := UPPER(SUBSTRING(x_text from 1 for 1)) || SUBSTRING(x_text from 2);
    END IF;

    RETURN x_text;

END;
$$ LANGUAGE plpgsql;