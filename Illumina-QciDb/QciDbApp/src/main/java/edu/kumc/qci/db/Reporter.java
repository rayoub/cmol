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

    public static List<QueryRow> getQueryRows(Criteria criteria) throws SQLException {

        List<QueryRow> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_query(?,?);");

        if (criteria.getChangeType() == 1) {
            if (criteria.getTranscriptChange() == null || criteria.getTranscriptChange().isBlank()) {
                stmt.setNull(1, Types.VARCHAR);
            }
            else {
                stmt.setString(1, criteria.getTranscriptChange());
            }
            stmt.setNull(2, Types.VARCHAR);
        }
        else {
            stmt.setNull(1, Types.VARCHAR);
            if (criteria.getProteinChange() == null || criteria.getProteinChange().isBlank()) {
                stmt.setNull(1, Types.VARCHAR);
            }
            else {
                stmt.setString(2, criteria.getProteinChange());
            }
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            QueryRow row = new QueryRow();

            row.setReportId(rs.getString("report_id"));
            row.setMrn(rs.getString("mrn"));
            row.setAccession(rs.getString("accession"));
            row.setTestDate(rs.getString("test_date"));
            row.setTestCode(rs.getString("test_code"));
            row.setDiagnosis(rs.getString("diagnosis"));
            row.setInterpretation(rs.getString("interpretation"));
            row.setPhysician(rs.getString("physician"));
            row.setGene(rs.getString("gene"));
            row.setAlleleFraction(rs.getDouble("allele_fraction"));
            row.setTranscript(rs.getString("transcript"));
            row.setTrasncriptChange(rs.getString("trasncript_change"));
            row.setProtein(rs.getString("protein"));
            row.setProteinChange(rs.getString("protein_change"));
            row.setAssessment(rs.getString("assessment"));

            rows.add(row);
        }

        rs.close();
        stmt.close();
        conn.close();

        return rows;
    }
}
