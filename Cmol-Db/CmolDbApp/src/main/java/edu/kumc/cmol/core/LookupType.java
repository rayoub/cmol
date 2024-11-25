package edu.kumc.cmol.core;

public enum LookupType {
   
    QCI_DIAGNOSES(1),
    LAB_DIAGNOSES(2);

    private int id;

    LookupType(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
