package edu.kumc.cmol.ion;

public class IonCnvStat {

	private String gene;
	private int sn;
	private int gn;
	private double gnPct;
    private double minCn;
	private double maxCn;
	private double avgCn;

	public String getGene() {
		return gene;
	}

	public void setGene(String gene) {
		this.gene = gene;
	}

	public int getSn() {
		return sn;
	}

	public void setSn(int sn) {
		this.sn = sn;
	}

	public int getGn() {
		return gn;
	}

	public void setGn(int gn) {
		this.gn = gn;
	}

	public double getGnPct() {
		return gnPct;
	}

	public void setGnPct(double gnPct) {
		this.gnPct = gnPct;
	}

	public double getMinCn() {
		return minCn;
	}

	public void setMinCn(double minCn) {
		this.minCn = minCn;
	}

	public double getMaxCn() {
		return maxCn;
	}

	public void setMaxCn(double maxCn) {
		this.maxCn = maxCn;
	}

	public double getAvgCn() {
		return avgCn;
	}

	public void setAvgCn(double avgCn) {
		this.avgCn = avgCn;
	}
}
