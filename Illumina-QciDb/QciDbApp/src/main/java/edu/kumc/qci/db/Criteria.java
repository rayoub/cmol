package edu.kumc.qci.db;

public class Criteria {
    
    private int changeType;
    private String transcriptChange;
    private String proteinChange;
   
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
