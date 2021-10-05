package edu.kumc.qci.app;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Config {
    
    public static Properties Properties;

    public static String APP_NAME;
    public static String DB_NAME;
    public static String DB_USER;
    public static String DB_PASSWORD;
    public static String DATA_PATH;

    static {

        Properties = new Properties();

        try (InputStream input = new FileInputStream("config.properties")) {

            Properties.load(input);

            APP_NAME = Properties.getProperty("APP_NAME");
            DB_NAME = Properties.getProperty("DB_NAME");
            DB_USER = Properties.getProperty("DB_USER");
            DB_PASSWORD = Properties.getProperty("DB_PASSWORD");
            DATA_PATH = Properties.getProperty("DATA_PATH");

        } catch (IOException e) {

            // do nothing
        } 
    }
}