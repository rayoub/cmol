package edu.kumc.cmol.lab;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;
import edu.kumc.cmol.core.SampleInfo;

public class LabDb {

    public static List<QueryRow> getQueryRows(QueryCriteria criteria) throws SQLException {

        List<QueryRow> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_lab_query(?,?,?,?,?,?,?,?);");
        
        // diagnosis terms
        boolean dTermsIsNull = true;
        String dTerms = criteria.getDTerms().trim();
        if (dTerms != null) {
            if (!dTerms.isEmpty()) {
                String[] a = dTerms.split(";");
                stmt.setArray(1, conn.createArrayOf("VARCHAR", a));
                dTermsIsNull = false;
            }
        }
        if (dTermsIsNull) {
            stmt.setNull(1, Types.ARRAY);
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
        
        // exon 
        if (criteria.getExon() == null || criteria.getExon().isBlank()) {
            stmt.setNull(6, Types.VARCHAR);
        }
        else {
            stmt.setString(6, criteria.getExon());
        }

        // tc change
        if (criteria.getTranscriptChange() == null || criteria.getTranscriptChange().isBlank()) {
            stmt.setNull(7, Types.VARCHAR);
        }
        else {
            stmt.setString(7, criteria.getTranscriptChange());
        }

        // pc change
        if (criteria.getProteinChange() == null || criteria.getProteinChange().isBlank()) {
            stmt.setNull(8, Types.VARCHAR);
        }
        else {
            stmt.setString(8, criteria.getProteinChange());
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            QueryRow row = new QueryRow();

            row.setRunId(rs.getString("run_id"));
            row.setSpecimenId(rs.getString("specimen_id"));
            row.setMrn(rs.getString("mrn"));
            if (rs.wasNull()) row.setMrn("");
            row.setAccession(rs.getString("accession"));
            if (rs.wasNull()) row.setAccession("");
            row.setReportedDate(rs.getString("reported_date"));
            if (rs.wasNull()) row.setReportedDate("");
            row.setTestCode(rs.getString("test_code"));
            if (rs.wasNull()) row.setTestCode("");
            row.setSampleType(rs.getString("sample_type"));
            if (rs.wasNull()) row.setSampleType("");
            row.setDiagnosis(rs.getString("diagnosis"));
            if (rs.wasNull()) row.setDiagnosis("");
            row.setSurgpathId(rs.getString("surgpath_id"));
            if (rs.wasNull()) row.setSurgpathId("");
            row.setArchived(rs.getString("archived"));
            if (rs.wasNull()) row.setArchived("");
            row.setLocus(rs.getString("locus"));
            if (rs.wasNull()) row.setLocus("");
            row.setGene(rs.getString("gene"));
            if (rs.wasNull()) row.setGene("");
            row.setAlleleFraction(rs.getDouble("allele_fraction"));
            if (rs.wasNull()) row.setAlleleFraction(-1.0);
            row.setTranscript(rs.getString("transcript"));
            if (rs.wasNull()) row.setTranscript("");
            row.setTranscriptChange(rs.getString("transcript_change"));
            if (rs.wasNull()) row.setTranscriptChange("");
            row.setTranscriptExon(rs.getString("transcript_exon"));
            if (rs.wasNull()) row.setTranscriptExon("");
            row.setProteinChange(rs.getString("protein_change"));
            if (rs.wasNull()) row.setProteinChange("");
            row.setAssessment(rs.getString("assessment"));
            if (rs.wasNull()) row.setAssessment("");
            row.setReported(rs.getString("reported"));
            if (rs.wasNull()) row.setReported("");

            rows.add(row);
        }

        rs.close();
        stmt.close();
        conn.close();

        return rows;
    }
    
    public static Set<String> getExisting() throws SQLException {

        Set<String> existing = new HashSet<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT run_id, specimen_id FROM lab_sample;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            String runId = rs.getString("run_id");
            String specimenId = rs.getString("specimen_id");
            String combinedId = runId + "$" + specimenId;

            existing.add(combinedId);
        }

        rs.close();
        stmt.close();
        conn.close();

        return existing;
    }

    public static SampleInfo getSampleInfo() throws SQLException {

        SampleInfo info = new SampleInfo();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
        PreparedStatement stmt = conn.prepareCall("SELECT COUNT(DISTINCT specimen_id) AS sn, MAX(reported_date)::VARCHAR AS ls FROM get_lab_query();");
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            info.setCount(rs.getInt("sn"));
            info.setLatest(rs.getString("ls"));
        }

        rs.close();
        stmt.close();
        conn.close();

        return info;
    }

    public static void saveSamples(List<LabSample> samples) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("lab_sample", LabSample.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_lab_sample(?);");
     
        LabSample a[] = new LabSample[samples.size()];
        samples.toArray(a);
        updt.setArray(1, conn.createArrayOf("lab_sample", a));
    
        updt.execute();
        updt.close();

        conn.close();
    }

    public static void saveVariants(List<LabVariant> variants) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("lab_variant", LabVariant.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_lab_variant(?);");
     
        LabVariant a[] = new LabVariant[variants.size()];
        variants.toArray(a);
        updt.setArray(1, conn.createArrayOf("lab_variant", a));
    
        updt.execute();
        updt.close();
        
        conn.close();
    }
}
