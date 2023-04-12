package edu.kumc.cmol.ion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;

public class IonDb {
    
    public static List<QueryRow> getQueryRows(QueryCriteria criteria) throws SQLException { 

        List<QueryRow> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_ion_query(?,?,?);");
        
        // assay folder
        if (criteria.getAssayFolder() == null || criteria.getAssayFolder().isBlank()) {
            stmt.setNull(1, Types.VARCHAR);
        }
        else {
            stmt.setString(1, criteria.getAssayFolder());
        }

        // cmol id
        if (criteria.getCmolId() == null || criteria.getCmolId().isBlank()) {
            stmt.setNull(2, Types.VARCHAR);
        }
        else {
            stmt.setString(2, criteria.getCmolId());
        }
        
        // genes
        boolean genesIsNull = true;
        String genes = criteria.getGenes();
        if (genes != null) {
            genes = genes.replaceAll("\\s","");
            if (!genes.isEmpty()) {
                String[] a = genes.split(";");
                stmt.setArray(3, conn.createArrayOf("VARCHAR", a));
                genesIsNull = false;
            }
        }
        if (genesIsNull) {
            stmt.setNull(3, Types.ARRAY);
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            QueryRow row = new QueryRow();

            row.setAssayFolder(rs.getString("assay_folder"));
            row.setCmolId(rs.getString("cmol_id"));
            row.setAccessionId(rs.getString("accession_id"));
            row.setLocus(rs.getString("locus"));
            row.setType(rs.getString("type"));
            row.setSubtype(rs.getString("subtype"));
            if (rs.wasNull()) row.setSubtype("");
            row.setGenotype(rs.getString("genotype"));
            if (rs.wasNull()) row.setGenotype("");
            row.setFilter(rs.getString("filter"));
            if (rs.wasNull()) row.setFilter("");
            row.setRef(rs.getString("ref"));
            if (rs.wasNull()) row.setRef("");
            row.setGenes(rs.getString("genes"));
            if (rs.wasNull()) row.setGenes("");
            row.setTranscript(rs.getString("transcript"));
            if (rs.wasNull()) row.setTranscript("");
            row.setCoding(rs.getString("coding"));
            if (rs.wasNull()) row.setCoding("");
            row.setProtein(rs.getString("protein"));
            if (rs.wasNull()) row.setProtein("");

            rows.add(row);
        }

        rs.close();
        stmt.close();
        conn.close();

        return rows;
    }

    public static Set<String> getZipNames() throws SQLException {

        Set<String> zipNames = new HashSet<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT zip_name FROM ion_sample;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            zipNames.add(rs.getString("zip_name"));
        }

        rs.close();
        stmt.close();
        conn.close();

        return zipNames;
    }

    public static void saveSamples(List<IonSample> samples) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("ion_sample", IonSample.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_ion_sample(?);");

        IonSample a[] = new IonSample[samples.size()];
        samples.toArray(a);
        updt.setArray(1, conn.createArrayOf("ion_sample", a));

        updt.execute();
        updt.close();

        conn.close();
    }

    public static void saveVariants(List<IonVariant> variants) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("ion_variant", IonVariant.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_ion_variant(?);");

        IonVariant a[] = new IonVariant[variants.size()];
        variants.toArray(a);
        updt.setArray(1, conn.createArrayOf("ion_variant", a));

        updt.execute();
        updt.close();

        conn.close();
    }
}
