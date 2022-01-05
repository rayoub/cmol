package edu.kumc.qci.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.ds.PGSimpleDataSource;

public class Reporter {

    public static List<QueryRow> getQueryRows(QueryCriteria criteria) throws SQLException {

        List<QueryRow> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_query(?,?,?);");

        boolean genesIsNull = true;
        String genes = criteria.getGenes();
        if (genes != null) {
            genes = genes.replaceAll("\\s","");
            if (!genes.isEmpty()) {
                String[] a = genes.split(";");
                stmt.setArray(1, conn.createArrayOf("VARCHAR", a));
                genesIsNull = false;
            }
        }
        if (genesIsNull) {
            stmt.setNull(1, Types.ARRAY);
        }

        if (criteria.getChangeType() == 1) {
            if (criteria.getTranscriptChange() == null || criteria.getTranscriptChange().isBlank()) {
                stmt.setNull(2, Types.VARCHAR);
            }
            else {
                stmt.setString(2, criteria.getTranscriptChange());
            }
            stmt.setNull(3, Types.VARCHAR);
        }
        else {
            stmt.setNull(2, Types.VARCHAR);
            if (criteria.getProteinChange() == null || criteria.getProteinChange().isBlank()) {
                stmt.setNull(3, Types.VARCHAR);
            }
            else {
                stmt.setString(3, criteria.getProteinChange());
            }
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            QueryRow row = new QueryRow();

            row.setN(rs.getInt("n"));
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
}
