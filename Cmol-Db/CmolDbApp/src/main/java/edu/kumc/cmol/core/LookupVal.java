package edu.kumc.cmol.core;

public class LookupVal {
    
    private String id;
    private String descr;

    public LookupVal(String id, String descr) {

        this.id = id;
        this.descr = descr;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDescr() {
        return descr;
    }

    public void setDescr(String descr) {
        this.descr = descr;
    }
}
