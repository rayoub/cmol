package edu.kumc.cmol.ion;

public class QueryCriteria {

    private String cmolId;
    private String mrns;
    private String genes;

    public String getCmolId() {
        return cmolId;
    }

    public void setCmolId(String cmolId) {
        this.cmolId = cmolId;
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
}
