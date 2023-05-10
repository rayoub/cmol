package edu.kumc.cmol.ion;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Constants;
import edu.kumc.cmol.core.Ds;

public class IonImport {

    public static void truncateIonTables() throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT ion_truncate();");

        updt.execute();
        updt.close();

        conn.close();
    }

    public static List<IonSample> getSamples() throws IOException  {

        List<String> fileNames = Files.list(Paths.get(Constants.ION_DATA_PATH))
            .map(path -> path.getFileName().toString())
            .filter(fileName -> fileName.endsWith(".tsv"))
            .collect(Collectors.toList());

        // parse samples
        List<IonSample> samples = new ArrayList<>();
        for (String fileName : fileNames) {

            String[] parts = fileName.split(" ");

            IonSample sample = new IonSample();
            sample.setFileName(fileName);
            sample.setZipName(parts[2]);
            sample.setAssayFolder(parts[0]);
            sample.setSampleFolder(parts[1]);
            sample.setCmolId(parts[1].split("_")[0]);
            sample.setAccessionId(parts[1].split("_")[1]);

            samples.add(sample);
        }

        // return samples 
        return samples;
    }

    public static List<IonVariant> getVariants(IonSample sample) throws IOException {

        // parse file for sample
        Map<String, Integer> headers = Parser.parseHeaders(sample.getFileName());
        List<List<String>> listOfValues = Parser.parseValues(sample.getFileName());

        /*
         * int i = 1;
         * for(List<String> values : listOfValues) {
         * 
         * System.out.println(
         * "-----------------------------------------------------------");
         * System.out.println("index = " + i);
         * for (String header : headers.keySet()) {
         * System.out.println(header + " = " + Parser.getValue(headers, values,
         * header));
         * }
         * i++;
         * System.out.println(
         * "-----------------------------------------------------------");
         * }
         */

        // fill list of variants
        List<IonVariant> variants = new ArrayList<>();
        for (List<String> values : listOfValues) {

            IonVariant variant = new IonVariant();

            variant.setZipName(sample.getZipName());
            variant.setLocus(Parser.getValue(headers, values, "locus"));
            variant.setVariantType(Parser.getValue(headers, values, "type"));
            variant.setVariantSubtype(Parser.getValue(headers, values, "subtype"));
            variant.setGenotype(Parser.getValue(headers, values, "genotype"));
            variant.setFilter(Parser.getValue(headers, values, "filter"));
            variant.setRef(Parser.getValue(headers, values, "ref"));
            variant.setGenes(Parser.getValue(headers, values, "gene"));
            variant.setTranscript(Parser.getValue(headers, values, "transcript"));
            variant.setCoding(Parser.getValue(headers, values, "coding"));
            variant.setProtein(Parser.getValue(headers, values, "protein"));

            variants.add(variant);
        }

        return variants;
    }
    
    public static List<IonMrn> getMrns() throws IOException  {

        Set<String> unique = new HashSet<>();
        List<IonMrn> mrns = new ArrayList<>();

        String fileName = Constants.ION_DATA_PATH + "/mrns.csv";
        try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {

            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 2 && !parts[0].isBlank() && !parts[1].isBlank()) {
                
                    IonMrn mrn = new IonMrn();
                    mrn.setMrn(parts[0].trim());
                    mrn.setAccn(parts[1].trim());

                    if (!unique.contains(mrn.getMrn())) {
                        unique.add(mrn.getMrn());
                        mrns.add(mrn);
                    }
                }
            }
        }

        return mrns;
    }
}
