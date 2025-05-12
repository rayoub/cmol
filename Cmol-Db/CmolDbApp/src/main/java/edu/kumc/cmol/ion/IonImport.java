package edu.kumc.cmol.ion;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
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

import com.fasterxml.jackson.databind.ObjectMapper;

import edu.kumc.cmol.core.Constants;
import edu.kumc.cmol.core.Ds;
import htsjdk.variant.variantcontext.Genotype;
import htsjdk.variant.variantcontext.GenotypesContext;
import htsjdk.variant.variantcontext.VariantContext;
import htsjdk.variant.vcf.VCFFileReader;

public class IonImport {

    public static void truncateIonTables() throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT ion_truncate();");

        updt.execute();
        updt.close();

        conn.close();
    }

    public static List<IonSample> getSamples(DownloadType downloadType) throws IOException  {

        List<IonSample> samples = new ArrayList<>();

        List<String> vcfFileNames = Files.list(Paths.get(Constants.ION_DATA_PATH))
            .map(path -> path.getFileName().toString())
            .filter(fileName -> fileName.endsWith(".vcf") && fileName.contains(downloadType.getPattern()))
            .collect(Collectors.toList());

        // parse samples
        for (String vcfFileName : vcfFileNames) {

            String[] parts = vcfFileName.split(" ");

            // get corresponding tsv file name
            List<String> tsvFileNames = Files.list(Paths.get(Constants.ION_DATA_PATH))
                .map(path -> path.getFileName().toString())
                .filter(fileName -> fileName.startsWith(parts[0] + " " + parts[1] + " " + parts[2]) && fileName.endsWith(".tsv"))
                .collect(Collectors.toList());

            String tsvFileName = "";
            if (tsvFileNames.size() > 0) {
                tsvFileName = tsvFileNames.get(0);
            }
            else {
                continue;
            }

            String assayFolder = parts[0];
            String sampleFolder = parts[1];
            String zipHash = parts[2];
            String analysisDate = parts[3];

            IonSample sample = new IonSample();
            sample.setVcfFileName(vcfFileName);
            sample.setTsvFileName(tsvFileName);
            sample.setDownloadType(downloadType.getPattern());
            sample.setZipHash(zipHash);
            sample.setAssayFolder(assayFolder);
            sample.setSampleFolder(sampleFolder);
            sample.setAnalysisDate(analysisDate);

            String[] idParts = sampleFolder.split("_");
            if (idParts.length > 1) {
                if (idParts[0].isEmpty() || idParts[0].startsWith("D")) {
                    sample.setSpecimenId(idParts[0]); 
                    sample.setAccessionId(idParts[1]);
                    sample.setMrn("");
                }
                else {
                    sample.setSpecimenId(idParts[1]); 
                    sample.setAccessionId(idParts[1]);
                    sample.setMrn(idParts[0]);
                }
            }
            else {
                sample.setSpecimenId(sampleFolder);
                sample.setAccessionId(sampleFolder);
                sample.setMrn("");
            }

            samples.add(sample);
        } 

        // return samples 
        return samples;
    }

    public static List<IonVariant> getVariants(IonSample sample) throws IOException {

        // open vcf file for sample
        VCFFileReader reader = null;
        if (!sample.getVcfFileName().isEmpty()) {
            Path path = Path.of(Paths.get(Constants.ION_DATA_PATH).resolve(sample.getVcfFileName()).toString());
            reader = new VCFFileReader(path, false);
        }
      
        // parse tsv file for sample
        Map<String, Integer> headers = TsvParser.parseHeaders(sample.getTsvFileName());
        List<List<String>> listOfValues = TsvParser.parseValues(sample.getTsvFileName());

        // fill list of variants
        List<IonVariant> variants = new ArrayList<>();
        for (List<String> values : listOfValues) {

            IonVariant variant = new IonVariant();

            variant.setZipHash(sample.getZipHash());
            variant.setLocus(TsvParser.getValue(headers, values, "locus"));
            variant.setVariantType(TsvParser.getValue(headers, values, "type"));
            variant.setVariantSubtype(TsvParser.getValue(headers, values, "subtype"));
            variant.setGenotype(TsvParser.getValue(headers, values, "genotype"));
            variant.setFilter(TsvParser.getValue(headers, values, "filter"));
            variant.setCoverage(TsvParser.getValue(headers, values, "coverage"));
            variant.setAlleleCoverage(TsvParser.getValue(headers, values, "allele_coverage").replace(",", ";"));
            variant.setAlleleRatio(TsvParser.getValue(headers, values, "allele_ratio").replace(",", ";"));
            variant.setAlleleFrequency(TsvParser.getValue(headers, values, "allele_frequency_%"));
            variant.setRef(TsvParser.getValue(headers, values, "ref"));
            variant.setNormalizedAlt(TsvParser.getValue(headers, values, "normalizedAlt"));
            variant.setGenes(TsvParser.getValue(headers, values, "gene"));
            variant.setTranscript(TsvParser.getValue(headers, values, "transcript"));
            variant.setLocation(TsvParser.getValue(headers, values, "location"));
            variant.setFunction(TsvParser.getValue(headers, values, "function"));
            variant.setExon(TsvParser.getValue(headers, values, "exon"));
            variant.setCoding(TsvParser.getValue(headers, values, "coding"));
            variant.setProtein(TsvParser.getValue(headers, values, "protein"));
           
            variant.setCopyNumber("");
            variant.setCopyNumberType("");
            variant.setFoldDiff("");
            if (variant.getVariantType().equals("CNV") && reader != null) {

                String chr = variant.getLocus().split(":")[0];
                int position = Integer.parseInt(variant.getLocus().split("_")[0].split("-")[0].split(":")[1]);
                try {
                    for (VariantContext context : reader) {
                            
                        if (context.getContig().equals(chr) && context.getStart() == position) {
                            
                            GenotypesContext gcontext = context.getGenotypes();
                            Genotype g = gcontext.get(0);

                            // copy number 
                            String cn = (String)g.getAnyAttribute("CN"); 
                            if (cn == null || cn.equals("null")) {
                                cn = "";
                            }
                            variant.setCopyNumber(cn);

                            // fold diff 
                            String fd = (String)g.getAnyAttribute("FD"); 
                            if (fd == null || fd.equals("null")) {
                                fd = "";
                            }
                            variant.setFoldDiff(fd);

                            // strip
                            String json = context.getAttributeAsString("FUNC", "");
                            if (json.startsWith("[[")) {
                                json = json.substring(1, json.length() - 1).replace("'", "\"");
                            }

                            // copy number type
                            ObjectMapper mapper = new ObjectMapper();
                            CnvFUNC[] objs = mapper.readValue(json, CnvFUNC[].class);
                            CnvFUNC obj = objs[0];
                            variant.setCopyNumberType(obj.oncomineVariantClass);

                            break;
                        }
                    }
                }
                catch(Exception e) {
                    // do nothing
                }
            }

            variants.add(variant);
        }

        if (reader != null) {
            reader.close();
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
