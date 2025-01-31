package edu.kumc.cmol.lab;

import org.postgresql.util.PGobject;

public class LabSample extends PGobject {

	private String runId;
	private String specimenId;
	private String mrn;
	private String accession;
	private String testCode;
	private String reportedDate;
	private String hospitalName;
	private String sampleType;
	private String diagnosis;
	private String surgpathId;
	private String archived;
	
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

	public String getMrn() {
		return mrn;
	}

	public void setMrn(String mrn) {
		this.mrn = mrn;
	}

	public String getAccession() {
		return accession;
	}

	public void setAccession(String accession) {
		this.accession = accession;
	}

	public String getTestCode() {
		return testCode;
	}

	public void setTestCode(String testCode) {
		this.testCode = testCode;
	}

	public String getReportedDate() {
		return reportedDate;
	}

	public void setReportedDate(String reportedDate) {
		this.reportedDate = reportedDate;
	}

	public String getHospitalName() {
		return hospitalName;
	}

	public void setHospitalName(String hospitalName) {
		this.hospitalName = hospitalName;
	}

	public String getSampleType() {
		return sampleType;
	}

	public void setSampleType(String sampleType) {
		this.sampleType = sampleType;
	}

	public String getDiagnosis() {
		return diagnosis;
	}

	public void setDiagnosis(String diagnosis) {
		this.diagnosis = diagnosis;
	}

	public String getSurgpathId() {
		return surgpathId;
	}

	public void setSurgpathId(String surgpathId) {
		this.surgpathId = surgpathId;
	}

	public String getArchived() {
		return archived;
	}

	public void setArchived(String archived) {
		this.archived = archived;
	}
    
	@Override
    public String getValue() {
        String row = "("  +
			runId.replace(",", "\\,") + "," + 
            specimenId + "," +
            mrn + "," +
            accession.replace("(", "\\(").replace(")","\\)") + "," +
            testCode.replace("(", "\\(").replace(")","\\)") + "," +
			reportedDate + "," + 
            (hospitalName != null ? hospitalName.replace(",","\\,") : "") + "," +
            (sampleType != null ? sampleType.replace("(", "\\(").replace(")","\\)") : "") + "," +
        	(diagnosis != null ? diagnosis.replace(",", "\\,").replace("(", "\\(").replace(")","\\)") : "") + "," +
            (surgpathId != null ? surgpathId.replace(",", "\\,").replace("(", "\\(").replace(")","\\)") : "") + "," + 
			archived
        + ")";
        return row;
    }
}
