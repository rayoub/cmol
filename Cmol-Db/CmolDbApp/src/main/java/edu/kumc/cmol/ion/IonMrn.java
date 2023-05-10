package edu.kumc.cmol.ion;

import org.postgresql.util.PGobject;

public class IonMrn extends PGobject {

    private String mrn;
    private String accn;

    public String getMrn() {
        return mrn;
    }

    public void setMrn(String mrn) {
        this.mrn = mrn;
    }
    
    public String getAccn() {
        return accn;
    }

    public void setAccn(String accn) {
        this.accn = accn;
    }

    @Override
    public String getValue() {
        String row = "("  +

            mrn + "," + 
            accn 
        + ")";
        return row;
    }

}
