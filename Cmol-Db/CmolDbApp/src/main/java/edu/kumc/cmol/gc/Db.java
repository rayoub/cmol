package edu.kumc.cmol.gc;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;

public class Db {
    
    public static List<GCReferral> getGCReferrals(String fromDate, String toDate) throws SQLException {

        List<GCReferral> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_gc_referrals(?,?);");

        // from date
        if (fromDate == null || fromDate.isBlank()) {
            stmt.setNull(1, Types.DATE);
        }
        else {
            stmt.setDate(1, Date.valueOf(fromDate));
        }
        
        // from date
        if (toDate == null || toDate.isBlank()) {
            stmt.setNull(2, Types.DATE);
        }
        else {
            stmt.setDate(2, Date.valueOf(toDate));
        }
        
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            GCReferral ref = new GCReferral();

            ref.setReportId(rs.getString("report_id"));
            ref.setMrn(rs.getString("mrn"));
            if (rs.wasNull()) ref.setMrn("");
            ref.setAccession(rs.getString("accession"));
            if (rs.wasNull()) ref.setAccession("");
            ref.setAge(rs.getInt("age"));
            if (rs.wasNull()) ref.setAge(-1);
            ref.setTestDate(rs.getString("test_date"));
            if (rs.wasNull()) ref.setTestDate("");
            ref.setTestCode(rs.getString("test_code"));
            if (rs.wasNull()) ref.setTestCode("");
            ref.setTumorSite(rs.getString("tumor_site"));
            if (rs.wasNull()) ref.setTumorSite("");
            ref.setDiagnosis(rs.getString("diagnosis"));
            if (rs.wasNull()) ref.setDiagnosis("");
            ref.setInterpretation(rs.getString("interpretation"));
            if (rs.wasNull()) ref.setInterpretation("");
            ref.setPhysician(rs.getString("physician"));
            if (rs.wasNull()) ref.setPhysician("");
            ref.setGenes(rs.getString("genes"));
            if (rs.wasNull()) ref.setGenes("");
            ref.setNotified(rs.getInt("notified"));
            if (rs.wasNull()) ref.setNotified(0);

            rows.add(ref);
        }

        rs.close();
        stmt.close();
        conn.close();

        return rows;
    }

    public static void insertNotified(List<String> notified) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT insert_gc_notified(?);");
    
        String a[] = new String[notified.size()];
        notified.toArray(a);
        updt.setArray(1, conn.createArrayOf("VARCHAR", a));
        updt.execute();

        updt.close();
        conn.close();
    }
    
    public static void removeNotified(List<String> notified) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT remove_gc_notified(?);");
    
        String a[] = new String[notified.size()];
        notified.toArray(a);
        updt.setArray(1, conn.createArrayOf("VARCHAR", a));
        updt.execute();

        updt.close();
        conn.close();
    }
}
