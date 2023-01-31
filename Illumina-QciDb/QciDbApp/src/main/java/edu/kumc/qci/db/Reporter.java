package edu.kumc.qci.db;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

import org.postgresql.ds.PGSimpleDataSource;

public class Reporter {

    public static List<QueryRow> getQueryRows(QueryCriteria criteria) throws SQLException {

        List<QueryRow> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_qci_query(?,?,?,?,?,?,?);");

        // diagnoses
        if (criteria.getDiagnoses() == null || criteria.getDiagnoses().length == 0) {
            stmt.setNull(1, Types.ARRAY);
        }
        else {
            stmt.setArray(1, conn.createArrayOf("INTEGER", IntStream.of(criteria.getDiagnoses()).boxed().toArray()));
        }

        // from date
        if (criteria.getFromDate() == null || criteria.getFromDate().isBlank()) {
            stmt.setNull(2, Types.DATE);
        }
        else {
            stmt.setDate(2, Date.valueOf(criteria.getFromDate()));
        }
        
        // to date
        if (criteria.getToDate() == null || criteria.getToDate().isBlank()) {
            stmt.setNull(3, Types.DATE);
        }
        else {
            stmt.setDate(3, Date.valueOf(criteria.getToDate()));
        }
        
        // mrns
        boolean mrnsIsNull = true;
        String mrns = criteria.getMrns();
        if (mrns != null) {
            mrns = mrns.replaceAll("\\s","");
            if (!mrns.isEmpty()) {
                String[] a = mrns.split(";");
                stmt.setArray(4, conn.createArrayOf("VARCHAR", a));
                mrnsIsNull = false;
            }
        }
        if (mrnsIsNull) {
            stmt.setNull(4, Types.ARRAY);
        }

        // genes
        boolean genesIsNull = true;
        String genes = criteria.getGenes();
        if (genes != null) {
            genes = genes.replaceAll("\\s","");
            if (!genes.isEmpty()) {
                String[] a = genes.split(";");
                stmt.setArray(5, conn.createArrayOf("VARCHAR", a));
                genesIsNull = false;
            }
        }
        if (genesIsNull) {
            stmt.setNull(5, Types.ARRAY);
        }

        // tc change
        if (criteria.getTranscriptChange() == null || criteria.getTranscriptChange().isBlank()) {
            stmt.setNull(6, Types.VARCHAR);
        }
        else {
            stmt.setString(6, criteria.getTranscriptChange());
        }

        // pc change
        if (criteria.getProteinChange() == null || criteria.getProteinChange().isBlank()) {
            stmt.setNull(7, Types.VARCHAR);
        }
        else {
            stmt.setString(7, criteria.getProteinChange());
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            QueryRow row = new QueryRow();

            row.setReportId(rs.getString("report_id"));
            row.setMrn(rs.getString("mrn"));
            if (rs.wasNull()) row.setMrn("");
            row.setAccession(rs.getString("accession"));
            if (rs.wasNull()) row.setAccession("");
            row.setTestDate(rs.getString("test_date"));
            if (rs.wasNull()) row.setTestDate("");
            row.setTestCode(rs.getString("test_code"));
            if (rs.wasNull()) row.setTestCode("");
            row.setDiagnosis(rs.getString("diagnosis"));
            if (rs.wasNull()) row.setDiagnosis("");
            row.setInterpretation(rs.getString("interpretation"));
            if (rs.wasNull()) row.setInterpretation("");
            row.setPhysician(rs.getString("physician"));
            if (rs.wasNull()) row.setPhysician("");
            row.setGene(rs.getString("gene"));
            if (rs.wasNull()) row.setGene("");
            row.setAlleleFraction(rs.getDouble("allele_fraction"));
            if (rs.wasNull()) row.setAlleleFraction(-1.0);
            row.setTranscript(rs.getString("transcript"));
            if (rs.wasNull()) row.setTranscript("");
            row.setTranscriptChange(rs.getString("transcript_change"));
            if (rs.wasNull()) row.setTranscriptChange("");
            row.setTranscriptExon(rs.getInt("transcript_exon"));
            if (rs.wasNull()) row.setTranscriptExon(-1);
            row.setProtein(rs.getString("protein"));
            if (rs.wasNull()) row.setProtein("");
            row.setProteinChange(rs.getString("protein_change"));
            if (rs.wasNull()) row.setProteinChange("");
            row.setAssessment(rs.getString("assessment"));
            if (rs.wasNull()) row.setAssessment("");

            rows.add(row);
        }

        rs.close();
        stmt.close();
        conn.close();

        return rows;
    }
    
    public static List<Report> getReports() throws SQLException {

        List<Report> reports = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM qci_report;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            Report report = new Report();

            report.setReportId(rs.getString("report_id"));
            if (rs.wasNull()) report.setReportId("");
            report.setSubjectId(rs.getString("subject_id"));
            if (rs.wasNull()) report.setSubjectId("");
            report.setAccession(rs.getString("accession"));
            if (rs.wasNull()) report.setAccession("");
            report.setTestDate(rs.getString("test_date"));
            if (rs.wasNull()) report.setTestDate("");
            report.setTestCode(rs.getString("test_code"));
            if (rs.wasNull()) report.setTestCode("");
            report.setClinicalFinding(rs.getString("clinical_finding"));
            if (rs.wasNull()) report.setClinicalFinding("");
            report.setDiagnosis(rs.getString("diagnosis"));
            if (rs.wasNull()) report.setDiagnosis("");
            report.setInterpretation(rs.getString("interpretation"));
            if (rs.wasNull()) report.setInterpretation("");
            
            report.setSex(rs.getString("sex"));
            if (rs.wasNull()) report.setSex("");
            report.setDateOfBirth(rs.getString("date_of_birth"));
            if (rs.wasNull()) report.setDateOfBirth("");
            report.setOrderingPhysicianClient(rs.getString("ordering_physician_client"));
            if (rs.wasNull()) report.setOrderingPhysicianClient("");
            report.setOrderingPhysicianFacilityName(rs.getString("ordering_physician_facility_name"));
            if (rs.wasNull()) report.setOrderingPhysicianFacilityName("");
            report.setOrderingPhysicianName(rs.getString("ordering_physician_name"));
            if (rs.wasNull()) report.setOrderingPhysicianName("");
            report.setPathologistName(rs.getString("pathologist_name"));
            if (rs.wasNull()) report.setPathologistName("");
            
            report.setPrimaryTumorSite(rs.getString("primary_tumor_site"));
            if (rs.wasNull()) report.setPrimaryTumorSite("");
            report.setSpecimenId(rs.getString("specimen_id"));
            if (rs.wasNull()) report.setSpecimenId("");
            report.setSpecimenType(rs.getString("specimen_type"));
            if (rs.wasNull()) report.setSpecimenType("");
            report.setSpecimenCollectionDate(rs.getString("specimen_collection_date"));
            if (rs.wasNull()) report.setSpecimenCollectionDate("");

            report.setLabTestedCNVGain("");
            report.setLabTestedGenes("");

            reports.add(report);
        }

        rs.close();
        stmt.close();
        conn.close();

        return reports;
    }
    
    public static List<Variant> getVariants() throws SQLException {

        List<Variant> variants = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM qci_variant;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            Variant variant = new Variant();

            variant.setReportId(rs.getString("report_id"));
            variant.setChromosome(rs.getString("chromosome"));
            if (rs.wasNull()) variant.setChromosome("");
            variant.setPosition(rs.getInt("position"));
            if (rs.wasNull()) variant.setPosition(Variant.INT_NULL);
            variant.setReference(rs.getString("reference"));
            if (rs.wasNull()) variant.setReference("");
            variant.setAlternate(rs.getString("alternate"));
            if (rs.wasNull()) variant.setAlternate("");;
            variant.setGenotype(rs.getString("genotype"));
            if (rs.wasNull()) variant.setGenotype("");
            variant.setAssessment(rs.getString("assessment"));
            if (rs.wasNull()) variant.setAssessment("");
            variant.setActionability(rs.getString("actionability"));
            if (rs.wasNull()) variant.setActionability("");
            variant.setPhenotypeId(rs.getString("phenotype_id"));
            if (rs.wasNull()) variant.setPhenotypeId("");
            variant.setPhenotypeName(rs.getString("phenotype_name"));
            if (rs.wasNull()) variant.setPhenotypeName("");
            variant.setDbsnp(rs.getString("dbsnp"));
            if (rs.wasNull()) variant.setDbsnp("");
            variant.setCadd(rs.getDouble("cadd"));
            if (rs.wasNull()) variant.setCadd(Variant.DOUBLE_NULL);
            variant.setAlleleFraction(rs.getDouble("allele_fraction"));
            if (rs.wasNull()) variant.setAlleleFraction(Variant.DOUBLE_NULL);
            variant.setReadDepth(rs.getInt("read_depth"));
            if (rs.wasNull()) variant.setReadDepth(Variant.INT_NULL);
            variant.setVariation(rs.getString("variation"));
            if (rs.wasNull()) variant.setVariation("");
            variant.setGene(rs.getString("gene"));
            if (rs.wasNull()) variant.setGene("");
            variant.setTcTranscript(rs.getString("tc_transcript"));
            if (rs.wasNull()) variant.setTcTranscript("");
            variant.setTcChange(rs.getString("tc_change"));
            if (rs.wasNull()) variant.setTcChange("");
            variant.setTcExonNumber(rs.getInt("tc_exon_number"));
            if (rs.wasNull()) variant.setTcExonNumber(Variant.INT_NULL);
            variant.setTcRegion(rs.getString("tc_region"));
            if (rs.wasNull()) variant.setTcRegion("");
            variant.setPcProtein(rs.getString("pc_protein"));
            if (rs.wasNull()) variant.setPcProtein("");
            variant.setPcChange(rs.getString("pc_change"));
            if (rs.wasNull()) variant.setPcChange("");
            variant.setPcTranslationImpact(rs.getString("pc_translation_impact"));
            if (rs.wasNull()) variant.setPcTranslationImpact("");
            variant.setGcChange(rs.getString("gc_change"));
            if (rs.wasNull()) variant.setGcChange("");
            variant.setFunction(rs.getString("function"));
            if (rs.wasNull()) variant.setFunction("");
            variant.setReferenceCount(rs.getInt("reference_count"));
            if (rs.wasNull()) variant.setReferenceCount(Variant.INT_NULL);

            variants.add(variant);
        }

        rs.close();
        stmt.close();
        conn.close();

        return variants;
    }
}
