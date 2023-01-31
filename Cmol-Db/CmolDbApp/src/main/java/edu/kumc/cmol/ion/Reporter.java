package edu.kumc.cmol.ion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;

public class Reporter {
    
    public static List<Variant> getVariants(QueryCriteria criteria) throws SQLException { 

        List<Variant> variants = new ArrayList<>();

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
