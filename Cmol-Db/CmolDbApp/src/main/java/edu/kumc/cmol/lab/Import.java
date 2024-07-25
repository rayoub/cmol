package edu.kumc.cmol.lab;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;

import edu.kumc.cmol.core.Constants;

public class Import {
	
	private static SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
 	private static Pattern pattern = Pattern.compile("\\((.*?)\\)");

	public static String getCellValue(Cell cell) {

		String cellValue = "";
		if (cell != null) {
			switch (cell.getCellType()) {
				case STRING:
					cellValue = cell.getRichStringCellValue().getString();
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

        List<FileProps> files = null;
        try (Stream<Path> pathStream = Files.find(path, 4,
                (p, attrs) -> 
					attrs.isRegularFile() && 
					p.getFileName().toString().startsWith("D") &&
					p.getFileName().toString().endsWith(".xlsm"))
        ) {
            files = pathStream.map(FileProps::new)
				.filter(f -> f.getPanel() == panel)
				.filter(f -> !(f.getModifier().contains("repeat") || f.getModifier().contains("cancel")))
				.collect(Collectors.toList());
        }

		return files;
    }
	
	public static int getRunNumber(String fileName) {

		String runNumberStr = fileName.replaceAll("[^\\d]", "");
		int runNumber = Integer.parseInt(runNumberStr);

		return runNumber;
	}	

	public static PanelType getPanel(String fileName) {

		Matcher matcher = pattern.matcher(fileName);
		String panelStr = matcher.group(1);

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
