
$csvHeaderDefs = @(

        "FilePath",
        "FileName",
        "AssayId",
        "AnalyzedBy",
        "Panel",
        "AverageCoverage",
        "Accession#",
        "SampleId",
        "Date",
        "CollectionDate",
        "Cutoff",
        "BGWVersion",
        "MRN",
        "OrderingPhysician",
        "Diagnosis",
        "TestOrdered",
        "Result",
        "Notes",
        "SpecimanType",
        "SurgPathId",
        "Chromosome",
        "Region",
        "Type",
        "Reference",
        "Allele",
        "ReferenceAllele",
        "Count",
        "Coverage",
        "Frequency",
        "AverageQuality",
        "Gene",
        "DNAChange",
        "ProteinChange",
        "LongestProteinChange",
        "LongestDNAChange",
        "Assessment",
        "Reportability",
        "Frequency",
        "Pathogenicity",
        "Exon",
        "DNAVariant",
        "ProteinVariant",
        "RefSeqId"
    )

# header defs

$panelHeaderDefs = 
    @( 
        @{ Name = "AssayId";            Row = 1;    Column = 2 }
        @{ Name = "AnalyzedBy";         Row = 2;    Column = 2 }
        @{ Name = "Panel";              Row = 3;    Column = 2 }
        @{ Name = "AverageCoverage";    Row = 4;    Column = 2 }
        @{ Name = "Accession#";         Row = 6;    Column = 2 }
        
        @{ Name = "SampleId";           Row = 1;    Column = 4 }
        @{ Name = "Date";               Row = 2;    Column = 4 }
        @{ Name = "StarField";          Row = 3;    Column = 4 }
        @{ Name = "BGWVersion";         Row = 4;    Column = 4 }
        @{ Name = "MRN";                Row = 5;    Column = 4 }
        @{ Name = "OrderingPhysician";  Row = 6;    Column = 4 }
    )

##############################################################################

# 181+
$hemeHeaderDefs =
    @( 
        @{ Name = "LogNote";            Row = 1;    Column = 5 }        

        @{ Name = "TestOrdered";        Row = 1;    Column = 14 }
        @{ Name = "Result";             Row = 2;    Column = 14 }
        @{ Name = "Notes";              Row = 3;    Column = 14 }

        @{ Name = "SpecimanType";       Row = 1;    Column = 27 }
        @{ Name = "SurgPathId";         Row = 2;    Column = 27 }
        
        # null field
        @{ Name = "Diagnosis";          Row = 0;    Column = 0 }
    )

# 184+
$hemeHeaderDefs2 =
    @( 
        @{ Name = "Diagnosis";          Row = 6;    Column = 7 }
        
        @{ Name = "TestOrdered";        Row = 1;    Column = 13 }
        @{ Name = "Result";             Row = 2;    Column = 13 }
        @{ Name = "Notes";              Row = 3;    Column = 13 }

        @{ Name = "SpecimanType";       Row = 1;    Column = 27 }
        @{ Name = "SurgPathId";         Row = 2;    Column = 27 }
        
        # null field
        @{ Name = "LogNote";          Row = 0;    Column = 0 }
    )

##############################################################################

# 180+
$commonHeaderDefs =
    @( 
        @{ Name = "LogNote";            Row = 1;    Column = 5 }
        
        @{ Name = "TestOrdered";        Row = 1;    Column = 12 }
        @{ Name = "Result";             Row = 3;    Column = 12 }
        @{ Name = "Notes";              Row = 4;    Column = 12 }

        @{ Name = "SpecimanType";       Row = 1;    Column = 27 }
        @{ Name = "SurgPathId";         Row = 2;    Column = 27 }

        # null field
        @{ Name = "Diagnosis";          Row = 0;    Column = 0 } 
    )

# 183+
$commonHeaderDefs2 =
    @( 
        @{ Name = "LogNote";            Row = 1;    Column = 5 }        

        @{ Name = "TestOrdered";        Row = 1;    Column = 12 }
        @{ Name = "Result";             Row = 3;    Column = 12 }
        @{ Name = "Diagnosis";          Row = 4;    Column = 12 } 
        @{ Name = "Notes";              Row = 5;    Column = 12 }

        @{ Name = "SpecimanType";       Row = 1;    Column = 27 }
        @{ Name = "SurgPathId";         Row = 2;    Column = 27 }
    )

# 185+
$commonHeaderDefs3 =
    @( 
        @{ Name = "Diagnosis";          Row = 6;    Column = 8 }
        
        @{ Name = "TestOrdered";        Row = 1;    Column = 13 }
        @{ Name = "Result";             Row = 2;    Column = 13 }
        @{ Name = "Notes";              Row = 3;    Column = 13 }

        @{ Name = "SpecimanType";       Row = 1;    Column = 27 }
        @{ Name = "SurgPathId";         Row = 2;    Column = 27 }
        
        # null field
        @{ Name = "LogNote";            Row = 0;    Column = 0 }
    )

##############################################################################

# 179+
$compHeaderDefs =
    @( 
        @{ Name = "LogNote";            Row = 1;    Column = 5 }
    
        @{ Name = "TestOrdered";        Row = 1;    Column = 14 }
        @{ Name = "Result";             Row = 2;    Column = 14 }
        @{ Name = "Notes";              Row = 3;    Column = 14 }
 
        @{ Name = "SpecimanType";       Row = 1;    Column = 27 }
        @{ Name = "SurgPathId";         Row = 2;    Column = 27 }
       
        # null field
        @{ Name = "Diagnosis";          Row = 0;    Column = 0 }
    )

# 188+
$compHeaderDefs2 =
    @( 
        @{ Name = "Diagnosis";          Row = 6;    Column = 8 }
        
        @{ Name = "TestOrdered";        Row = 1;    Column = 14 }
        @{ Name = "Result";             Row = 2;    Column = 14 }
        @{ Name = "Notes";              Row = 3;    Column = 14 }

        @{ Name = "SpecimanType";       Row = 1;    Column = 27 }
        @{ Name = "SurgPathId";         Row = 2;    Column = 27 }

        # null field
        @{ Name = "LogNote";            Row = 0;    Column = 0 }
    )

# column defs

$columnDefs = 
    @(
        @{ Name = "Chromosome";             Column = 1 }
        @{ Name = "Region";                 Column = 2 }
        @{ Name = "Type";                   Column = 3 }
        @{ Name = "Reference";              Column = 4 }
        @{ Name = "Allele";                 Column = 5 }
        @{ Name = "ReferenceAllele";        Column = 6 }
        @{ Name = "Count";                  Column = 7 }
        @{ Name = "Coverage";               Column = 8 }
        @{ Name = "Frequency";              Column = 9 }
        @{ Name = "AverageQuality";         Column = 11 }
        @{ Name = "Gene";                   Column = 12 }
        @{ Name = "DNAChange";              Column = 13 }
        @{ Name = "ProteinChange";          Column = 14 }
        @{ Name = "LongestProteinChange";   Column = 15 }
        @{ Name = "LongestDNAChange";       Column = 16 }
        @{ Name = "Assessment";             Column = 17 }
        @{ Name = "Reportability";          Column = 18 }
        @{ Name = "Frequency";              Column = 19 }
        @{ Name = "Pathogenicity";          Column = 20 }
        @{ Name = "Exon";                   Column = 21 }
        @{ Name = "DNAVariant";             Column = 22 }
        @{ Name = "ProteinVariant";         Column = 23 }
        @{ Name = "RefSeqId";               Column = 26 }
    )