package edu.kumc.cmol.qci;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import javax.ws.rs.ProcessingException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.io.FileUtils;
import org.glassfish.jersey.jackson.JacksonFeature;

import edu.kumc.cmol.core.Constants;

public class WS {
    
    private static String BASE_URI = "https://api.ingenuity.com/v1";

    public static String getToken() {
       
        Client client = ClientBuilder.newBuilder()
            .register(JacksonFeature.class)
            .build();
        
        WebTarget target = client.target(BASE_URI).path("oauth").path("access_token")
            .queryParam("grant_type", "client_credentials")
            .queryParam("client_id", "70e6a8c3594b6f953cf3bbfd2646cfd4")
            .queryParam("client_secret", "1d596fd5c8d0e8de0d40c2787b787922");
            
        Invocation.Builder invoke = target.request(MediaType.APPLICATION_JSON);

        Response response = invoke.get();

        AccessToken tokenBean = new AccessToken();
        try {

            tokenBean = response.readEntity(AccessToken.class);
        }
        catch (ProcessingException e) {

            System.out.println("An error occurred while getting the access token.");
            e.printStackTrace();
        }

        return tokenBean.access_token;
    }

    public static void getXml(String token, String latestTestDate) throws IOException {

        Client client = ClientBuilder.newBuilder()
            .register(JacksonFeature.class)
            .build();
        
        WebTarget target = client.target(BASE_URI).path("clinical")
            .queryParam("state", "final");

        if (latestTestDate != null) {
            target = target.queryParam("startReceivedDate", latestTestDate);
        }

        Invocation.Builder invoke = target.request(MediaType.APPLICATION_JSON);
        invoke.header("Authorization", token);

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

            File file = new File(Constants.QCI_DATA_PATH, test.dataPackageID + ".xml");
            if (!file.exists()) {

                target = client.target(test.exportUrl)
                    .queryParam("view","reportXml");

                invoke = target.request(MediaType.APPLICATION_JSON);
                invoke.header("Authorization", token); 

                response = invoke.get();

                String xml = response.readEntity(String.class);

                FileUtils.writeStringToFile(file, xml, StandardCharsets.UTF_8);
            }
        }
    }

    public static InputStream getPdf(String token, String accessionId) {

        Client client = ClientBuilder.newBuilder()
            .register(JacksonFeature.class)
            .build();

        client.property("accept", "application/pdf");
        
        WebTarget target = client.target(BASE_URI)
            .path("export")
            .path(accessionId)
            .queryParam("view","pdf");

        Invocation.Builder invoke = target.request();
        invoke.header("Authorization", token);

        Response response = invoke.get();

        InputStream inputStream = null;
        if (response.getStatus() == 200) {
            inputStream = response.readEntity(InputStream.class);
        }

        return inputStream;
    }
}
