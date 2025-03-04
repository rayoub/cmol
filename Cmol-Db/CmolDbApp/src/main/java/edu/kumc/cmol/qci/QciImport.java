package edu.kumc.cmol.qci;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.postgresql.ds.PGSimpleDataSource;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import edu.kumc.cmol.core.Ds;

public class QciImport {

    private static Set<String> BLACK_LIST = new HashSet<>();

    static {
        BLACK_LIST.add("DP_1302129100");
        BLACK_LIST.add("DP_1302137400");
    }

    public static void cleanQciTables() throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT clean_qci_all();");
    
        updt.execute();
        updt.close();

        conn.close();
    }

    public static void truncateQciTables() throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT qci_truncate();");
    
        updt.execute();
        updt.close();

        conn.close();
    }

    public static void importXml(String dataPath) throws XPathExpressionException, SAXException, IOException, ParserConfigurationException, SQLException {
        
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();

        Set<String> sampleIds = QciDb.getSampleIds();

        List<Path> filePaths = Files.list(Paths.get(dataPath))
            .filter(p -> !p.endsWith("xml"))
            .collect(Collectors.toList());

        List<QciSample> samples = new ArrayList<>();
        List<QciVariant> variants = new ArrayList<>();
        for(Path filePath : filePaths) {

            String sampleId = FilenameUtils.removeExtension(filePath.getFileName().toString());
            if (!sampleIds.contains(sampleId) && !BLACK_LIST.contains(sampleId)) {

                try {
                    Document xml = builder.parse(filePath.toFile());

                    Pair<QciSample, List<QciVariant>> pair = null;
                    try {
                        pair = Parser.parseXml(sampleId, xml);
                    } catch (ParseException e) {
                        pair = null;
                    }

                    if (pair != null) {
                        samples.add(pair.getLeft());
                        variants.addAll(pair.getRight());
                    }
                }
                catch (SAXParseException e) {
                    System.out.println(e.getMessage());
                }
            }
        }
        
        QciDb.saveSamples(samples);
        QciDb.saveVariants(variants);
    }
}
