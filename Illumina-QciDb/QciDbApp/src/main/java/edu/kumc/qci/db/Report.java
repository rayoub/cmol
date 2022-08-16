package edu.kumc.qci.db;

import org.postgresql.util.PGobject;

public class Report extends PGobject {

    private String reportId;

    private String subjectId;
    private String accession;
    private String testDate;
    private String testCode;
    private String clinicalFinding;
    private String diagnosis;
    private String interpretation;
    
    private String sex;
    private String dateOfBirth;
    
    private String orderingPhysicianClient;
    private String orderingPhysicianFacilityName;
    private String orderingPhysicianName;
    private String pathologistName;
    
    private String primaryTumorSite;
    private String specimenId;
    private String specimenType;
    private String specimenCollectionDate;
    
    private String labTestedCNVGain;
    private String labTestedGenes;
   
    public String getReportId() {
        return reportId;
    }

    public void setReportId(String reportId) {
        this.reportId = reportId;
    }

    public String getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(String subjectId) {
        this.subjectId = subjectId;
    }

    public String getAccession() {
        return accession;
    }

    public void setAccession(String accession) {
        this.accession = accession;
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

    public String getOrderingPhysicianClient() {
        return orderingPhysicianClient;
    }

    public void setOrderingPhysicianClient(String orderingPhysicianClient) {
        this.orderingPhysicianClient = orderingPhysicianClient;
    }

    public String getOrderingPhysicianFacilityName() {
        return orderingPhysicianFacilityName;
    }

    public void setOrderingPhysicianFacilityName(String orderingPhysicianFacilityName) {
        this.orderingPhysicianFacilityName = orderingPhysicianFacilityName;
    }

    public String getOrderingPhysicianName() {
        return orderingPhysicianName;
    }

    public void setOrderingPhysicianName(String orderingPhysicianName) {
        this.orderingPhysicianName = orderingPhysicianName;
    }

    public String getPathologistName() {
        return pathologistName;
    }

    public void setPathologistName(String pathologistName) {
        this.pathologistName = pathologistName;
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
            
            reportId + "," +

            subjectId.replace("(", "\\(").replace(")","\\)") + "," +
            accession.replace("(", "\\(").replace(")","\\)") + "," +
            testDate + "," +
            testCode.replace("(", "\\(").replace(")","\\)") + "," +
            clinicalFinding + "," +
            diagnosis + "," +
            interpretation + "," +

            sex + "," +
            dateOfBirth + "," +

            orderingPhysicianClient + "," +
            orderingPhysicianFacilityName.replace(",","\\,") + "," +
            orderingPhysicianName.replace(",", "\\,") + "," +
            pathologistName.replace(",","\\,") + "," +
            
            primaryTumorSite + "," +
            specimenId.replace("(", "\\(").replace(")","\\)") + "," +
            specimenType.replace("(", "\\(").replace(")","\\)") + "," +
            specimenCollectionDate + "," +

            labTestedCNVGain + "," +
            labTestedGenes

        + ")";
        return row;
    }

    













}
