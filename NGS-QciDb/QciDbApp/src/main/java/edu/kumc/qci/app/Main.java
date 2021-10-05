package edu.kumc.qci.app;

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

import edu.kumc.qci.db.Getter;
import edu.kumc.qci.db.Importer;

public class Main {

    public static void main(String[] args) {

        Options options = new Options();
        
        OptionGroup group = new OptionGroup();

        group.addOption(Option.builder("b")
                .longOpt("build")
                .build());
        group.addOption(Option.builder("u")
                .longOpt("update")
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
            if (line.hasOption("b")) {
                option_b(line);
            } else if (line.hasOption("u")) {
                option_u(line);
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

    private static void option_b(CommandLine line) throws Exception {

        Getter.getXml();
        Importer.truncateQciTables();
        Importer.importXml(Config.DATA_PATH);
    }

    private static void option_u(CommandLine line) throws Exception {

        Getter.getXml();
        Importer.importXml(Config.DATA_PATH);
    }

    private static void option_d(CommandLine line) throws Exception {

    }

    private static void option_help(Options options) {

        HelpFormatter formatter = getHelpFormatter("Usage: ");
        formatter.printHelp(Config.APP_NAME, options);
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
