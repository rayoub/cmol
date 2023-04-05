package edu.kumc.cmol.qci;

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

    public static Pair<QciSample, List<QciVariant>> parseXml(String sampleId, Document xml) throws XPathExpressionException {

        Element doc = xml.getDocumentElement();

        QciSample sample = new QciSample();
        setSampleProperties(sampleId, sample, doc);

        List<QciVariant> variants = new ArrayList<>();
        NodeList nodes = doc.getElementsByTagName("variant");
        for (int i = 0; i < nodes.getLength(); i++) {

            Node node = nodes.item(i);
            if (node instanceof Element) {
                Element element = (Element) node;
                QciVariant variant = new QciVariant();
                setVariantProperties(sampleId, variant, element);
                variants.add(variant);
            }
        } 
        
        return Pair.of(sample, variants);
    }

    private static void setSampleProperties(String sampleId, QciSample sample, Element element) throws XPathExpressionException {

        XPath xpath = xpf.newXPath();

        sample.setSampleId(sampleId);

        sample.setSubjectId(xpath.evaluate("/report/subjectId", element));
        sample.setAccession(xpath.evaluate("/report/accession", element));
        sample.setTestDate(xpath.evaluate("/report/testDate", element));
        sample.setTestCode(xpath.evaluate("/report/testCode", element));
        sample.setClinicalFinding(xpath.evaluate("/report/clinicalFinding", element));
        sample.setDiagnosis(xpath.evaluate("/report/diagnosis", element));
        sample.setInterpretation(xpath.evaluate("/report/interpretation", element));
        
        sample.setSex(xpath.evaluate("/report/sex", element));
        sample.setDateOfBirth(xpath.evaluate("/report/dateOfBirth", element));
        sample.setOrderingPhysicianClient(xpath.evaluate("/report/orderingPhysicianClient", element));
        sample.setOrderingPhysicianFacilityName(xpath.evaluate("/report/orderingPhysicianFacilityName", element));
        sample.setOrderingPhysicianName(xpath.evaluate("/report/orderingPhysicianName", element));
        sample.setPathologistName(xpath.evaluate("/report/pathologistName", element));
        
        sample.setPrimaryTumorSite(xpath.evaluate("/report/primaryTumorSite", element));
        sample.setSpecimenId(xpath.evaluate("/report/specimenId", element));
        sample.setSpecimenType(xpath.evaluate("/report/specimenType", element));
        sample.setSpecimenCollectionDate(xpath.evaluate("/report/specimenCollectionDate", element));
        
        sample.setLabTestedCNVGain(xpath.evaluate("/report/labTestedCNVGain", element));
        sample.setLabTestedGenes(xpath.evaluate("/report/labTestedGenes", element));
    }

    private static void setVariantProperties(String sampleId, QciVariant variant, Element element) throws XPathExpressionException {

        XPath xpath = xpf.newXPath();

        variant.setSampleId(sampleId);
        
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
