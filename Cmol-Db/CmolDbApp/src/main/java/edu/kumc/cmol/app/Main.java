package edu.kumc.cmol.app;

import java.util.List;
import java.util.Set;
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

import edu.kumc.cmol.core.Constants;
import edu.kumc.cmol.ion.DownloadType;
import edu.kumc.cmol.ion.IonDb;
import edu.kumc.cmol.ion.IonImport;
import edu.kumc.cmol.ion.IonMrn;
import edu.kumc.cmol.ion.IonSample;
import edu.kumc.cmol.ion.IonVariant;
import edu.kumc.cmol.qci.QciDb;
import edu.kumc.cmol.qci.QciImport;
import edu.kumc.cmol.qci.WS;

public class Main {

    public static void main(String[] args) throws org.apache.commons.cli.ParseException {

        Options options = new Options();

        OptionGroup group = new OptionGroup();
        
        group.addOption(Option.builder("q")
            .desc("get QCI XML files")
            .build());
        group.addOption(Option.builder("r")
            .desc("import QCI XML files")
            .build());
        group.addOption(Option.builder("s")
            .desc("clean QCI tables")
            .build());

        group.addOption(Option.builder("i")
            .desc("import Ion selected variants")
            .build());
        
        group.addOption(Option.builder("j")
            .desc("import Ion filtered variants")
            .build());
        
        group.addOption(Option.builder("k")
            .desc("import Ion MRNs")
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
            if (line.hasOption("q")) {
                option_q(line);
            } else if (line.hasOption("r")) {
                option_r(line);
            } else if (line.hasOption("s")) {
                option_s(line);
            } else if (line.hasOption("i")) {
                option_i(line);
            } else if (line.hasOption("j")) {
                option_j(line);
            } else if (line.hasOption("k")) {
                option_k(line);
            } else if (line.hasOption("d")) {
                option_d(line);
            } else if (line.hasOption("?")) {
                option_help(options);
            }
        } catch (Exception e) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    private static void option_q(CommandLine line) throws Exception {

        String token = WS.getToken();
        String latestTestDate = QciDb.getLatestTestDate();
        WS.getXml(token, latestTestDate);
    }

    private static void option_r(CommandLine line) throws Exception {

        QciImport.importXml(Constants.QCI_DATA_PATH);
    }
    
    private static void option_s(CommandLine line) throws Exception {

        QciImport.cleanQciTables();
    }

    private static void option_i(CommandLine line) throws Exception {

        List<IonSample> samples = IonImport.getSamples(DownloadType.SelectedVariants);

        // remove samples we have already seen
        Set<String> zipNames = IonDb.getZipNames(DownloadType.SelectedVariants);
        for (int i = samples.size() - 1; i >= 0; i--) {
            if (zipNames.contains(samples.get(i).getZipName())) {
                samples.remove(i);
            }
        }

        // save new samples
        IonDb.saveSamples(samples);
        for(IonSample sample : samples) {
            
            System.out.println("saving " + sample.getZipName());
            List<IonVariant> variants = IonImport.getVariants(sample);
            IonDb.saveVariants(variants);            
        }
    }
    
    private static void option_j(CommandLine line) throws Exception {

        List<IonSample> samples = IonImport.getSamples(DownloadType.Filtered);

        // remove samples we have already seen
        Set<String> zipNames = IonDb.getZipNames(DownloadType.Filtered);
        for (int i = samples.size() - 1; i >= 0; i--) {
            if (zipNames.contains(samples.get(i).getZipName())) {
                samples.remove(i);
            }
        }

        // save new samples
        IonDb.saveSamples(samples);
        for(IonSample sample : samples) {
            
            System.out.println("saving " + sample.getZipName());
            List<IonVariant> variants = IonImport.getVariants(sample);
            IonDb.saveVariants(variants);            
        }
    }
    
    private static void option_k(CommandLine line) throws Exception {

        List<IonMrn> mrns = IonImport.getMrns();
        IonDb.saveMrns(mrns);
    }
    
    private static void option_d(CommandLine line) throws Exception { 

    }

    public static String splitter(String text, int lineLength) {

        lineLength = Math.min(text.length(), lineLength);
        char[] textChars = text.toCharArray();
        int numberOfLines = (int) Math.ceil(text.length() / (double) lineLength);
        String[] lines = new String[numberOfLines];
        for (int i = 0; i < textChars.length; i++) {
            int index = i / lineLength;
            lines[index] = (lines[index] == null ? "" : lines[index]) + textChars[i];
        }
        return String.join("..." + System.lineSeparator(), lines);
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
