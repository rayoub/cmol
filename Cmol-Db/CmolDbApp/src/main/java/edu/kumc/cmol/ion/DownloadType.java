package edu.kumc.cmol.ion;

public enum DownloadType {
	SelectedVariants("SelectedVariants"),
	Filtered("Filtered");

	private String pattern;

	DownloadType(String pattern) {
		this.pattern = pattern;
	}

	public String getPattern() {
		return pattern;
	}
}
