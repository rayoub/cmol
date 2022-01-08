package edu.kumc.qci.db;

public class QueryCriteria {

    private String fromDate;
    private String toDate;
    private String genes;
    private String transcriptChange;
    private String proteinChange;

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
