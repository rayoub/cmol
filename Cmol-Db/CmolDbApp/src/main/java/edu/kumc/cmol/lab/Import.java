package edu.kumc.cmol.lab;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;

import edu.kumc.cmol.core.Constants;

public class Import {
	
	private static SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

	public static String getCellValue(Cell cell, FormulaEvaluator evaluator) {

		String cellValue = "";
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
		if (cellValue == null) {
			cellValue = "";
		}
		return cellValue;
	}

	public static List<FileProps> getFiles(PanelType panel) throws IOException {

		Path path = Paths.get(Constants.LAB_DATA_PATHS[1]);

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
		return files;
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
