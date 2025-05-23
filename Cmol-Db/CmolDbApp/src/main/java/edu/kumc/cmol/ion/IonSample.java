package edu.kumc.cmol.ion;

import org.postgresql.util.PGobject;

public class IonSample extends PGobject {

    private String vcfFileName;
    private String tsvFileName;

    private String downloadType;
    private String zipHash;
    private String assayFolder;
    private String sampleFolder;
    private String specimenId;
    private String accessionId;
    private String analysisDate;
    private String mrn;
    
    public String getVcfFileName() {
        return vcfFileName;
    }

    public void setVcfFileName(String vcfFileName) {
        this.vcfFileName = vcfFileName;
    }

    public String getTsvFileName() {
        return tsvFileName;
    }

    public void setTsvFileName(String tsvFileName) {
        this.tsvFileName = tsvFileName;
    }
    
    public String getDownloadType() {
        return downloadType;
    }

    public void setDownloadType(String downloadType) {
        this.downloadType = downloadType;
    }

    public String getZipHash() {
        return zipHash;
    }

    public void setZipHash(String zipName) {
        this.zipHash = zipName;
    }

    public String getAssayFolder() {
        return assayFolder;
    }

    public void setAssayFolder(String assayFolder) {
        this.assayFolder = assayFolder;
    }

    public String getSampleFolder() {
        return sampleFolder;
    }

    public void setSampleFolder(String sampleFolder) {
        this.sampleFolder = sampleFolder;
    }

    public String getSpecimenId() {
        return specimenId;
    }

    public void setSpecimenId(String specimenId) {
        this.specimenId = specimenId;
    }

    public String getAccessionId() {
        return accessionId;
    }

    public void setAccessionId(String accessionId) {
        this.accessionId = accessionId;
    }
    
    public String getAnalysisDate() {
        return analysisDate;
    }

    public void setAnalysisDate(String analysisDate) {
        this.analysisDate = analysisDate;
    }
    
    public String getMrn() {
        return mrn;
    }

    public void setMrn(String mrn) {
        this.mrn = mrn;
    }

    @Override
    public String getValue() {
        String row = "("  +

            downloadType + "," + 
            zipHash + "," + 
            assayFolder + "," + 
            sampleFolder + "," +
            specimenId + "," +
            accessionId  + "," +
            analysisDate + "," + 
            mrn
        + ")";
        return row;
    }
}
