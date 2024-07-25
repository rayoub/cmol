package edu.kumc.cmol.lab;

import java.io.IOException;
import java.util.List;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;

public class CommonImport {

	public static void importFiles() throws IOException, InvalidFormatException {

		List<FileProps> files = Import.getFiles(PanelType.Heme);
	
		// iterate files

		for (FileProps file : files) {

//			OPCPackage pkg = OPCPackage.open(file.getFilePath().toFile());
	//		XSSFWorkbook wb = new XSSFWorkbook(pkg);


		//	pkg.close();
		}
	}	
}
