package edu.kumc.qci.db;

import java.util.ArrayList;
import java.util.List;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang3.tuple.Pair;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Parser {

    private static XPathFactory xpf;

    static {
        xpf = XPathFactory.newInstance();
    }

    public static Pair<Report, List<Variant>> parseXml(String reportId, Document xml) throws XPathExpressionException {

        Element doc = xml.getDocumentElement();

        Report report = new Report();
        setReportProperties(reportId, report, doc);

        List<Variant> variants = new ArrayList<>();
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
        
        return Pair.of(report, variants);
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
        report.setOrderingPhysicianClient(xpath.evaluate("/report/orderingPhysicianClient", element));
        report.setOrderingPhysicianFacilityName(xpath.evaluate("/report/orderingPhysicianFacilityName", element));
        report.setOrderingPhysicianName(xpath.evaluate("/report/orderingPhysicianName", element));
        report.setPathologistName(xpath.evaluate("/report/pathologistName", element));
        
        report.setPrimaryTumorSite(xpath.evaluate("/report/primaryTumorSite", element));
        report.setSpecimenId(xpath.evaluate("/report/specimenId", element));
        report.setSpecimenType(xpath.evaluate("/report/specimenType", element));
        report.setSpecimenCollectionDate(xpath.evaluate("/report/specimenCollectionDate", element));
        
        report.setLabTestedCNVGain(xpath.evaluate("/report/labTestedCNVGain", element));
        report.setLabTestedGenes(xpath.evaluate("/report/labTestedGenes", element));
    }

    private static void setVariantProperties(String reportId, Variant variant, Element element) throws XPathExpressionException {

        XPath xpath = xpf.newXPath();

        variant.setReportId(reportId);
        
        variant.setChromosome(xpath.evaluate("chromosome", element));
        String position = xpath.evaluate("position", element);
        if (!position.isBlank()) variant.setPosition(Integer.parseInt(position));
        variant.setReference(xpath.evaluate("reference", element));
        variant.setAlternate(xpath.evaluate("alternate", element));
        variant.setGenotype(xpath.evaluate("genotype", element));
        variant.setAssessment(xpath.evaluate("assessment", element));
        variant.setActionability(xpath.evaluate("actionability", element));
        variant.setPhenotypeId(xpath.evaluate("phenotype/@id", element));
        variant.setPhenotypeName(xpath.evaluate("phenotype/@name", element));
        variant.setDbsnp(xpath.evaluate("dbsnp", element));
        String cadd = xpath.evaluate("cadd", element);
        if (!cadd.isBlank()) variant.setCadd(Double.parseDouble(cadd));
        String alleleFraction = xpath.evaluate("allelefraction", element);
        if (!alleleFraction.isBlank()) variant.setAlleleFraction(Double.parseDouble(alleleFraction));
        String readDepth = xpath.evaluate("readdepth", element);
        if (!readDepth.isBlank()) variant.setReadDepth(Integer.parseInt(readDepth));
        variant.setVariation(xpath.evaluate("variation", element));
        variant.setGene(xpath.evaluate("gene", element));

        variant.setTcTranscript(xpath.evaluate("transcriptchange/transcript", element));
        variant.setTcChange(xpath.evaluate("transcriptchange/change", element));
        String exonNumber = xpath.evaluate("transcriptchange/exonNumber", element);
        if (!exonNumber.isBlank()) variant.setTcExonNumber(Integer.parseInt(exonNumber));
        variant.setTcRegion(xpath.evaluate("transcriptchange/region", element));
        variant.setPcProtein(xpath.evaluate("proteinchange/protein", element));
        variant.setPcChange(xpath.evaluate("proteinchange/change", element));
        variant.setPcTranslationImpact(xpath.evaluate("proteinchange/translationimpact", element));
        variant.setGcChange(xpath.evaluate("genomicchange/change", element));

        variant.setFunction(xpath.evaluate("function", element));
        String referenceCount = xpath.evaluate("referencecount", element);
        variant.setReferenceCount(Integer.parseInt(referenceCount));
    }
}
