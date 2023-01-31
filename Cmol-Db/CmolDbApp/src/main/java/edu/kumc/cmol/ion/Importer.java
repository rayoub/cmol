package edu.kumc.cmol.ion;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;

public class Importer {

    public static void truncateIonTables() throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT ion_truncate();");
    
        updt.execute();
        updt.close();

        conn.close();
    }

    public static void importSample(String sampleName) throws IOException, SQLException {

        String fileName = sampleName + "-full.tsv";

        // parse file for sample
        Map<String, Integer> headers = Parser.parseHeaders(fileName);
        List<List<String>> listOfValues = Parser.parseValues(fileName);

        /*
        int i = 1;
        for(List<String> values : listOfValues) {

            System.out.println("-----------------------------------------------------------");
            System.out.println("index = " + i);
            for (String header : headers.keySet()) {
                System.out.println(header + " = " + Parser.getValue(headers, values, header));
            }
            i++;
            System.out.println("-----------------------------------------------------------");
        }
        */

        // fill list of variants
        List<Variant> variants = new ArrayList<>();
        for(List<String> values : listOfValues) {

            Variant variant = new Variant();

            variant.setSample(sampleName);
            variant.setLocus(Parser.getValue(headers, values, "locus"));
            variant.setGenotype(Parser.getValue(headers, values, "genotype"));
            variant.setFilter(Parser.getValue(headers, values, "filter"));
            variant.setRef(Parser.getValue(headers, values, "ref"));
            variant.setGenes(Parser.getValue(headers, values, "gene"));
            variant.setTranscript(Parser.getValue(headers, values, "transcript"));
            variant.setCoding(Parser.getValue(headers, values, "coding"));
            variant.setProtein(Parser.getValue(headers, values, "protein"));

            variants.add(variant);
        }

        saveVariants(variants);
    }
    
    private static void saveVariants(List<Variant> variants) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("ion_variant", Variant.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_ion_variant(?);");
     
        Variant a[] = new Variant[variants.size()];
        variants.toArray(a);
        updt.setArray(1, conn.createArrayOf("ion_variant", a));
    
        updt.execute();
        updt.close();
        
        conn.close();
    }
}
