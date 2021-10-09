package edu.kumc.qci.db;

import org.postgresql.util.PGobject;

public class Variant extends PGobject {

    private String reportId;
    private String chromosome;
    private String position;
    private String reference;
    private String alternate;
    private String genotype;
    private String assessment;
    private String actionability;
    private String phenotypeId;
    private String phenotypeName;
    private String dbsnp;
    private String cadd;
    private String alleleFraction;
    private String readDepth;
    private String variation;
    private String gene;
    private String tcTranscript;
    private String tcChange;
    private String tcExonNumber;
    private String tcRegion;
    private String pcProtein;
    private String pcChange;
    private String pcTranslationImpact;
    private String gcChange;
    private String function;
    private String referenceCount;
    
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

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
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

    public String getCadd() {
        return cadd;
    }

    public void setCadd(String cadd) {
        this.cadd = cadd;
    }

    public String getAlleleFraction() {
        return alleleFraction;
    }

    public void setAlleleFraction(String alleleFraction) {
        this.alleleFraction = alleleFraction;
    }

    public String getReadDepth() {
        return readDepth;
    }

    public void setReadDepth(String readDepth) {
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

    public String getTcExonNumber() {
        return tcExonNumber;
    }

    public void setTcExonNumber(String tcExonNumber) {
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

    public String getReferenceCount() {
        return referenceCount;
    }

    public void setReferenceCount(String referenceCount) {
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

