package edu.kumc.ion.app;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Config {
    
    public static Properties Properties;

    public static String API_KEY;

    static {

        Properties = new Properties();

        try (InputStream input = new FileInputStream("config.properties")) {

            Properties.load(input);

            API_KEY = Properties.getProperty("API_KEY");

        } catch (IOException e) {

            // do nothing
        } 
    }
}