package edu.kumc.cmol.ion;

import org.postgresql.util.PGobject;

public class Variant extends PGobject {

    public static int INT_NULL = -99999;
    public static double DOUBLE_NULL = -99999.0;

    private String sample;
    private String locus;
    private String genotype;
    private String filter;
    private String ref;
    private String genes;
    private String transcript;
    private String coding;
    private String protein;
    
    public String getSample() {
        return sample;
    }

    public void setSample(String sample) {
        this.sample = sample;
    }


    public String getLocus() {
        return locus;
    }

    public void setLocus(String locus) {
        this.locus = locus;
    }
    
    public String getGenotype() {
        return genotype;
    }

    public void setGenotype(String genotype) {
        this.genotype = genotype;
    }

    public String getFilter() {
        return filter;
    }

    public void setFilter(String filter) {
        this.filter = filter;
    }

    public String getRef() {
        return ref;
    }

    public void setRef(String ref) {
        this.ref = ref;
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

    public String getProtein() {
        return protein;
    }

    public void setProtein(String protein) {
        this.protein = protein;
    }

    @Override
    public String getValue() {
        String row = "("  +

            sample + "," + 
            locus + "," + 
            genotype + "," +
            filter + "," +
            ref + "," +
            genes + "," + 
            transcript + "," + 
            coding + "," + 
            protein 
        + ")";
        return row;
    }
}

