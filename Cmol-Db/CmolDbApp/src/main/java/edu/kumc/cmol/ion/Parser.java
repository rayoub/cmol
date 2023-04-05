package edu.kumc.cmol.ion;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import edu.kumc.cmol.core.Constants;

public class Parser {

    public static Map<String, Integer> parseHeaders(String fileName) throws IOException {

        Map<String, Integer> headers = null;
        String path = Paths.get(Constants.ION_DATA_PATH).resolve(fileName).toString();
        
        BufferedReader inputStream = null;
        try {

            inputStream = new BufferedReader(new FileReader(path));

            String line;
            while ((line = inputStream.readLine()) != null) {

                if (!line.startsWith("##")) {

                    if (line.startsWith("#")) {

                        headers = new HashMap<>();
                        String[] parts = line.substring(2).split("\t");
                        for (int i = 0; i < parts.length; i++) {
                            headers.put(parts[i], i);
                        }
                    }
                }
            }
        } 
        finally {

            if (inputStream != null) {
                inputStream.close();
            }
        }

        return headers;
    }
    
    public static List<List<String>> parseValues(String fileName) throws IOException {

        List<List<String>> listOfValues = new ArrayList<>();

        String path = Paths.get(Constants.ION_DATA_PATH).resolve(fileName).toString();
        BufferedReader inputStream = null;
        try {

            inputStream = new BufferedReader(new FileReader(path));

            String line;
            while ((line = inputStream.readLine()) != null) {

                if (!line.startsWith("#")) {

                    List<String> values = new ArrayList<String>();
                    String[] parts = line.split("\t");
                    for (int i = 0; i < parts.length; i++) {
                        values.add(parts[i]);
                    }
                    listOfValues.add(values);
                }
            }
        } 
        finally {

            if (inputStream != null) {
                inputStream.close();
            }
        }

        return listOfValues;
    }

    public static String getValue(Map<String, Integer> headers, List<String> values, String header) {

        String value = "";

        if (headers.containsKey(header)) {
             
            int i = headers.get(header);
            if (values.size() > i) {
                value = values.get(i);
            }
        }

        return value;
    }
}
