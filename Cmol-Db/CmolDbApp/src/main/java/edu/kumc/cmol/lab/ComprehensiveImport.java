package edu.kumc.cmol.lab;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.tuple.Pair;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;

public class ComprehensiveImport {

	private static Map<String, Pair<Integer,Integer>> sampleFieldMap = new HashMap<>();
	private static Map<String, Integer> variantFieldMap = new HashMap<>();
	
	static { 

		// sample fields
		sampleFieldMap.put("specimen_id", Pair.of(0,3)); // Specimen ID
		sampleFieldMap.put("run_id", Pair.of(0,1)); // Assay ID
		sampleFieldMap.put("mrn", Pair.of(4,3));
		sampleFieldMap.put("accession", Pair.of(5,1));
		sampleFieldMap.put("test_code", Pair.of(2,1)); // Panel
		sampleFieldMap.put("reported_date", Pair.of(1,3)); // Date
		sampleFieldMap.put("diagnosis", Pair.of(5,7));
	
		// variant fields
		variantFieldMap.put("chromosome", 0);
		variantFieldMap.put("region", 1);
		variantFieldMap.put("variation", 2); // variation
		variantFieldMap.put("reference", 3);
		variantFieldMap.put("alternate", 4); // allele
		variantFieldMap.put("allele_fraction", 8); // frequency
		variantFieldMap.put("read_depth", 7); // coverage
		variantFieldMap.put("gene", 10); 
		variantFieldMap.put("tc_transcript", 25); // Recommended RefSeq
		variantFieldMap.put("tc_change", 21); // cDNA Variant Change
		variantFieldMap.put("tc_exon_number", 20); // exon 
		variantFieldMap.put("pc_change", 22); // Amino Acid change
		variantFieldMap.put("assessment", 19); // pathogenicity 
		variantFieldMap.put("reported", 16); // reportability
	}

	public static void importFiles() throws InvalidFormatException, IOException, SQLException {

		Import.importFiles(PanelType.Comprehensive, sampleFieldMap, variantFieldMap);
	}
}
