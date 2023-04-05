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
    
    public static List<IonVariant> getVariants(QueryCriteria criteria) throws SQLException { 

        List<IonVariant> variants = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_ion_query(?);");

        // tc change
        if (criteria.getSample() == null || criteria.getSample().isBlank()) {
            stmt.setNull(1, Types.VARCHAR);
        }
        else {
            stmt.setString(1, criteria.getSample());
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            IonVariant variant = new IonVariant();

            variant.setZipName(rs.getString("zipName"));
            variant.setLocus(rs.getString("locus"));
            variant.setGenotype(rs.getString("genotype"));
            if (rs.wasNull()) variant.setGenotype("");
            variant.setFilter(rs.getString("filter"));
            if (rs.wasNull()) variant.setFilter("");
            variant.setRef(rs.getString("ref"));
            if (rs.wasNull()) variant.setRef("");
            variant.setGenes(rs.getString("genes"));
            if (rs.wasNull()) variant.setGenes("");
            variant.setTranscript(rs.getString("transcript"));
            if (rs.wasNull()) variant.setTranscript("");
            variant.setCoding(rs.getString("coding"));
            if (rs.wasNull()) variant.setCoding("");
            variant.setProtein(rs.getString("protein"));
            if (rs.wasNull()) variant.setProtein("");

            variants.add(variant);
        }

        rs.close();
        stmt.close();
        conn.close();

        return variants;
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
