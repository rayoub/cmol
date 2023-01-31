package edu.kumc.cmol.ion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.tuple.Pair;
import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;

public class IonLookup {

    public static List<Pair<String, String>> getSamples() throws SQLException {

        List<Pair<String, String>> vals = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
           
        // maybe later switch based on lookupType
        PreparedStatement stmt = conn.prepareCall("SELECT DISTINCT sample AS id, sample AS descr FROM ion_variant ORDER BY sample;");
        
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            
            String id = rs.getString("id");
            String descr = rs.getString("descr");
            Pair<String, String> val = Pair.of(id, descr);

            vals.add(val);
        }

        rs.close();
        stmt.close();
        conn.close();

        return vals;
    }
}
