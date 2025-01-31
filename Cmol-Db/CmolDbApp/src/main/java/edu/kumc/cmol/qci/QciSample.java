package edu.kumc.cmol.qci;

import org.postgresql.util.PGobject;

public class QciSample extends PGobject {

    private String sampleId;

    private String mrn;
    private String receivedDate;
    private String testDate;
    private String testCode;
    private String clinicalFinding;
    private String diagnosis;
    private String interpretation;
    
    private String sex;
    private String dateOfBirth;
    
    private String hospitalName;
    private String physicianName;
    
    private String primaryTumorSite;
    private String specimenId;
    private String specimenType;
    private String specimenCollectionDate;
    
    private String labTestedCNVGain;
    private String labTestedGenes;
   
    public String getSampleId() {
        return sampleId;
    }

    public void setSampleId(String sampleId) {
        this.sampleId = sampleId;
    }
    
    public String getMrn() {
        return mrn;
    }

    public void setMrn(String mrn) {
        this.mrn = mrn;
    }

    public String getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(String receivedDate) {
        this.receivedDate = receivedDate;
    }

    public String getTestDate() {
        return testDate;
    }

    public void setTestDate(String testDate) {
        this.testDate = testDate;
    }

    public String getTestCode() {
        return testCode;
    }

    public void setTestCode(String testCode) {
        this.testCode = testCode;
    }

    public String getClinicalFinding() {
        return clinicalFinding;
    }

    public void setClinicalFinding(String clinicalFinding) {
        this.clinicalFinding = clinicalFinding;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getInterpretation() {
        return interpretation;
    }

    public void setInterpretation(String interpretation) {
        this.interpretation = interpretation;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getHospitalName() {
        return hospitalName;
    }

    public void setHospitalName(String orderingPhysicianFacilityName) {
        this.hospitalName = orderingPhysicianFacilityName;
    }

    public String getPhysicianName() {
        return physicianName;
    }

    public void setPhysicianName(String orderingPhysicianClient) {
        this.physicianName = orderingPhysicianClient;
    }

    public String getPrimaryTumorSite() {
        return primaryTumorSite;
    }

    public void setPrimaryTumorSite(String primaryTumorSite) {
        this.primaryTumorSite = primaryTumorSite;
    }

    public String getSpecimenId() {
        return specimenId;
    }

    public void setSpecimenId(String specimenId) {
        this.specimenId = specimenId;
    }

    public String getSpecimenType() {
        return specimenType;
    }

    public void setSpecimenType(String specimenType) {
        this.specimenType = specimenType;
    }

    public String getSpecimenCollectionDate() {
        return specimenCollectionDate;
    }

    public void setSpecimenCollectionDate(String specimenCollectionDate) {
        this.specimenCollectionDate = specimenCollectionDate;
    }

    public String getLabTestedCNVGain() {
        return labTestedCNVGain;
    }

    public void setLabTestedCNVGain(String labTestedCNVGain) {
        this.labTestedCNVGain = labTestedCNVGain;
    }

    public String getLabTestedGenes() {
        return labTestedGenes;
    }

    public void setLabTestedGenes(String labTestedGenes) {
        this.labTestedGenes = labTestedGenes;
    }
    
    @Override
    public String getValue() {
        String row = "("  +
            
            sampleId + "," +

            mrn + "," +
            receivedDate + "," +
            testDate + "," +
            testCode.replace("(", "\\(").replace(")","\\)") + "," +
            clinicalFinding + "," +
            diagnosis + "," +
            interpretation + "," +

            sex + "," +
            dateOfBirth + "," +

            hospitalName.replace(",","\\,") + "," +
            physicianName.replace(",", "\\,") + "," +
            
            primaryTumorSite + "," +
            specimenId.replace("(", "\\(").replace(")","\\)") + "," + // remove
            specimenType.replace("(", "\\(").replace(")","\\)") + "," +
            specimenCollectionDate + "," + // remove

            labTestedCNVGain + "," +
            labTestedGenes

        + ")";
        return row;
    }
}
