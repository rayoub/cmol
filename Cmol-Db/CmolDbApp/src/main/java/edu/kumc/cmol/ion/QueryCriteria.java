package edu.kumc.cmol.ion;

public class QueryCriteria {

    private String assayFolder;
    private String cmolId;
    private String gene;
    
    public String getAssayFolder() {
        return assayFolder;
    }

    public void setAssayFolder(String assayFolder) {
        this.assayFolder = assayFolder;
    }

    public String getCmolId() {
        return cmolId;
    }
    public void setCmolId(String cmolId) {
        this.cmolId = cmolId;
    }
    public String getGene() {
        return gene;
    }
    public void setGene(String gene) {
        this.gene = gene;
    }
}
