package edu.kumc.cmol.ion;

public class QueryCriteria {

    private String downloadType;
    private String fromDate;
    private String toDate;
    private String specimenId;
    private String mrns;
    private String genes;
    private String transcriptChange;
    private String proteinChange;
    
    public String getDownloadType() {
        return downloadType;
    }

    public void setDownloadType(String downloadType) {
        this.downloadType = downloadType;
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

    public String getSpecimenId() {
        return specimenId;
    }

    public void setSpecimenId(String specimenId) {
        this.specimenId = specimenId;
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
