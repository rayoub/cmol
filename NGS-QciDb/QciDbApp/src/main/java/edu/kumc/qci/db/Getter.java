package edu.kumc.qci.db;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.rs.ProcessingException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.io.FileUtils;
import org.glassfish.jersey.jackson.JacksonFeature;
import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.qci.app.Config;

public class Getter {

    private static String BASE_URI = "https://api.ingenuity.com/v1";

    public static void getXml() throws IOException, SQLException {

        Client client = ClientBuilder.newBuilder()
            .register(JacksonFeature.class)
            .build();
        
        WebTarget target = client.target(BASE_URI).path("clinical")
            .queryParam("state", "final");

        String latestTestDate = getLatestTestDate();
        if (latestTestDate != null) {
            target = target.queryParam("startReceivedDate", latestTestDate);
        }

        Invocation.Builder invoke = target.request(MediaType.APPLICATION_JSON);
        invoke.header("Authorization", Config.API_KEY);

        Response response = invoke.get();

        // attempt to get the test
        Test[] tests = new Test[] {};
        try {

            tests = response.readEntity(Test[].class);
        }
        catch (ProcessingException e) {

            System.out.println("An error occurred. Make sure your access token is valid.");
        }

        // will be 0 tests on error
        for (Test test : tests) {

            target = client.target(test.exportUrl)
                .queryParam("view","reportXml");

            invoke = target.request(MediaType.APPLICATION_JSON);
            invoke.header("Authorization", Config.API_KEY);

            response = invoke.get();

            String xml = response.readEntity(String.class);

            File file = new File(Config.DATA_PATH, test.dataPackageID + ".xml");
            if (!file.exists()) {
                FileUtils.writeStringToFile(file, xml, StandardCharsets.UTF_8);
            }
        }
    }

    private static String getLatestTestDate() throws SQLException {

        Date latestTestDate = null;

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT MAX(test_date) AS test_date FROM qci_report;");

        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            latestTestDate = rs.getDate("test_date");
        }

        rs.close();
        stmt.close();
        conn.close();

        if (latestTestDate != null) {
            // conveniently returns the string in the format we need yyyy-mm-dd
            return latestTestDate.toString();
        }
        else {
            return null;
        }
    }
}