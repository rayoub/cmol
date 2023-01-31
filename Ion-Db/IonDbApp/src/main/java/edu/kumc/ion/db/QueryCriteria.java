package edu.kumc.ion.db;

public class QueryCriteria {

    private String sample;
    private String accessionId;

    public String getSample() {
        return sample;
    }

    public void setSample(String sample) {
        this.sample = sample;
    }

    public String getAccessionId() {
        return accessionId;
    }

    public void setAccessionId(String accessionId) {
        this.accessionId = accessionId;
    }
}
