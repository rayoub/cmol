package edu.kumc.ion.db;

import org.postgresql.util.PGobject;

public class Variant extends PGobject {

    public static int INT_NULL = -99999;
    public static double DOUBLE_NULL = -99999.0;

    private String chromosome;
    private int position = INT_NULL;
    private String genes;
    private String transcript;
    private String coding;
    private String aminoAcidChange;

    public String getChromosome() {
        return chromosome;
    }

    public void setChromosome(String chromosome) {
        this.chromosome = chromosome;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public String getGenes() {
        return genes;
    }

    public void setGenes(String genes) {
        this.genes = genes;
    }

    public String getTranscript() {
        return transcript;
    }

    public void setTranscript(String transcript) {
        this.transcript = transcript;
    }

    public String getCoding() {
        return coding;
    }

    public void setCoding(String coding) {
        this.coding = coding;
    }

    public String getAminoAcidChange() {
        return aminoAcidChange;
    }

    public void setAminoAcidChange(String aminoAcidChange) {
        this.aminoAcidChange = aminoAcidChange;
    }

    @Override
    public String getValue() {
        String row = "("  +

            chromosome + "," + 
            position  + "," + 
            genes + "," + 
            transcript + "," + 
            coding + "," + 
            aminoAcidChange + ","
        + ")";
        return row;
    }
}

