package edu.kumc.cmol.lab;

public class QueryCriteria {

    private String fromDate;
    private String toDate;
    private String mrns;
    private String genes;
    private String exon;
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
    
    public String getExon() {
        return exon;
    }

    public void setExon(String exon) {
        this.exon = exon;
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
