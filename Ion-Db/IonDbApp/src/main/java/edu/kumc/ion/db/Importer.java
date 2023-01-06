package edu.kumc.ion.db;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;

public class Importer {

    public static void truncateIonTables() throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT ion_truncate();");
    
        updt.execute();
        updt.close();

        conn.close();
    }

    public static void importSample(String sampleName) throws IOException {

        String fileName = sampleName + "-full.tsv";

        // parse file for sample
        Map<String, Integer> headers = Parser.parseHeaders(fileName);
        List<List<String>> listOfValues = Parser.parseValues(fileName);

        System.out.println("got Here");
        // fill list of variants
        List<Variant> variants = new ArrayList<>();
        for(List<String> values : listOfValues) {

            Variant variant = new Variant();

            variant.setGenes(values.get(headers.get("gene")));
            variant.setTranscript(values.get(headers.get("transcript")));
            variant.setCoding(values.get(headers.get("coding")));

            variants.add(variant);
        }

        System.out.println("got Here");
        // test output
        for (Variant variant : variants) {{

            System.out.println(variant.toString());
        }}
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
