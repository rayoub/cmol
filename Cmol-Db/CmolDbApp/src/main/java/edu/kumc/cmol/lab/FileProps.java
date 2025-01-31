package edu.kumc.cmol.lab;

import java.nio.file.Path;

public class FileProps {

	private Path filePath;	
	private String fileName;

	private String runId;
	private String specimenId;
	private String accessionId;
	private PanelType panel;
	private String modifier;

	public FileProps(Path filePath) {

		this.filePath = filePath;
		this.fileName = filePath.getFileName().toString();

		String idStr = filePath.getParent().getFileName().toString();
		String[] parts = idStr.split(" ");
		String[] parts2 = parts[0].split("_");
		this.specimenId = parts2[0];
		this.accessionId = "";
		if (parts2.length > 1) {
			this.accessionId = parts2[1];
		}
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
		
		String ngsDirName = filePath.getParent().getParent().getParent().getFileName().toString();
		this.runId = Import.getRunIdFromNgsDirName(ngsDirName);
		this.panel = Import.getPanelFromNgsDirName(ngsDirName);
	}

	public Path getFilePath() {
		return filePath;
	}

	public void setFilePath(Path filePath) {
		this.filePath = filePath;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public String getRunId() {
		return runId;
	}

	public void setRunId(String runId) {
		this.runId = runId;
	}

	public String getSpecimenId() {
		return specimenId;
	}

	public void setSpecimenId(String specimenId) {
		this.specimenId = specimenId;
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

	public String getModifier() {
		return modifier;
	}

	public void setModifier(String modifier) {
		this.modifier = modifier;
	}

	@Override
	public String toString() {
		return "filePath=" + filePath + 
				"\nfileName=" + fileName + 
				"\nrunId=" + runId + 
				"\nspecimenId=" + specimenId + 
				"\naccessionId=" + accessionId + 
				"\npanel=" + panel + 
				"\nmodifier=" + modifier;
	}
}
