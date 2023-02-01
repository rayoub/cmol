package edu.kumc.cmol.core;

public enum LookupType {
   
    DIAGNOSES(1),
    SAMPLES(2);    

    private int id;

    LookupType(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
