package edu.kumc.cmol.gc;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.activation.DataHandler;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;

import org.postgresql.ds.PGSimpleDataSource;

import com.microsoft.aad.msal4j.ClientCredentialFactory;
import com.microsoft.aad.msal4j.ClientCredentialParameters;
import com.microsoft.aad.msal4j.ConfidentialClientApplication;
import com.microsoft.aad.msal4j.IAuthenticationResult;
import com.microsoft.aad.msal4j.IClientCredential;

import edu.kumc.cmol.core.Ds;
import edu.kumc.cmol.qci.WS;

public class Notifier {
    
    private static String CLIENT_ID = "6973972a-823c-4b99-b3b3-3cac1e41e0b6";
    private static String CLIENT_SECRET = "YB.8Q~-bYeTd_K0kbZhkLVykbAFgzoHDWr3MccW2";
    private static String AUTHORITY = "https://login.microsoftonline.com/512a103e-41eb-42ff-be28-4a34173b1803/";

    private static String TENANT_ID = "512a103e-41eb-42ff-be28-4a34173b1803";
    private static Set<String> SCOPE = Collections.singleton("api://" + TENANT_ID + "/.default");

    public static String getAccessToken() throws MalformedURLException {

        IClientCredential credential = ClientCredentialFactory.createFromSecret(CLIENT_SECRET);
        ConfidentialClientApplication app = 
            ConfidentialClientApplication
                .builder(CLIENT_ID, credential)
                .authority(AUTHORITY)
                .build();

        ClientCredentialParameters parameters =
                ClientCredentialParameters
                        .builder(SCOPE)
                        .build();

        IAuthenticationResult auth = app.acquireToken(parameters).join();

        return auth.accessToken();
    }

    public static void Notify() throws MalformedURLException {

        List<String> accessionIds = getToNotify(90);

        List<String> toEmails = new ArrayList<>();
        toEmails.add("ronaldayoub@outlook.com");
        toEmails.add("sschmitt@kumc.edu");
        toEmails.add("shyter@kumc.edu");
        toEmails.add("rayoub@kumc.edu");
        
        String token = WS.getToken();
        if (token != null) {
            List<String> notified = sendEmail(token, accessionIds, toEmails);
            if (notified.size() > 0){
                saveNotified(notified);
            }
        }
    }

    public static List<String> sendEmail(String token, List<String> accessionIds, List<String> toEmails) throws MalformedURLException {

        List<String> notified = new ArrayList<>();












    
        // properties
        //props.put("mail.smtp.host", "smtp.gmail.com"); 
		//props.put("mail.smtp.socketFactory.port", "465"); 
		//props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory"); 
		//props.put("mail.smtp.auth", "true"); 
		//props.put("mail.smtp.port", "465"); 
		
        // authenticator
        //String fromEmail = "ronaldayoub@gmail.com";
        //String password = "cnfzwmbkvmdlgiid";

        // properties
        Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.office365.com"); 
		props.put("mail.smtp.auth", "true"); 
		props.put("mail.smtp.port", "587"); 
        props.put("mail.smtp.starttls.enable", "true");

        // authenticator
        String fromEmail = "r77755@kumc.edu";
        String password = "TrueMetal8975!";
       







		Authenticator authenticator = new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(fromEmail, password);
			}
		};
        
        // create session
		Session session = Session.getDefaultInstance(props, authenticator);

        // create message
        MimeMessage message = new MimeMessage(session);
        try {

            message.setFrom(new InternetAddress(fromEmail));
            for (String toEmail : toEmails) {
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            }
            message.setSubject("[secure] notification POC");

            BodyPart text = new MimeBodyPart();
            text.setText("making some progress - please reply to acknowledge receipt");
        
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(text);

            for (String accessionId : accessionIds) {

                InputStream inputStream = WS.getPdf(token, accessionId);
                if (inputStream != null) {

                    try {
                        
                        BodyPart attachment = new MimeBodyPart();
                        ByteArrayDataSource source = new ByteArrayDataSource(inputStream, "application/pdf");
                        
                        attachment.setDataHandler(new DataHandler(source));
                        attachment.setFileName(accessionId + ".pdf");
                
                        // add attachment
                        multipart.addBodyPart(attachment);
                    } 
                    catch (IOException e) {
                        // do nothing
                        e.printStackTrace();
                    }
                }

                notified.add(accessionId);
            }

            // set content and send
            message.setContent(multipart);
            Transport.send(message);
            
        } 
        catch (MessagingException e) {

            e.printStackTrace();
            notified.clear();
        }

        return notified;
    }

    public static List<String> getToNotify(int previousDays) {

        List<String> accessionIds = new ArrayList<>();

        LocalDate now = LocalDate.now();
        Date fromDate = Date.valueOf(now.minusDays(previousDays));

        PGSimpleDataSource ds = Ds.getDataSource();

        try {

            Connection conn = ds.getConnection();
                
            PreparedStatement stmt = conn.prepareStatement("SELECT accession FROM get_gc_to_notify(?);");
            stmt.setDate(1, fromDate);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                accessionIds.add(rs.getString("accession"));
            }
            
            rs.close();
            stmt.close();
            conn.close();
        }
        catch (SQLException e) {
            // do nothing
            e.printStackTrace();
        }

        return accessionIds;
    }

    public static void saveNotified(List<String> notified) {

        PGSimpleDataSource ds = Ds.getDataSource();

        try {

            Connection conn = ds.getConnection();

            PreparedStatement updt = conn.prepareStatement("SELECT insert_gc_notified(?);");
        
            String a[] = new String[notified.size()];
            notified.toArray(a);
            updt.setArray(1, conn.createArrayOf("VARCHAR", a));
            updt.execute();

            updt.close();
            conn.close();
        }
        catch (SQLException e) {
            // do nothing
            e.printStackTrace();
        }
    }

























}
