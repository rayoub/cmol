package edu.kumc.cmol.qci;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;
import edu.kumc.cmol.core.LookupVal;

public class QciLookup {

    public static List<LookupVal> getDiagnoses() throws SQLException {

        List<LookupVal> vals = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
           
        // maybe later switch based on lookupType
        PreparedStatement stmt = conn.prepareCall("SELECT id, descr FROM qci_diagnosis ORDER BY descr;");
        
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
           
            String id = Integer.toString(rs.getInt("id"));
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
