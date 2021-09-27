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
    
    private String patientName;
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
    private String specimenDissection;
    private String specimenTumorContent;
    
    private String labTestedCNVGain;
    private String labTestedGenes;
    private String labTranscriptIds;
    private String sampleDetectedGeneFusions;
    private String sampleDetectedGeneNegative;
    
    private String version;
   
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

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
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

    public String getSpecimenDissection() {
        return specimenDissection;
    }

    public void setSpecimenDissection(String specimenDissection) {
        this.specimenDissection = specimenDissection;
    }

    public String getSpecimenTumorContent() {
        return specimenTumorContent;
    }

    public void setSpecimenTumorContent(String specimenTumorContent) {
        this.specimenTumorContent = specimenTumorContent;
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

    public String getLabTranscriptIds() {
        return labTranscriptIds;
    }

    public void setLabTranscriptIds(String labTranscriptIds) {
        this.labTranscriptIds = labTranscriptIds;
    }

    public String getSampleDetectedGeneFusions() {
        return sampleDetectedGeneFusions;
    }

    public void setSampleDetectedGeneFusions(String sampleDetectedGeneFusions) {
        this.sampleDetectedGeneFusions = sampleDetectedGeneFusions;
    }

    public String getSampleDetectedGeneNegative() {
        return sampleDetectedGeneNegative;
    }

    public void setSampleDetectedGeneNegative(String sampleDetectedGeneNegative) {
        this.sampleDetectedGeneNegative = sampleDetectedGeneNegative;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }
    
    @Override
    public String getValue() {
        String row = "("  +
            
            reportId + "," +

            subjectId + "," +
            accession + "," +
            testDate + "," +
            testCode + "," +
            clinicalFinding + "," +
            diagnosis + "," +
            interpretation + "," +

            patientName + "," +
            sex + "," +
            dateOfBirth + "," +

            orderingPhysicianClient + "," +
            orderingPhysicianFacilityName + "," +
            orderingPhysicianName + "," +
            pathologistName + "," +
            
            primaryTumorSite + "," +
            specimenId + "," +
            specimenType + "," +
            specimenCollectionDate + "," +
            specimenDissection + "," +
            specimenTumorContent + "," +

            labTestedCNVGain + "," +
            labTestedGenes + "," +
            labTranscriptIds + "," +
            sampleDetectedGeneFusions + "," +
            sampleDetectedGeneNegative + "," +

            version 
        + ")";
        return row;
    }

    













}
