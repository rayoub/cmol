package edu.kumc.qci.db;

public class QueryCriteria {
   
    private String genes;
    private int changeType;
    private String transcriptChange;
    private String proteinChange;
  
    public String getGenes() {
        return genes;
    }

    public void setGenes(String genes) {
        this.genes = genes;
    }

    public int getChangeType() {
        return changeType;
    }
    
    public void setChangeType(int changeType) {
        this.changeType = changeType;
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
