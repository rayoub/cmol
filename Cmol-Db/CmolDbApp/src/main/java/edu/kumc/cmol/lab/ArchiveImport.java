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
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ArchiveImport {

	private static Map<String, Integer> sampleFieldMap = new HashMap<>();
	private static Map<String, Integer> variantFieldMap = new HashMap<>();
	
	static { 

		// sample fields
		sampleFieldMap.put("specimen_id", 2);
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
			FormulaEvaluator evaluator = null;

			try {

				pkg = OPCPackage.open(fin);
				wb = new XSSFWorkbook(pkg);
				evaluator = wb.getCreationHelper().createFormulaEvaluator();

				//int rowNumber = 2;
				String lastKey = "";
				Sheet sheet = wb.getSheetAt(0);
				for (Row row : sheet) {
					if (row.getRowNum() != 0) {

						//System.out.println("Processing row = " + rowNumber++);
						String runId = Import.getCellValue(row.getCell(sampleFieldMap.get("run_id")), evaluator);
						String specimenId = Import.getCellValue(row.getCell(sampleFieldMap.get("specimen_id")), evaluator);
						if (runId.isEmpty() || specimenId.isEmpty()) {
							continue;
						}
						String key = runId + specimenId;
						if (!key.equals(lastKey)) {
							
							// build sample object
							LabSample sample = new LabSample();

							sample.setRunId(runId);
							sample.setSpecimenId(specimenId);
							sample.setMrn(Import.getCellValue(row.getCell(sampleFieldMap.get("mrn")), evaluator));
							sample.setAccession(Import.getCellValue(row.getCell(sampleFieldMap.get("accession")), evaluator));
							sample.setTestCode(Import.getCellValue(row.getCell(sampleFieldMap.get("test_code")), evaluator)); 
							sample.setReportedDate(Import.getCellValue(row.getCell(sampleFieldMap.get("reported_date")), evaluator));
							sample.setHospitalName(Import.getCellValue(row.getCell(sampleFieldMap.get("hospital_name")), evaluator)); 
							sample.setSampleType(Import.getCellValue(row.getCell(sampleFieldMap.get("sample_type")), evaluator));
							sample.setDiagnosis(Import.getCellValue(row.getCell(sampleFieldMap.get("diagnosis")), evaluator));
							sample.setSurgpathId(Import.getCellValue(row.getCell(sampleFieldMap.get("surgpath_id")), evaluator));
							sample.setArchived("Y");

							samples.add(sample);
						}

						// build variant object
						LabVariant variant = new LabVariant();

						variant.setRunId(runId);
						variant.setSpecimenId(specimenId);
						variant.setChromosome(Import.getCellValue(row.getCell(variantFieldMap.get("chromosome")), evaluator));
						variant.setRegion(Import.getCellValue(row.getCell(variantFieldMap.get("region")), evaluator));
						variant.setVariation(Import.getCellValue(row.getCell(variantFieldMap.get("variation")), evaluator));
						variant.setReference(Import.getCellValue(row.getCell(variantFieldMap.get("reference")), evaluator));
						variant.setAlternate(Import.getCellValue(row.getCell(variantFieldMap.get("alternate")), evaluator));
						variant.setAlleleFraction(Import.getCellValue(row.getCell(variantFieldMap.get("allele_fraction")), evaluator));
						variant.setReadDepth(Import.getCellValue(row.getCell(variantFieldMap.get("read_depth")), evaluator));
						variant.setGene(Import.getCellValue(row.getCell(variantFieldMap.get("gene")), evaluator));
						variant.setTcTranscript(Import.getCellValue(row.getCell(variantFieldMap.get("tc_transcript")), evaluator));
						variant.setTcChange(Import.getCellValue(row.getCell(variantFieldMap.get("tc_change")), evaluator));
						variant.setTcExonNumber(Import.getCellValue(row.getCell(variantFieldMap.get("tc_exon_number")), evaluator));
						variant.setPcChange(Import.getCellValue(row.getCell(variantFieldMap.get("pc_change")), evaluator));
						variant.setAssessment(Import.getCellValue(row.getCell(variantFieldMap.get("assessment")), evaluator));
						variant.setReported(Import.getCellValue(row.getCell(variantFieldMap.get("reported")), evaluator));

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