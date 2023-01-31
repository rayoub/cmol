package edu.kumc.cmol.qci;

import org.postgresql.util.PGobject;

public class Variant extends PGobject {

    public static int INT_NULL = -99999;
    public static double DOUBLE_NULL = -99999.0;

    private String reportId;
    private String chromosome;
    private int position = INT_NULL;
    private String reference;
    private String alternate;
    private String genotype;
    private String assessment;
    private String actionability;
    private String phenotypeId;
    private String phenotypeName;
    private String dbsnp;
    private double cadd = DOUBLE_NULL;
    private double alleleFraction = DOUBLE_NULL;
    private int readDepth = INT_NULL;
    private String variation;
    private String gene;
    private String tcTranscript;
    private String tcChange;
    private int tcExonNumber = INT_NULL;
    private String tcRegion;
    private String pcProtein;
    private String pcChange;
    private String pcTranslationImpact;
    private String gcChange;
    private String function;
    private int referenceCount = INT_NULL;
    
    public String getReportId() {
        return reportId;
    }

    public void setReportId(String reportId) {
        this.reportId = reportId;
    }

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

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getAlternate() {
        return alternate;
    }

    public void setAlternate(String alternate) {
        this.alternate = alternate;
    }

    public String getGenotype() {
        return genotype;
    }

    public void setGenotype(String genotype) {
        this.genotype = genotype;
    }

    public String getAssessment() {
        return assessment;
    }

    public void setAssessment(String assessment) {
        this.assessment = assessment;
    }

    public String getActionability() {
        return actionability;
    }

    public void setActionability(String actionability) {
        this.actionability = actionability;
    }
    
    public String getPhenotypeId() {
        return phenotypeId;
    }

    public void setPhenotypeId(String phenotypeId) {
        this.phenotypeId = phenotypeId;
    }
    
    public String getPhenotypeName() {
        return phenotypeName;
    }

    public void setPhenotypeName(String phenotypeName) {
        this.phenotypeName = phenotypeName;
    }

    public String getDbsnp() {
        return dbsnp;
    }

    public void setDbsnp(String dbsnp) {
        this.dbsnp = dbsnp;
    }

    public double getCadd() {
        return cadd;
    }

    public void setCadd(double cadd) {
        this.cadd = cadd;
    }

    public double getAlleleFraction() {
        return alleleFraction;
    }

    public void setAlleleFraction(double alleleFraction) {
        this.alleleFraction = alleleFraction;
    }

    public int getReadDepth() {
        return readDepth;
    }

    public void setReadDepth(int readDepth) {
        this.readDepth = readDepth;
    }

    public String getVariation() {
        return variation;
    }

    public void setVariation(String variation) {
        this.variation = variation;
    }

    public String getGene() {
        return gene;
    }

    public void setGene(String gene) {
        this.gene = gene;
    }

    public String getTcTranscript() {
        return tcTranscript;
    }

    public void setTcTranscript(String tcTranscript) {
        this.tcTranscript = tcTranscript;
    }

    public String getTcChange() {
        return tcChange;
    }

    public void setTcChange(String tcChange) {
        this.tcChange = tcChange;
    }

    public int getTcExonNumber() {
        return tcExonNumber;
    }

    public void setTcExonNumber(int tcExonNumber) {
        this.tcExonNumber = tcExonNumber;
    }

    public String getTcRegion() {
        return tcRegion;
    }

    public void setTcRegion(String tcRegion) {
        this.tcRegion = tcRegion;
    }

    public String getPcProtein() {
        return pcProtein;
    }

    public void setPcProtein(String pcProtein) {
        this.pcProtein = pcProtein;
    }

    public String getPcChange() {
        return pcChange;
    }

    public void setPcChange(String pcChange) {
        this.pcChange = pcChange;
    }

    public String getPcTranslationImpact() {
        return pcTranslationImpact;
    }

    public void setPcTranslationImpact(String pcTranslationImpact) {
        this.pcTranslationImpact = pcTranslationImpact;
    }

    public String getGcChange() {
        return gcChange;
    }

    public void setGcChange(String gcChange) {
        this.gcChange = gcChange;
    }

    public String getFunction() {
        return function;
    }

    public void setFunction(String function) {
        this.function = function;
    }

    public int getReferenceCount() {
        return referenceCount;
    }

    public void setReferenceCount(int referenceCount) {
        this.referenceCount = referenceCount;
    }
    
    @Override
    public String getValue() {
        String row = "("  +

            reportId + "," +
            chromosome + "," + 
            position  + "," + 
            reference + "," + 
            alternate + "," + 
            genotype + "," + 
            assessment + "," + 
            actionability + "," + 
            phenotypeId + "," + 
            phenotypeName + "," + 
            dbsnp + "," + 
            cadd + "," + 
            alleleFraction + "," + 
            readDepth + "," + 
            variation + "," + 
            gene + "," + 
            tcTranscript + "," + 
            tcChange + "," + 
            tcExonNumber + "," + 
            tcRegion + "," + 
            pcProtein + "," + 
            pcChange + "," + 
            pcTranslationImpact + "," + 
            gcChange + "," + 
            function + "," + 
            referenceCount
        + ")";
        return row;
    }
}

