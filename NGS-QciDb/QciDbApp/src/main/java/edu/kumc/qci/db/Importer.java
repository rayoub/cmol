package edu.kumc.qci.db;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

// TODO: 
// 1. make a function that simply gets the latest xml based on the latest xml we have available and populate the data directory
// 2. importXml function should not process xml that has already been processed. 
// yes, it will have to do a few thousand pointless lookup to not do the work but that is not really a big deal

public class Importer {

    public static void importXml(String dataPath) throws XPathExpressionException, SAXException, IOException, ParserConfigurationException, SQLException {
        
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();

        List<Path> filePaths = Files.list(Paths.get(dataPath))
            .filter(p -> !p.endsWith("xml"))
            .collect(Collectors.toList());

        List<Report> reports = new ArrayList<>();
        List<Variant> variants = new ArrayList<>();
        for(Path filePath : filePaths) {

            String reportId = FilenameUtils.removeExtension(filePath.getFileName().toString());

            Document xml = builder.parse(filePath.toFile());

            Pair<Report, List<Variant>> pair = Parser.parseXml(reportId, xml);

            reports.add(pair.getLeft());
            variants.addAll(pair.getRight());
        }
        
        saveReports(reports);
        saveVariants(variants);
    }

    private static void saveReports(List<Report> reports) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("qci_report", Report.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_qci_report(?);");
     
        Report a[] = new Report[reports.size()];
        reports.toArray(a);
        updt.setArray(1, conn.createArrayOf("qci_report", a));
    
        updt.execute();
        updt.close();

        conn.close();
    }

    private static void saveVariants(List<Variant> variants) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("qci_variant", Variant.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_qci_variant(?);");
     
        Variant a[] = new Variant[variants.size()];
        variants.toArray(a);
        updt.setArray(1, conn.createArrayOf("qci_variant", a));
    
        updt.execute();
        updt.close();
        
        conn.close();
    }
}
