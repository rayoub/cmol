package edu.kumc.cmol.lab;

import org.postgresql.util.PGobject;

public class LabVariant extends PGobject {

	private String runId;
	private String cmolId;

	private String chromosome;
	private String region;
	private String variation;
	private String reference;
	private String alternate;

	private String alleleFraction;
	private String readDepth;

	private String gene;
	private String tcTranscript;
	private String tcChange;
	private String tcExonNumber;
	private String pcChange;

	private String assessment;
	private String reported;
	
	public String getRunId() {
		return runId;
	}

	public void setRunId(String runId) {
		this.runId = runId;
	}

	public String getCmolId() {
		return cmolId;
	}

	public void setCmolId(String cmolId) {
		this.cmolId = cmolId;
	}

	public String getChromosome() {
		return chromosome;
	}

	public void setChromosome(String chromosome) {
		this.chromosome = chromosome;
	}

	public String getRegion() {
		return region;
	}

	public void setRegion(String region) {
		this.region = region;
	}

	public String getVariation() {
		return variation;
	}

	public void setVariation(String variation) {
		this.variation = variation;
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

	public String getPcChange() {
		return pcChange;
	}

	public void setPcChange(String pcChange) {
		this.pcChange = pcChange;
	}

	public String getAssessment() {
		return assessment;
	}

	public void setAssessment(String assessment) {
		this.assessment = assessment;
	}

	public String getReported() {
		return reported;
	}

	public void setReported(String reported) {
		this.reported = reported;
	}

    @Override
    public String getValue() {
        String row = "("  +
			runId.replace(",", "\\,") + "," + 
            cmolId + "," +
            chromosome.replace(",", "\\,") + "," + 
            region + "," + 
            variation + "," + 
            reference + "," + 
            alternate + "," + 
            alleleFraction + "," + 
            readDepth + "," + 
            gene + "," + 
            tcTranscript + "," + 
            tcChange + "," + 
            tcExonNumber.replace(",", "\\,") + "," + 
            pcChange + "," + 
            assessment + "," + 
            reported 
        + ")";
        return row;
    }
}
