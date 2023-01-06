package edu.kumc.qci.db;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class Importer {

    private static Set<String> BLACK_LIST = new HashSet<>();

    static {
        BLACK_LIST.add("DP_1302129100");
        BLACK_LIST.add("DP_1302137400");
    }

    public static void cleanQciTables() throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        PreparedStatement updt = conn.prepareStatement("SELECT clean_all();");
    
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

        Set<String> reportIds = getReportIds();

        List<Path> filePaths = Files.list(Paths.get(dataPath))
            .filter(p -> !p.endsWith("xml"))
            .collect(Collectors.toList());

        List<Report> reports = new ArrayList<>();
        List<Variant> variants = new ArrayList<>();
        for(Path filePath : filePaths) {

            String reportId = FilenameUtils.removeExtension(filePath.getFileName().toString());
            if (!reportIds.contains(reportId) && !BLACK_LIST.contains(reportId)) {

                Document xml = builder.parse(filePath.toFile());

                Pair<Report, List<Variant>> pair = Parser.parseXml(reportId, xml);

                reports.add(pair.getLeft());
                variants.addAll(pair.getRight());
            }
        }
        
        saveReports(reports);
        saveVariants(variants);
    }

    private static Set<String> getReportIds() throws SQLException {

        Set<String> reportIds = new HashSet<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT report_id FROM qci_report;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            reportIds.add(rs.getString("report_id"));
        }

        rs.close();
        stmt.close();
        conn.close();

        return reportIds;
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
