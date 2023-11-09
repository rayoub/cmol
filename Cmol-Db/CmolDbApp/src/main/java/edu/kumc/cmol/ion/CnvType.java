package edu.kumc.cmol.ion;

public enum CnvType {
	Amplications(1),
	Deletions(2),
	UndefinedAmplications(3),
	UndefinedDeletions(4);

	private int id;

	CnvType(int id) {
		this.id = id;
	}

	public int getId() {
		return id;
	}

	public static CnvType fromId(int id) {
		if (id == 1) {
			return Amplications;
		}
		else if (id == 2) {
			return Deletions;
		}
		else if (id == 3) {
			return UndefinedAmplications;
		}
		else {
			return UndefinedDeletions;
		}
	}
}
