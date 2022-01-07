package edu.kumc.qci.app;

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

import edu.kumc.qci.db.QueryCriteria;
import edu.kumc.qci.db.Getter;
import edu.kumc.qci.db.Importer;
import edu.kumc.qci.db.QueryRow;
import edu.kumc.qci.db.Reporter;

public class Main {

    public static void main(String[] args) {

        Options options = new Options();
        
        OptionGroup group = new OptionGroup();

        group.addOption(Option.builder("g")
                .longOpt("get")
                .desc("get xml files")
                .build());
        group.addOption(Option.builder("i")
                .longOpt("import")
                .desc("import xml files")
                .build());
        group.addOption(Option.builder("c")
                .longOpt("clear")
                .desc("clear database tables")
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
            if (line.hasOption("g")) {
                option_g(line);
            } else if (line.hasOption("i")) {
                option_i(line);
            } else if (line.hasOption("c")) {
                option_c(line);
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

    private static void option_g(CommandLine line) throws Exception {

        Getter.getXml();
    }

    private static void option_i(CommandLine line) throws Exception {

        Importer.importXml(Constants.DATA_PATH);
    }
    
    private static void option_c(CommandLine line) throws Exception {

        Importer.truncateQciTables();
    }

    private static void option_d(CommandLine line) throws Exception {

            QueryCriteria criteria = new QueryCriteria();
            criteria.setTranscriptChange("");
            criteria.setProteinChange("G12C");

            List<QueryRow> rows = Reporter.getQueryRows(criteria);
            for (QueryRow row : rows) {
                System.out.println(row.toString());
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
