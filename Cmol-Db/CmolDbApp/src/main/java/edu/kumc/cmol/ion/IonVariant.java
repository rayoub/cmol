package edu.kumc.cmol.ion;

import org.postgresql.util.PGobject;

public class IonVariant extends PGobject {

    public static int INT_NULL = -99999;
    public static double DOUBLE_NULL = -99999.0;

    private String zipName;
    private String locus;
    private String type;
    private String subtype;
    private String genotype;
    private String filter;
    private String ref;
    private String normalizedAlt;
    private String coverage;
    private String alleleCoverage;
    private String alleleRatio;
    private String alleleFrequency;
    private String genes;
    private String transcript;
    private String location;
    private String function;
    private String exon;
    private String coding;
    private String protein;
    private String copyNumber;
    private String copyNumberType;
    
    public String getZipName() {
        return zipName;
    }

    public void setZipName(String zipName) {
        this.zipName = zipName;
    }

    public String getLocus() {
        return locus;
    }

    public void setLocus(String locus) {
        this.locus = locus;
    }

    public String getVariantType() {
        return type;
    }

    public void setVariantType(String type) {
        this.type = type;
    }

    public String getVariantSubtype() {
        return subtype;
    }

    public void setVariantSubtype(String subtype) {
        this.subtype = subtype;
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

    public String getNormalizedAlt() {
        return normalizedAlt;
    }

    public void setNormalizedAlt(String normalizedAlt) {
        this.normalizedAlt = normalizedAlt;
    }

    public String getCoverage() {
        return coverage;
    }

    public void setCoverage(String coverage) {
        this.coverage = coverage;
    }

    public String getAlleleCoverage() {
        return alleleCoverage;
    }

    public void setAlleleCoverage(String alleleCoverage) {
        this.alleleCoverage = alleleCoverage;
    }

    public String getAlleleRatio() {
        return alleleRatio;
    }

    public void setAlleleRatio(String alleleRatio) {
        this.alleleRatio = alleleRatio;
    }

    public String getAlleleFrequency() {
        return alleleFrequency;
    }

    public void setAlleleFrequency(String alleleFrequency) {
        this.alleleFrequency = alleleFrequency;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getFunction() {
        return function;
    }

    public void setFunction(String function) {
        this.function = function;
    }

    public String getExon() {
        return exon;
    }

    public void setExon(String exon) {
        this.exon = exon;
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

    public String getCopyNumber() {
        return copyNumber;
    }

    public void setCopyNumber(String copyNumber) {
        this.copyNumber = copyNumber;
    }

    public String getCopyNumberType() {
        return copyNumberType;
    }

    public void setCopyNumberType(String copyNumberType) {
        this.copyNumberType = copyNumberType;
    }

    @Override
    public String getValue() {
        String row = "("  +

            zipName + "," + 
            locus + "," + 
            type + "," +
            subtype + "," + 
            genotype + "," +
            filter + "," +
            ref + "," +
            normalizedAlt + "," + 
            coverage + "," + 
            alleleCoverage + "," + 
            alleleRatio + "," +
            alleleFrequency + "," +
            genes + "," + 
            transcript + "," + 
            location + "," + 
            function + "," + 
            exon + "," + 
            coding + "," + 
            protein + "," + 
            copyNumber + "," + 
            copyNumberType
        + ")";
        return row;
    }
}

