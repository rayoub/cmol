package edu.kumc.qci.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.ds.PGSimpleDataSource;

public class Lookup {

    public static List<LookupVal> getLookup(LookupType lookupType) throws SQLException {

        List<LookupVal> vals = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
           
        // maybe later switch based on lookupType
        PreparedStatement stmt = conn.prepareCall("SELECT id, descr FROM qci_diagnosis ORDER BY descr;");
        
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            
            LookupVal val = new LookupVal();
            val.setId(rs.getInt("id"));
            val.setDescr(rs.getString("descr"));

            vals.add(val);
        }

        rs.close();
        stmt.close();
        conn.close();

        return vals;
    }
}
