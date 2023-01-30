package edu.kumc.ion.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.ds.PGSimpleDataSource;

public class Reporter {
    
    public static List<Variant> getVariants() throws SQLException {

        List<Variant> variants = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM ion_variant;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            Variant variant = new Variant();

            variant.setSample(rs.getString("sample"));
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
}
