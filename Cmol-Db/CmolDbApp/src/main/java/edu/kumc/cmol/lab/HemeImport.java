package edu.kumc.cmol.lab;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.tuple.Pair;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class HemeImport {

	private static Map<String, Pair<Integer,Integer>> sampleFieldMap = new HashMap<>();
	private static Map<String, Integer> variantFieldMap = new HashMap<>();
	
	static { 

		// sample fields
		sampleFieldMap.put("cmol_id", Pair.of(0,3)); // Sample ID
		sampleFieldMap.put("run_id", Pair.of(0,1)); // Assay ID
		sampleFieldMap.put("mrn", Pair.of(4,3));
		sampleFieldMap.put("accession", Pair.of(5,1));
		sampleFieldMap.put("test_code", Pair.of(2,1)); // Panel
		sampleFieldMap.put("reported_date", Pair.of(1,3)); // Date
		sampleFieldMap.put("diagnosis", Pair.of(5,6));
	
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

	public static void importFiles() throws IOException, InvalidFormatException, SQLException {

		Set<String> existing = LabDb.getExisting();

		System.out.println("Getting Files");
		List<FileProps> fileProps = Import.getFiles(PanelType.Heme);
		System.out.println("Finished Getting " + fileProps.size() + " Files");

		for (FileProps fileProp : fileProps) {

			String combinedId = fileProp.getRunId() + "$" + fileProp.getCmolId();
			if (!existing.contains(combinedId)) {

				System.out.println("Processing Excel File: " + fileProp.getFileName());

				FileInputStream fin = new FileInputStream(fileProp.getFilePath().toString());
				OPCPackage pkg = null;
				XSSFWorkbook wb = null;
				FormulaEvaluator evaluator = null;
				
				try {

					List<LabSample> samples = new ArrayList<>();
					List<LabVariant> variants = new ArrayList<>();

					pkg = OPCPackage.open(fin);
					wb = new XSSFWorkbook(pkg);
					evaluator = wb.getCreationHelper().createFormulaEvaluator();

					// get the sheet
					Sheet sheet = wb.getSheet("Result");

					// get header info 
					Pair<Integer,Integer> p = sampleFieldMap.get("run_id");
					String runId = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("cmol_id");
					String cmolId = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("mrn");
					String mrn = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("accession");
					String accession = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("test_code");
					String testCode = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("reported_date");
					String reportedDate = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("diagnosis");
					String diagnosis = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					
					// store sample info
					LabSample sample = new LabSample();
					sample.setRunId(runId);
					sample.setCmolId(cmolId);
					sample.setMrn(mrn);
					sample.setAccession(accession);
					sample.setTestCode(testCode);
					sample.setReportedDate(reportedDate);
					sample.setDiagnosis(diagnosis);
					sample.setArchived("N");
					samples.add(sample);

					// iterate variant rows
					for (Row row : sheet) {
						if (row.getRowNum() >= 9) {

							String test = Import.getCellValue(row.getCell(variantFieldMap.get("chromosome")), evaluator);
							if (!test.isBlank() && !test.equals("0") && test.length() <= 2) {
								
								// build variant object
								LabVariant variant = new LabVariant();

								variant.setRunId(runId);
								variant.setCmolId(cmolId);
								variant.setChromosome(Import.getCellValue(row.getCell(variantFieldMap.get("chromosome")), evaluator));
								variant.setRegion(Import.getCellValue(row.getCell(variantFieldMap.get("region")), evaluator));
								variant.setVariation(Import.getCellValue(row.getCell(variantFieldMap.get("variation")), evaluator));
								variant.setReference(Import.getCellValue(row.getCell(variantFieldMap.get("reference")), evaluator));
								variant.setAlternate(Import.getCellValue(row.getCell(variantFieldMap.get("alternate")), evaluator));
								variant.setAlleleFraction(Import.getCellValue(row.getCell(variantFieldMap.get("allele_fraction")), evaluator));
								variant.setReadDepth(Import.getCellValue(row.getCell(variantFieldMap.get("read_depth")), evaluator));
								variant.setGene(Import.getCellValue(row.getCell(variantFieldMap.get("gene")), evaluator));
								variant.setTcTranscript(Import.removeParenthetical(Import.getCellValue(row.getCell(variantFieldMap.get("tc_transcript")), evaluator)));
								variant.setTcChange(Import.getCellValue(row.getCell(variantFieldMap.get("tc_change")), evaluator));
								variant.setTcExonNumber(Import.getCellValue(row.getCell(variantFieldMap.get("tc_exon_number")), evaluator));
								variant.setPcChange(Import.getCellValue(row.getCell(variantFieldMap.get("pc_change")), evaluator));
								variant.setAssessment(Import.getCellValue(row.getCell(variantFieldMap.get("assessment")), evaluator));
								variant.setReported(Import.getCellValue(row.getCell(variantFieldMap.get("reported")), evaluator));

								variants.add(variant);
							}
						}

					} // for 
					wb.close();

					if (variants.size() > 0) {
						System.out.println("Saving " + samples.size() + " sample(s)");
						LabDb.saveSamples(samples);
						System.out.println("Saving " + variants.size() + " variant(s)");
						LabDb.saveVariants(variants);
					}
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
			} // if
		}
	}	
}
