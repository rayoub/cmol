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

    public static List<LookupVal> getAssayIds() throws SQLException {

        List<LookupVal> vals = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
           
        PreparedStatement stmt = conn.prepareCall("SELECT DISTINCT assay_folder AS id, assay_folder AS descr FROM ion_sample ORDER BY assay_folder;");
        
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
    public static List<LookupVal> getCmolIds() throws SQLException {

        List<LookupVal> vals = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
           
        PreparedStatement stmt = conn.prepareCall("SELECT DISTINCT cmol_id AS id, cmol_id AS descr FROM ion_sample ORDER BY cmol_id;");
        
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
