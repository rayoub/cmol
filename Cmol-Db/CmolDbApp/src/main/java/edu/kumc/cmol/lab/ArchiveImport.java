package edu.kumc.cmol.lab;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ArchiveImport {

	private static Map<String, Integer> sampleFieldMap = new HashMap<>();
	private static Map<String, Integer> variantFieldMap = new HashMap<>();
	
	static { 

		// sample fields
		sampleFieldMap.put("cmol_id", 2);
		sampleFieldMap.put("run_id", 0);
		sampleFieldMap.put("mrn", 3);
		sampleFieldMap.put("accession", 4);
		sampleFieldMap.put("test_code", 5); // panel
		sampleFieldMap.put("reported_date", 1);
		sampleFieldMap.put("hospital_name", 38); // ordering facility
		sampleFieldMap.put("sample_type", 39);
		sampleFieldMap.put("diagnosis", 35); 
		sampleFieldMap.put("surgpath_id", 40); 
	
		// variant fields
		variantFieldMap.put("chromosome", 7);
		variantFieldMap.put("region", 8);
		variantFieldMap.put("variation", 9); // type
		variantFieldMap.put("reference", 10);
		variantFieldMap.put("alternate", 11); // allele
		variantFieldMap.put("allele_fraction", 15); // frequency
		variantFieldMap.put("read_depth", 14); // coverage
		variantFieldMap.put("gene", 17); // gene cards
		variantFieldMap.put("tc_transcript", 34);  // transcript
		variantFieldMap.put("tc_change", 27); // Formatted Coding Region Change
		variantFieldMap.put("tc_exon_number", 26); // exon lookup 
		variantFieldMap.put("pc_change", 28); // Formatted AA Change
		variantFieldMap.put("assessment", 33); // pathogenicity 
		variantFieldMap.put("reported", 23);
	}

	public static void importArchiveFiles(String dataPath) throws IOException { 

		List<String> archiveFilePaths = getArchiveFiles(dataPath);
		for (String path : archiveFilePaths) {

			System.out.println("Processing Excel File:" + path);

			List<LabSample> samples = new ArrayList<>();
			List<LabVariant> variants = new ArrayList<>();
			
			FileInputStream fin = new FileInputStream(path);
			OPCPackage pkg = null;
			XSSFWorkbook wb = null;
			try {

				pkg = OPCPackage.open(fin);
				wb = new XSSFWorkbook(pkg);

				//int rowNumber = 2;
				String lastKey = "";
				Sheet sheet = wb.getSheetAt(0);
				for (Row row : sheet) {
					if (row.getRowNum() != 0) {

						//System.out.println("Processing row = " + rowNumber++);
						String runId = Import.getCellValue(row.getCell(sampleFieldMap.get("run_id")));
						String cmolId = Import.getCellValue(row.getCell(sampleFieldMap.get("cmol_id")));
						if (runId.isEmpty() || cmolId.isEmpty()) {
							continue;
						}
						String key = runId + cmolId;
						if (!key.equals(lastKey)) {
							
							// build sample object
							LabSample sample = new LabSample();

							sample.setRunId(runId);
							sample.setCmolId(cmolId);
							sample.setMrn(Import.getCellValue(row.getCell(sampleFieldMap.get("mrn"))));
							sample.setAccession(Import.getCellValue(row.getCell(sampleFieldMap.get("accession"))));
							sample.setTestCode(Import.getCellValue(row.getCell(sampleFieldMap.get("test_code")))); 
							sample.setReportedDate(Import.getCellValue(row.getCell(sampleFieldMap.get("reported_date"))));
							sample.setHospitalName(Import.getCellValue(row.getCell(sampleFieldMap.get("hospital_name")))); 
							sample.setSampleType(Import.getCellValue(row.getCell(sampleFieldMap.get("sample_type"))));
							sample.setDiagnosis(Import.getCellValue(row.getCell(sampleFieldMap.get("diagnosis"))));
							sample.setSurgpathId(Import.getCellValue(row.getCell(sampleFieldMap.get("surgpath_id"))));
							sample.setArchived("Y");

							samples.add(sample);
						}

						// build variant object
						LabVariant variant = new LabVariant();

						variant.setRunId(runId);
						variant.setCmolId(cmolId);
						variant.setChromosome(Import.getCellValue(row.getCell(variantFieldMap.get("chromosome"))));
						variant.setRegion(Import.getCellValue(row.getCell(variantFieldMap.get("region"))));
						variant.setVariation(Import.getCellValue(row.getCell(variantFieldMap.get("variation"))));
						variant.setReference(Import.getCellValue(row.getCell(variantFieldMap.get("reference"))));
						variant.setAlternate(Import.getCellValue(row.getCell(variantFieldMap.get("alternate"))));
						variant.setAlleleFraction(Import.getCellValue(row.getCell(variantFieldMap.get("allele_fraction"))));
						variant.setReadDepth(Import.getCellValue(row.getCell(variantFieldMap.get("read_depth"))));
						variant.setGene(Import.getCellValue(row.getCell(variantFieldMap.get("gene"))));
						variant.setTcTranscript(Import.getCellValue(row.getCell(variantFieldMap.get("tc_transcript"))));
						variant.setTcChange(Import.getCellValue(row.getCell(variantFieldMap.get("tc_change"))));
						variant.setTcExonNumber(Import.getCellValue(row.getCell(variantFieldMap.get("tc_exon_number"))));
						variant.setPcChange(Import.getCellValue(row.getCell(variantFieldMap.get("pc_change"))));
						variant.setAssessment(Import.getCellValue(row.getCell(variantFieldMap.get("assessment"))));
						variant.setReported(Import.getCellValue(row.getCell(variantFieldMap.get("reported"))));

						variants.add(variant);

						lastKey = key;
					}

				} // for 
				wb.close();

				LabDb.saveSamples(samples);
				LabDb.saveVariants(variants);
			} 
			catch (InvalidFormatException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			finally {
				if (pkg != null) 
					pkg.close();
				if (wb != null) 
					wb.close();
			}
		}
	}

	private static List<String> getArchiveFiles(String dir) {
		return Stream.of(new File(dir).listFiles())
		  .filter(file -> !file.isDirectory())
		  .filter(file -> file.getName().endsWith("xlsx"))
		  .map(File::getPath)
		  .collect(Collectors.toList());
	}
}