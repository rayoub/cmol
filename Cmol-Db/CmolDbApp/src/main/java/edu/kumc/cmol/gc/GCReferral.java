package edu.kumc.cmol.gc;

public class GCReferral {

    private String reportId;
    private String mrn;
    private String accession;
    private int age;
    private String testDate;
    private String testCode;
    private String tumorSite;
    private String diagnosis;
    private String interpretation;
    private String physician;
    private String genes;
    private int notified;

    public String getReportId() {
        return reportId;
    }

    public void setReportId(String reportId) {
        this.reportId = reportId;
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

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getTestDate() {
        return testDate;
    }

    public void setTestDate(String testDate) {
        this.testDate = testDate;
    }

    public String getTestCode() {
        return testCode;
    }
    
    public void setTestCode(String testCode) {
        this.testCode = testCode;
    }
    
    public String getTumorSite() {
        return tumorSite;
    }

    public void setTumorSite(String tumorSite) {
        this.tumorSite = tumorSite;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getInterpretation() {
        return interpretation;
    }

    public void setInterpretation(String interpretation) {
        this.interpretation = interpretation;
    }

    public String getPhysician() {
        return physician;
    }

    public void setPhysician(String physician) {
        this.physician = physician;
    }

    public String getGenes() {
        return genes;
    }

    public void setGenes(String genes) {
        this.genes = genes;
    }

    public int getNotified() {
        return notified;
    }

    public void setNotified(int notified) {
        this.notified = notified;
    }
}
   