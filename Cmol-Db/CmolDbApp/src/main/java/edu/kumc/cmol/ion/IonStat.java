package edu.kumc.cmol.ion;

import org.postgresql.util.PGobject;

public class IonStat extends PGobject {
   
    private String descr;
    private Integer stat;

    public String getDescr() {
        return descr;
    }

    public void setDescr(String descr) {
        this.descr = descr;
    }

    public Integer getStat() {
        return stat;
    }

    public void setStat(Integer stat) {
        this.stat = stat;
    }

    @Override
    public String getValue() {
        String row = "("  +

            descr + "," + 
            stat
        + ")";
        return row;
    }
}
