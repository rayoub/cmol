package edu.kumc.cmol.core;

public enum LookupType {
   
    DIAGNOSES(1),
    ASSAYIDS(2),
    CMOLIDS(3);    

    private int id;

    LookupType(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
