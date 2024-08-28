package edu.kumc.cmol.lab;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.commons.lang3.tuple.Pair;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.formula.FormulaParseException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import edu.kumc.cmol.core.Constants;

public class Import {
	
	private static SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

	public static String getCellValue(Cell cell, FormulaEvaluator evaluator) {

		String cellValue = "";
		try {
			if (cell != null) {
				switch (cell.getCellType()) {
					case STRING:
						cellValue = cell.getStringCellValue();
						break;
					case NUMERIC:
						if (DateUtil.isCellDateFormatted(cell)) {
							cellValue = formatter.format(cell.getDateCellValue());
						} 
						else {
							double d = cell.getNumericCellValue();
							if ((d % 1) == 0) {
								cellValue = String.valueOf(((Double)d).intValue());
							}
							else {
								cellValue = String.valueOf(d);
							}
						}
						break;
					case FORMULA:
						CellValue formulaValue = evaluator.evaluate(cell);
						switch(formulaValue.getCellType()) {
							case STRING:
								cellValue = formulaValue.getStringValue();
								break;
							case NUMERIC:
								double d = formulaValue.getNumberValue();
								if ((d % 1) == 0) {
									long l = Math.round(d);
									cellValue = l + "";
								}
								else {
									cellValue = formulaValue.formatAsString();
								}
								break;
							default:
								cellValue = "";
						}
						break;
					default:
						cellValue = "";
				}
			}
		}
		catch (FormulaParseException e) {
			// do nothing
		}
		if (cellValue == null) {
			cellValue = "";
		}
		return cellValue;
	}

	public static List<FileProps> getFiles(PanelType panel) throws IOException {

        List<FileProps> allFiles = new ArrayList<>();
		for (String strPath : Constants.LAB_DATA_PATHS){

			Path path = Paths.get(strPath);
        	List<FileProps> files = new ArrayList<>();
			try (Stream<Path> pathStream = Files.find(path, 4,
					(p, attrs) -> 
						attrs.isRegularFile() && 
						p.getFileName().toString().startsWith("D") &&
						p.getFileName().toString().endsWith(".xlsm"));
			) {
				files = pathStream.map(FileProps::new)
					.filter(f -> f.getPanel() == panel)
					.filter(f -> !(f.getModifier().contains("repeat") || f.getModifier().contains("cancel")))
					.collect(Collectors.toList());
			}
			allFiles.addAll(files);
		}
		return allFiles;
    }

	public static void importFiles(PanelType panel, 
		Map<String, Pair<Integer,Integer>> sampleFieldMap,
		Map<String, Integer> variantFieldMap) throws IOException, InvalidFormatException, SQLException {

		Set<String> existing = LabDb.getExisting();

		System.out.println("Getting Files");
		List<FileProps> fileProps = Import.getFiles(panel);
		System.out.println("Finished Getting " + fileProps.size() + " Files");

		for (FileProps fileProp : fileProps) {

			String runId = fileProp.getRunId();
			String cmolId = fileProp.getCmolId();

			String combinedId = runId + "$" + cmolId;
			if (!existing.contains(combinedId)) {


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
					Pair<Integer,Integer> p = sampleFieldMap.get("mrn");
					String mrn = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("accession");
					String accession = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("test_code");
					String testCode = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("reported_date");
					String reportedDate = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);
					p = sampleFieldMap.get("diagnosis");
					String diagnosis = Import.getCellValue(sheet.getRow(p.getLeft()).getCell(p.getRight()), evaluator);

					// check date
					LocalDate cutoff = LocalDate.now().minusDays(30);
					Date d = null;
					LocalDate ld = null;
					try {
						d = DateUtil.parseYYYYMMDDDate(reportedDate);
						ld = LocalDate.ofInstant(d.toInstant(), ZoneId.systemDefault());
					}
					catch (IllegalArgumentException e) {
						d = null;
						ld = null;
					}
					if(d != null && ld != null && cutoff.isAfter(ld)) {

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
					}
					wb.close();

					if (variants.size() > 0) {
						System.out.println("Processed Excel File: " + fileProp.getFileName());
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


	public static String removeParenthetical(String transcript) {

		int index = transcript.indexOf(" (");
		if (index > 0) {
			transcript = transcript.substring(0, index);
		}
		return transcript;
	}
	public static String getRunIdFromNgsDirName(String ngsDirName) {

		int index = ngsDirName.indexOf(" (");
		if (index > 0) {
			ngsDirName = ngsDirName.substring(0, index);
		}
		return ngsDirName;
	}

	public static PanelType getPanelFromNgsDirName(String ngsDirName) {
		
		String panelStr = ngsDirName.substring(ngsDirName.indexOf("(") + 1, ngsDirName.indexOf(")")).toLowerCase();
	
		PanelType panel; 
		if (panelStr.equals("heme")) {
			panel = PanelType.Heme;
		}
		else if (panelStr.equals("comprehensive")) {
			panel = PanelType.Comprehensive;
		}
		else {
			panel = PanelType.Common;
		}
		return panel;
	}
}
