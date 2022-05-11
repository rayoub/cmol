package edu.kumc.qci.db;

public enum LookupType {
   
    DIAGNOSES(1);

    private int id = 1;

    private LookupType(int id) {
        this.id = id;
    } 

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
