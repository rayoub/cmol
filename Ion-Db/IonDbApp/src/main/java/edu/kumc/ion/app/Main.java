package edu.kumc.ion.app;

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

import edu.kumc.ion.db.QueryCriteria;
import edu.kumc.ion.db.Reporter;
import edu.kumc.ion.db.Variant;

public class Main {

    public static void main(String[] args) {

        Options options = new Options();

        OptionGroup group = new OptionGroup();

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
            if (line.hasOption("d")) {
                option_d(line);
            } else if (line.hasOption("?")) {
                option_help(options);
            }
        } catch (Exception e) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    private static void option_d(CommandLine line) throws Exception {

        String sample = "CP019-DNA3-W52288_v1_CP019-RNA3-W52288_RNA_v1";
//        String sample = "CP013-DNA4-H15895_v1_CP013-RNA4-H15895_RNA_v1";

        QueryCriteria criteria = new QueryCriteria();
        criteria.setSample(sample);

        List<Variant> variants = Reporter.getVariants(criteria);
        for (Variant variant : variants) {
            System.out.println(variant);
        }

    }

    private static void option_help(Options options) {

        HelpFormatter formatter = getHelpFormatter("Usage: ");
        formatter.printHelp(Constants.APP_NAME, options);
    }

    private static HelpFormatter getHelpFormatter(String headerPrefix) {

        HelpFormatter formatter = new HelpFormatter();
        formatter.setOptionComparator(new OptionComparator());
        formatter.setSyntaxPrefix(headerPrefix);
        formatter.setWidth(140);
        formatter.setLeftPadding(5);
        return formatter;
    }
}
