package edu.kumc.cmol.ion;

import org.postgresql.util.PGobject;

public class IonSample extends PGobject {

    private String fileName;
    private String zipName;
    private String assayFolder;
    private String sampleFolder;
    private String cmolId;
    private String accessionId;
    private String analysisDate;

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getZipName() {
        return zipName;
    }

    public void setZipName(String zipName) {
        this.zipName = zipName;
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

    public String getCmolId() {
        return cmolId;
    }

    public void setCmolId(String cmolId) {
        this.cmolId = cmolId;
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

    @Override
    public String getValue() {
        String row = "("  +

            zipName + "," + 
            assayFolder + "," + 
            sampleFolder + "," +
            cmolId + "," +
            accessionId  + "," +
            analysisDate
        + ")";
        return row;
    }
}
