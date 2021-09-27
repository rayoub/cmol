package edu.kumc.qci.db;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

public class ParseXml {

    public static void parse(String path) throws IOException, ParserConfigurationException, SAXException {
        
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();

        List<Path> xmlPaths = Files.list(Paths.get(path))
            .filter(p -> !p.endsWith("xml"))
            .sorted()
            .collect(Collectors.toList());

        for(Path xmlPath : xmlPaths) {

            Document xmlDoc = builder.parse(xmlPath.toFile());
            Element xmlRoot = xmlDoc.getDocumentElement();
            System.out.println(xmlRoot.getNodeName());
        }
    }
}
