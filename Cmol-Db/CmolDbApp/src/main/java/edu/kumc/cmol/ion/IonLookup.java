package edu.kumc.cmol.ion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;
import edu.kumc.cmol.core.LookupVal;

public class IonLookup {

    public static List<LookupVal> getSamples() throws SQLException {

        List<LookupVal> vals = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
           
        // maybe later switch based on lookupType
        PreparedStatement stmt = conn.prepareCall("SELECT DISTINCT sample AS id, sample AS descr FROM ion_variant ORDER BY sample;");
        
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            
            String id = rs.getString("id");
            String descr = rs.getString("descr");
            LookupVal val = new LookupVal(id, descr);

            vals.add(val);
        }

        rs.close();
        stmt.close();
        conn.close();

        return vals;
    }
}
