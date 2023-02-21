
TRUNCATE TABLE gc_gene;

INSERT INTO gc_gene (gene, age_restricted, exclude_brain, exclude_renal, biallelic_only)
VALUES 
    ('APCi', 1, 0, 0, 0),
    ('ATM', 0, 0, 0, 0),
    ('BAP1', 0, 0, 0, 0),
    ('BRCA1', 0, 0, 0, 0),
    ('BRCA2', 0, 0, 0, 0),
    ('BRIP1', 0, 0, 0, 0),
    ('CEBPA', 0, 0, 0, 0),
    ('CHEK2', 0, 0, 0, 0),
    ('DDX41', 0, 0, 0, 0),
    ('ETV6', 0, 0, 0, 0),
    ('FH', 0, 0, 0, 0),
    ('FLCN', 0, 0, 0, 0),
    ('GATA2', 0, 0, 0, 0),
    ('MITF', 0, 0, 0, 0),
    ('MLH1', 0, 0, 0, 0),
    ('MSH2', 0, 0, 0, 0),
    ('MSH6', 0, 0, 0, 0),
    ('MUTYH', 0, 0, 0, 1),
    ('NF1', 1, 0, 0, 0),
    ('PALB2', 0, 0, 0, 0),
    ('PMS2', 0, 0, 0, 0),
    ('POLE', 0, 0, 0, 0),
    ('POT1', 0, 0, 0, 0),
    ('RAD51C', 0, 0, 0, 0),
    ('RAD51D', 0, 0, 0, 0),
    ('RB1', 1, 0, 0, 0),
    ('RET', 0, 0, 0, 0),
    ('RUNX1', 0, 0, 0, 0),
    ('SDHB', 0, 0, 0, 0),
    ('SDHC', 0, 0, 0, 0),
    ('SDHD', 0, 0, 0, 0),
    ('SUFU', 0, 0, 0, 0),
    ('TP53', 1, 1, 0, 0),
    ('TSC2', 0, 0, 0, 0),
    ('VHL', 0, 0, 1, 0);

    