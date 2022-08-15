package edu.kumc.c3od.app;

import java.sql.JDBCType;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionGroup;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import com.microsoft.sqlserver.jdbc.SQLServerConnection;
import com.microsoft.sqlserver.jdbc.SQLServerDataSource;
import com.microsoft.sqlserver.jdbc.SQLServerException;
import com.microsoft.sqlserver.jdbc.SQLServerPreparedStatement;

import edu.kumc.c3od.db.Ds;
import edu.kumc.qci.db.Report;
import edu.kumc.qci.db.Reporter;
import edu.kumc.qci.db.Variant;

public class Main {

    public static void main(String[] args) {

        Options options = new Options();
        
        OptionGroup group = new OptionGroup();

        group.addOption(Option.builder("p")
                .longOpt("push")
                .desc("push QCI data to C3OD")
                .build());
        group.addOption(Option.builder("d")
                .longOpt("debug")
                .build());
        group.addOption(Option.builder("?")
                .longOpt("help")
                .build());

        group.setRequired(true);
        options.addOptionGroup(group);

        CommandLine line;

        try {
            CommandLineParser parser = new DefaultParser();
            line = parser.parse(options, args);
        } catch (ParseException e) {
            System.err.println(e.getMessage());
            option_help(options);
            return;
        }

        try {
            if (line.hasOption("p")) {
                option_p(line);
            } else if (line.hasOption("d")) {
                option_d(line);
            } else if (line.hasOption("?")) {
                option_help(options);
            }
        }
        catch (Exception e) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    private static void option_p(CommandLine line) throws Exception {
    }

    private static void option_d(CommandLine line) throws Exception {

        List<Report> reports = Reporter.getReports();
        List<Variant> variants = Reporter.getVariants();
        
        setReports(reports);
        setVariants(variants);
    }
    
    private static void setReports(List<Report> reports) { 

        try {

            SQLServerDataSource ds = Ds.getSSDataSource();
            SQLServerConnection connection = (SQLServerConnection) ds.getConnection();
            
            String sql = "INSERT INTO qci_report VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) OPTION (QUERYTRACEON 460)";
            SQLServerPreparedStatement updt = (SQLServerPreparedStatement) connection.prepareStatement(sql);
                
            for (Report report : reports) {

                updt.setString(1, report.getReportId());
                updt.setString(2, report.getSubjectId());
                updt.setString(3, report.getAccession());
                updt.setString(4, report.getTestDate());
                updt.setString(5, report.getTestCode());
                updt.setString(6, report.getClinicalFinding());
                updt.setString(7, report.getDiagnosis());
                updt.setString(8, report.getInterpretation());
                updt.setString(9, report.getSex());
                updt.setString(10, report.getDateOfBirth());
                updt.setString(11, report.getOrderingPhysicianClient());
                updt.setString(12, report.getOrderingPhysicianFacilityName());
                updt.setString(13, report.getOrderingPhysicianName());
                updt.setString(14, report.getPathologistName());
                updt.setString(15, report.getPrimaryTumorSite());
                updt.setString(16, report.getSpecimenId());
                updt.setString(17, report.getSpecimenType());
                updt.setString(18, report.getSpecimenCollectionDate());
                updt.setString(19, report.getLabTestedCNVGain());
                updt.setString(20, report.getLabTestedGenes());

                updt.execute();
            }

            updt.close();
            connection.close();
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private static void setVariants(List<Variant> variants) throws SQLServerException { 

        try {

            SQLServerDataSource ds = Ds.getSSDataSource();
            SQLServerConnection connection = (SQLServerConnection) ds.getConnection();
            
            String sql = "INSERT INTO qci_variant VALUES (" +
                "?,?,?,?,?,?,?,?," +
                "?,?,?,?,?,?,?,?," +
                "?,?,?,?,?,?,?,?," +
                "?,?)";
            SQLServerPreparedStatement updt = (SQLServerPreparedStatement) connection.prepareStatement(sql);
                
            for (Variant variant : variants) {

                updt.setString(1, variant.getReportId());
                updt.setString(2, variant.getChromosome());
                if (variant.getPosition() == Variant.INT_NULL) {
                    updt.setNull(3, JDBCType.INTEGER.ordinal());
                }
                else {
                    updt.setInt(3, variant.getPosition());
                }
                updt.setString(4, variant.getReference());
                updt.setString(5, variant.getAlternate());
                updt.setString(6, variant.getGenotype());
                updt.setString(7, variant.getAssessment());
                updt.setString(8, variant.getActionability());
                updt.setString(9, variant.getPhenotypeId());
                updt.setString(10, variant.getPhenotypeName());
                updt.setString(11, variant.getDbsnp());
                if (variant.getCadd() == Variant.DOUBLE_NULL) {
                    updt.setNull(12, JDBCType.DOUBLE.ordinal());
                }
                else {
                    updt.setDouble(12, variant.getCadd());
                }
                if (variant.getAlleleFraction() == Variant.DOUBLE_NULL) {
                    updt.setNull(13, JDBCType.DOUBLE.ordinal());
                }
                else {
                    updt.setDouble(13, variant.getAlleleFraction());
                }
                if (variant.getReadDepth() == Variant.INT_NULL) {
                    updt.setNull(14, JDBCType.INTEGER.ordinal());
                }
                else {
                    updt.setInt(14, variant.getReadDepth());
                }
                updt.setString(15, variant.getVariation());
                updt.setString(16, variant.getGene());
                updt.setString(17, variant.getTcTranscript());
                updt.setString(18, variant.getTcChange());
                if (variant.getTcExonNumber() == Variant.INT_NULL) {
                    updt.setNull(19, JDBCType.INTEGER.ordinal());
                }
                else {
                    updt.setInt(19, variant.getTcExonNumber());
                }
                updt.setString(20, variant.getTcRegion());
                updt.setString(21, variant.getPcProtein());
                updt.setString(22, variant.getPcChange());
                updt.setString(23, variant.getPcTranslationImpact());
                updt.setString(24, variant.getGcChange());
                updt.setString(25, variant.getFunction());
                if (variant.getReferenceCount() == Variant.INT_NULL) {
                    updt.setNull(26, JDBCType.INTEGER.ordinal());
                }
                else {
                    updt.setInt(26, variant.getReferenceCount());
                }

                updt.execute();
            }

            updt.close();
            connection.close();
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private static void option_help(Options options) {

        HelpFormatter formatter = getHelpFormatter("Usage: ");
        formatter.printHelp(Constants.APP_NAME, options);
    }

    private static HelpFormatter getHelpFormatter(String headerPrefix){

        HelpFormatter formatter = new HelpFormatter();
        formatter.setOptionComparator(new OptionComparator());
        formatter.setSyntaxPrefix(headerPrefix);
        formatter.setWidth(140);
        formatter.setLeftPadding(5);
        return formatter;
    }
}
