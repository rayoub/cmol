package edu.kumc.cmol.lab;

import java.nio.file.Path;

public class FileProps {

	private Path filePath;	
	private String cmolId;
	private String accessionId;
	private PanelType panel;
	private int runNumber;
	private String modifier;

	public FileProps(Path filePath) {

		this.filePath = filePath;

		String idStr = filePath.getParent().getFileName().toString();
	
		String[] parts = idStr.split(" ");
		this.cmolId = parts[0].split("_")[0];
		this.accessionId = parts[0].split("_")[1];
		if (parts.length > 1) {
			this.modifier = "";
			for (int i = 1; i < parts.length; i++) {
				if (i > 1) {
					this.modifier += " ";
				}
				this.modifier += parts[i].toLowerCase(); 
			}
			this.modifier = this.modifier.trim();
		}
		else {
			this.modifier = "";
		}
		
		String fileName = filePath.getParent().getParent().getParent().getFileName().toString();
		this.runNumber = Import.getRunNumber(fileName);
		this.panel = Import.getPanel(fileName);
	}

	public Path getFilePath() {
		return filePath;
	}

	public void setFilePath(Path filePath) {
		this.filePath = filePath;
	}

	public String getCmolId() {
		return cmolId;
	}

	public void setCmolId(String cmolId) {
		this.cmolId = cmolId;
	}

	public String getAccessionId() {
		return accessionId;
	}

	public void setAccessionId(String accessionId) {
		this.accessionId = accessionId;
	}
	
	public PanelType getPanel() {
		return panel;
	}

	public void setPanel(PanelType panel) {
		this.panel = panel;
	}

	public int getRunNumber() {
		return runNumber;
	}

	public void setRunNumber(int runNumber) {
		this.runNumber = runNumber;
	}
	
	public String getModifier() {
		return modifier;
	}

	public void setModifier(String modifier) {
		this.modifier = modifier;
	}

	@Override
	public String toString() {
		return "filePath=" + filePath + 
				"\ncmolId=" + cmolId + 
				"\naccessionId=" + accessionId + 
				"\npanel=" + panel + 
				"\nrunNumber=" + runNumber + 
				"\nmodifier=" + modifier;
	}
}
