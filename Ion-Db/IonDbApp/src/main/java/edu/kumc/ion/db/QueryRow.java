package edu.kumc.ion.db;

public class QueryRow {

    private String reportId;
    private String mrn;
    private String accession;
    private String testDate;
    private String testCode;
    private String diagnosis;
    private String interpretation;
    private String physician;
    private String gene;
    private double alleleFraction;
    private String transcript;
    private String transcriptChange;
    private int transcriptExon;
    private String protein;
    private String proteinChange;
    private String assessment;

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

    public String getGene() {
        return gene;
    }

    public void setGene(String gene) {
        this.gene = gene;
    }

    public double getAlleleFraction() {
        return alleleFraction;
    }

    public void setAlleleFraction(double alleleFraction) {
        this.alleleFraction = alleleFraction;
    }

    public String getTranscript() {
        return transcript;
    }

    public void setTranscript(String transcript) {
        this.transcript = transcript;
    }

    public String getTrasncriptChange() {
        return transcriptChange;
    }

    public void setTranscriptChange(String trasncriptChange) {
        this.transcriptChange = trasncriptChange;
    }

    public int getTranscriptExon() {
        return transcriptExon;
    }

    public void setTranscriptExon(int transcriptExon) {
        this.transcriptExon = transcriptExon;
    }

    public String getProtein() {
        return protein;
    }

    public void setProtein(String protein) {
        this.protein = protein;
    }

    public String getProteinChange() {
        return proteinChange;
    }

    public void setProteinChange(String proteinChange) {
        this.proteinChange = proteinChange;
    }

    public String getAssessment() {
        return assessment;
    }

    public void setAssessment(String assessment) {
        this.assessment = assessment;
    }
}
   