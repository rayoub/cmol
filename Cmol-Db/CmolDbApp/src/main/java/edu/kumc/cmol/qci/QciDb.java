package edu.kumc.cmol.qci;

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
import java.util.stream.IntStream;

import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;
import edu.kumc.cmol.core.SampleInfo;

public class QciDb {

    public static List<QueryRow> getQueryRows(QueryCriteria criteria) throws SQLException {

        List<QueryRow> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_qci_query(?,?,?,?,?,?,?,?);");

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
        
        // exon 
        if (criteria.getExon() == null || criteria.getExon().isBlank()) {
            stmt.setNull(6, Types.INTEGER);
        }
        else {
            stmt.setInt(6, Integer.parseInt(criteria.getExon()));
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

            row.setSampleId(rs.getString("sample_id"));
            row.setSpecimenId(rs.getString("specimen_id"));
            if (rs.wasNull()) row.setSpecimenId("");
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
    
    public static SampleInfo getSampleInfo() throws SQLException {

        SampleInfo info = new SampleInfo();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
        PreparedStatement stmt = conn.prepareCall("SELECT COUNT(DISTINCT sample_id) AS sn, MAX(test_date)::VARCHAR AS ls FROM get_qci_query();");
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

    public static String getLatestTestDate() throws SQLException {

        Date latestTestDate = null;

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT MAX(test_date) AS test_date FROM qci_sample;");

        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            latestTestDate = rs.getDate("test_date");
        }

        rs.close();
        stmt.close();
        conn.close();

        if (latestTestDate != null) {
            // conveniently returns the string in the format we need yyyy-mm-dd
            return latestTestDate.toString();
        }
        else {
            return null;
        }
    }

    public static Set<String> getSampleIds() throws SQLException {

        Set<String> sampleIds = new HashSet<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT sample_id FROM qci_sample;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            sampleIds.add(rs.getString("sample_id"));
        }

        rs.close();
        stmt.close();
        conn.close();

        return sampleIds;
    }
    
    public static void saveSamples(List<QciSample> samples) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("qci_sample", QciSample.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_qci_sample(?);");
     
        QciSample a[] = new QciSample[samples.size()];
        samples.toArray(a);
        updt.setArray(1, conn.createArrayOf("qci_sample", a));
    
        updt.execute();
        updt.close();

        conn.close();
    }

    public static void saveVariants(List<QciVariant> variants) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("qci_variant", QciVariant.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_qci_variant(?);");
     
        QciVariant a[] = new QciVariant[variants.size()];
        variants.toArray(a);
        updt.setArray(1, conn.createArrayOf("qci_variant", a));
    
        updt.execute();
        updt.close();
        
        conn.close();
    }
}
