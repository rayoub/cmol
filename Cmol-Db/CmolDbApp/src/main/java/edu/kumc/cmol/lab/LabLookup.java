package edu.kumc.cmol.lab;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;

public class LabLookup {

    public static List<String> getDiagnoses() throws SQLException {

        List<String> vals = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
           
        // maybe later switch based on lookupType
        PreparedStatement stmt = conn.prepareCall("SELECT DISTINCT diagnosis FROM lab_sample WHERE diagnosis IS NOT NULL ORDER BY diagnosis;");
        
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
           
            vals.add(rs.getString("diagnosis"));
        }

        rs.close();
        stmt.close();
        conn.close();

        return vals;
    }
}
