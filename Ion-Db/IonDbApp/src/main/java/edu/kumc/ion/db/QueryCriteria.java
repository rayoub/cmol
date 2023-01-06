package edu.kumc.ion.db;

public class QueryCriteria {

    private int[] diagnoses;
    private String fromDate;
    private String toDate;
    private String mrns;
    private String genes;
    private String transcriptChange;
    private String proteinChange;

    public int[] getDiagnoses() {
        return diagnoses;
    }

    public void setDiagnoses(int[] diagnoses) {
        this.diagnoses = diagnoses;
    }

    public String getFromDate() {
        return fromDate;
    }

    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    public String getToDate() {
        return toDate;
    }

    public void setToDate(String toDate) {
        this.toDate = toDate;
    }
    
    public String getMrns() {
        return mrns;
    }

    public void setMrns(String mrns) {
        this.mrns = mrns;
    }
  
    public String getGenes() {
        return genes;
    }

    public void setGenes(String genes) {
        this.genes = genes;
    }

    public String getTranscriptChange() {
        return transcriptChange;
    }

    public void setTranscriptChange(String transcriptChange) {
        this.transcriptChange = transcriptChange;
    }

    public String getProteinChange() {
        return proteinChange;
    }

    public void setProteinChange(String proteinChange) {
        this.proteinChange = proteinChange;
    }
}
