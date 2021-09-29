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
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.io.FilenameUtils;
import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ParseXml {

    private static XPathFactory xpf;

    static {
        xpf = XPathFactory.newInstance();
    }

    public static void parse(String dataPath) throws XPathExpressionException, SAXException, IOException, ParserConfigurationException, SQLException {
        
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();

        List<Path> filePaths = Files.list(Paths.get(dataPath))
            .filter(p -> !p.endsWith("xml"))
            .collect(Collectors.toList());

        List<Report> reports = new ArrayList<>();
        List<Variant> variants = new ArrayList<>();
        for(Path filePath : filePaths) {

            Document xml = builder.parse(filePath.toFile());
            Element doc = xml.getDocumentElement();

            String reportId = FilenameUtils.removeExtension(filePath.getFileName().toString());

            Report report = new Report();
            setReportProperties(reportId, report, doc);
            reports.add(report);

            NodeList nodes = doc.getElementsByTagName("variant");
            for (int i = 0; i < nodes.getLength(); i++) {

                Node node = nodes.item(i);
                if (node instanceof Element) {
                    Element element = (Element) node;
                    Variant variant = new Variant();
                    setVariantProperties(reportId, variant, element);
                    variants.add(variant);
                }
            } 
        }

        saveReports(reports);
        saveVariants(variants);
    }

    private static void setReportProperties(String reportId, Report report, Element element) throws XPathExpressionException {

        XPath xpath = xpf.newXPath();

        report.setReportId(reportId);

        report.setSubjectId(xpath.evaluate("/report/subjectId", element));
        report.setAccession(xpath.evaluate("/report/accession", element));
        report.setTestDate(xpath.evaluate("/report/testDate", element));
        report.setTestCode(xpath.evaluate("/report/testCode", element));
        report.setClinicalFinding(xpath.evaluate("/report/clinicalFinding", element));
        report.setDiagnosis(xpath.evaluate("/report/diagnosis", element));
        report.setInterpretation(xpath.evaluate("/report/interpretation", element));
        
        report.setSex(xpath.evaluate("/report/sex", element));
        report.setDateOfBirth(xpath.evaluate("/report/dateOfBirth", element));
        
        report.setOrderingPhysicianClient(xpath.evaluate("/report/orderingPhysicianCLient", element));
        report.setOrderingPhysicianFacilityName(xpath.evaluate("/report/orderingPhysicianFacilityName", element));
        report.setOrderingPhysicianName(xpath.evaluate("/report/orderingPhysicianName", element));
        report.setPathologistName(xpath.evaluate("/report/pathologistName", element));
        
        report.setPrimaryTumorSite(xpath.evaluate("/report/primaryTumorSite", element));
        report.setSpecimenId(xpath.evaluate("/report/specimenId", element));
        report.setSpecimenType(xpath.evaluate("/report/specimenType", element));
        report.setSpecimenCollectionDate(xpath.evaluate("/report/specimenCollectionDate", element));
        
        report.setLabTestedCNVGain(xpath.evaluate("/report/labTestedCNVGain", element));
        report.setLabTestedGenes(xpath.evaluate("/report/labTestedGenes", element));
        report.setLabTranscriptIds(xpath.evaluate("/report/labTranscriptIds", element));
    }

    private static void setVariantProperties(String reportId, Variant variant, Element element) throws XPathExpressionException {

        XPath xpath = xpf.newXPath();

        variant.setReportId(reportId);
        
        variant.setChromosome(xpath.evaluate("chromosome", element));
        variant.setPosition(xpath.evaluate("position", element));
        variant.setReference(xpath.evaluate("reference", element));
        variant.setAlternate(xpath.evaluate("alternate", element));
        variant.setGenotype(xpath.evaluate("genotype", element));
        variant.setAssessment(xpath.evaluate("assessment", element));
        variant.setActionability(xpath.evaluate("actionability", element));
        variant.setPhenotypeId(xpath.evaluate("phenotype/@id", element));
        variant.setPhenotypeName(xpath.evaluate("phenotype/@name", element));
        variant.setDbsnp(xpath.evaluate("dbsnp", element));
        variant.setCadd(xpath.evaluate("cadd", element));
        variant.setAlleleFraction(xpath.evaluate("allelefraction", element));
        variant.setReadDepth(xpath.evaluate("readdepth", element));
        variant.setVariation(xpath.evaluate("variation", element));
        variant.setGene(xpath.evaluate("gene", element));

        variant.setTcTranscript(xpath.evaluate("transcriptchange/transcript", element));
        variant.setTcChange(xpath.evaluate("transcriptchange/change", element));
        variant.setTcExonNumber(xpath.evaluate("transcriptchange/exonNumber", element));
        variant.setTcRegion(xpath.evaluate("transcriptchange/region", element));
        variant.setPcProtein(xpath.evaluate("proteinchange/protein", element));
        variant.setPcChange(xpath.evaluate("proteinchange/change", element));
        variant.setPcTranslationImpact(xpath.evaluate("proteinchange/translationimpact", element));
        variant.setGcChange(xpath.evaluate("genomicchange/change", element));

        variant.setFunction(xpath.evaluate("function", element));
        variant.setReferenceCount(xpath.evaluate("referencecount", element));
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
