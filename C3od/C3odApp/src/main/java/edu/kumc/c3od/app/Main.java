package edu.kumc.c3od.app;

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

import edu.kumc.c3od.db.Db;
import edu.kumc.qci.db.Reporter;

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
        
        Db.truncateTable("qci_report");
        Db.truncateTable("qci_variant");

        Db.setReports(Reporter.getReports());
        Db.setVariants(Reporter.getVariants());
    }

    private static void option_d(CommandLine line) throws Exception {

        System.out.println("Not Implemented!");
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
