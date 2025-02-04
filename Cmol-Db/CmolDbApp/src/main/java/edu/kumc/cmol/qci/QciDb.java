package edu.kumc.cmol.qci;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.IntStream;

import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;
import edu.kumc.cmol.core.SampleInfo;

public class QciDb {

    public static List<QueryRow> getQueryRows(QueryCriteria criteria) throws SQLException {

        List<QueryRow> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_qci_query(?,?,?,?,?,?,?,?);");

        // diagnoses
        if (criteria.getDiagnoses() == null || criteria.getDiagnoses().length == 0) {
            stmt.setNull(1, Types.ARRAY);
        }
        else {
            stmt.setArray(1, conn.createArrayOf("INTEGER", IntStream.of(criteria.getDiagnoses()).boxed().toArray()));
        }

        // from date
        if (criteria.getFromDate() == null || criteria.getFromDate().isBlank()) {
            stmt.setNull(2, Types.DATE);
        }
        else {
            stmt.setDate(2, Date.valueOf(criteria.getFromDate()));
        }
        
        // to date
        if (criteria.getToDate() == null || criteria.getToDate().isBlank()) {
            stmt.setNull(3, Types.DATE);
        }
        else {
            stmt.setDate(3, Date.valueOf(criteria.getToDate()));
        }
        
        // mrns
        boolean mrnsIsNull = true;
        String mrns = criteria.getMrns();
        if (mrns != null) {
            mrns = mrns.replaceAll("\\s","");
            if (!mrns.isEmpty()) {
                String[] a = mrns.split(";");
                stmt.setArray(4, conn.createArrayOf("VARCHAR", a));
                mrnsIsNull = false;
            }
        }
        if (mrnsIsNull) {
            stmt.setNull(4, Types.ARRAY);
        }

        // genes
        boolean genesIsNull = true;
        String genes = criteria.getGenes();
        if (genes != null) {
            genes = genes.replaceAll("\\s","");
            if (!genes.isEmpty()) {
                String[] a = genes.split(";");
                stmt.setArray(5, conn.createArrayOf("VARCHAR", a));
                genesIsNull = false;
            }
        }
        if (genesIsNull) {
            stmt.setNull(5, Types.ARRAY);
        }
        
        // exon 
        if (criteria.getExon() == null || criteria.getExon().isBlank()) {
            stmt.setNull(6, Types.INTEGER);
        }
        else {
            stmt.setInt(6, Integer.parseInt(criteria.getExon()));
        }

        // tc change
        if (criteria.getTranscriptChange() == null || criteria.getTranscriptChange().isBlank()) {
            stmt.setNull(7, Types.VARCHAR);
        }
        else {
            stmt.setString(7, criteria.getTranscriptChange());
        }

        // pc change
        if (criteria.getProteinChange() == null || criteria.getProteinChange().isBlank()) {
            stmt.setNull(8, Types.VARCHAR);
        }
        else {
            stmt.setString(8, criteria.getProteinChange());
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            QueryRow row = new QueryRow();

            row.setSampleId(rs.getString("sample_id"));
            row.setSpecimenId(rs.getString("specimen_id"));
            if (rs.wasNull()) row.setSpecimenId("");
            row.setMrn(rs.getString("mrn"));
            if (rs.wasNull()) row.setMrn("");
            row.setAccession(rs.getString("accession"));
            if (rs.wasNull()) row.setAccession("");
            row.setTestDate(rs.getString("test_date"));
            if (rs.wasNull()) row.setTestDate("");
            row.setTestCode(rs.getString("test_code"));
            if (rs.wasNull()) row.setTestCode("");
            row.setDiagnosis(rs.getString("diagnosis"));
            if (rs.wasNull()) row.setDiagnosis("");
            row.setInterpretation(rs.getString("interpretation"));
            if (rs.wasNull()) row.setInterpretation("");
            row.setPhysician(rs.getString("physician"));
            if (rs.wasNull()) row.setPhysician("");
            row.setLocus(rs.getString("locus"));
            if (rs.wasNull()) row.setLocus("");
            row.setGene(rs.getString("gene"));
            if (rs.wasNull()) row.setGene("");
            row.setAlleleFraction(rs.getDouble("allele_fraction"));
            if (rs.wasNull()) row.setAlleleFraction(-1.0);
            row.setTranscript(rs.getString("transcript"));
            if (rs.wasNull()) row.setTranscript("");
            row.setTranscriptChange(rs.getString("transcript_change"));
            if (rs.wasNull()) row.setTranscriptChange("");
            row.setTranscriptExon(rs.getInt("transcript_exon"));
            if (rs.wasNull()) row.setTranscriptExon(-1);
            row.setProtein(rs.getString("protein"));
            if (rs.wasNull()) row.setProtein("");
            row.setProteinChange(rs.getString("protein_change"));
            if (rs.wasNull()) row.setProteinChange("");
            row.setAssessment(rs.getString("assessment"));
            if (rs.wasNull()) row.setAssessment("");

            rows.add(row);
        }

        rs.close();
        stmt.close();
        conn.close();

        return rows;
    }
    
    public static List<QciSample> getSamples() throws SQLException {

        List<QciSample> samples = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM qci_sample;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            QciSample sample = new QciSample();

            sample.setSampleId(rs.getString("sample_id"));
            if (rs.wasNull()) sample.setSampleId("");
            sample.setMrn(rs.getString("mrn"));
            if (rs.wasNull()) sample.setMrn("");
            sample.setTestDate(rs.getString("test_date"));
            if (rs.wasNull()) sample.setTestDate("");
            sample.setTestCode(rs.getString("test_code"));
            if (rs.wasNull()) sample.setTestCode("");
            sample.setClinicalFinding(rs.getString("clinical_finding"));
            if (rs.wasNull()) sample.setClinicalFinding("");
            sample.setDiagnosis(rs.getString("diagnosis"));
            if (rs.wasNull()) sample.setDiagnosis("");
            sample.setInterpretation(rs.getString("interpretation"));
            if (rs.wasNull()) sample.setInterpretation("");
            
            sample.setSex(rs.getString("sex"));
            if (rs.wasNull()) sample.setSex("");
            sample.setDateOfBirth(rs.getString("date_of_birth"));
            if (rs.wasNull()) sample.setDateOfBirth("");

            sample.setHospitalName(rs.getString("hospital_name"));
            if (rs.wasNull()) sample.setHospitalName("");
            sample.setPhysicianName(rs.getString("physician_name"));
            if (rs.wasNull()) sample.setPhysicianName("");
            
            sample.setPrimaryTumorSite(rs.getString("primary_tumor_site"));
            if (rs.wasNull()) sample.setPrimaryTumorSite("");
            sample.setSpecimenId(rs.getString("specimen_id"));
            if (rs.wasNull()) sample.setSpecimenId("");
            sample.setSpecimenType(rs.getString("specimen_type"));
            if (rs.wasNull()) sample.setSpecimenType("");
            sample.setSpecimenCollectionDate(rs.getString("specimen_collection_date"));
            if (rs.wasNull()) sample.setSpecimenCollectionDate("");

            sample.setLabTestedCNVGain("");
            sample.setLabTestedGenes("");

            samples.add(sample);
        }

        rs.close();
        stmt.close();
        conn.close();

        return samples;
    }
    
    public static List<QciVariant> getVariants() throws SQLException {

        List<QciVariant> variants = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM qci_variant;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            QciVariant variant = new QciVariant();

            variant.setSampleId(rs.getString("sample_id"));
            variant.setChromosome(rs.getString("chromosome"));
            if (rs.wasNull()) variant.setChromosome("");
            variant.setPosition(rs.getInt("position"));
            if (rs.wasNull()) variant.setPosition(QciVariant.INT_NULL);
            variant.setReference(rs.getString("reference"));
            if (rs.wasNull()) variant.setReference("");
            variant.setAlternate(rs.getString("alternate"));
            if (rs.wasNull()) variant.setAlternate("");;
            variant.setGenotype(rs.getString("genotype"));
            if (rs.wasNull()) variant.setGenotype("");
            variant.setAssessment(rs.getString("assessment"));
            if (rs.wasNull()) variant.setAssessment("");
            variant.setActionability(rs.getString("actionability"));
            if (rs.wasNull()) variant.setActionability("");
            variant.setPhenotypeId(rs.getString("phenotype_id"));
            if (rs.wasNull()) variant.setPhenotypeId("");
            variant.setPhenotypeName(rs.getString("phenotype_name"));
            if (rs.wasNull()) variant.setPhenotypeName("");
            variant.setDbsnp(rs.getString("dbsnp"));
            if (rs.wasNull()) variant.setDbsnp("");
            variant.setCadd(rs.getDouble("cadd"));
            if (rs.wasNull()) variant.setCadd(QciVariant.DOUBLE_NULL);
            variant.setAlleleFraction(rs.getDouble("allele_fraction"));
            if (rs.wasNull()) variant.setAlleleFraction(QciVariant.DOUBLE_NULL);
            variant.setReadDepth(rs.getInt("read_depth"));
            if (rs.wasNull()) variant.setReadDepth(QciVariant.INT_NULL);
            variant.setVariation(rs.getString("variation"));
            if (rs.wasNull()) variant.setVariation("");
            variant.setGene(rs.getString("gene"));
            if (rs.wasNull()) variant.setGene("");
            variant.setTcTranscript(rs.getString("tc_transcript"));
            if (rs.wasNull()) variant.setTcTranscript("");
            variant.setTcChange(rs.getString("tc_change"));
            if (rs.wasNull()) variant.setTcChange("");
            variant.setTcExonNumber(rs.getInt("tc_exon_number"));
            if (rs.wasNull()) variant.setTcExonNumber(QciVariant.INT_NULL);
            variant.setTcRegion(rs.getString("tc_region"));
            if (rs.wasNull()) variant.setTcRegion("");
            variant.setPcProtein(rs.getString("pc_protein"));
            if (rs.wasNull()) variant.setPcProtein("");
            variant.setPcChange(rs.getString("pc_change"));
            if (rs.wasNull()) variant.setPcChange("");
            variant.setPcTranslationImpact(rs.getString("pc_translation_impact"));
            if (rs.wasNull()) variant.setPcTranslationImpact("");
            variant.setGcChange(rs.getString("gc_change"));
            if (rs.wasNull()) variant.setGcChange("");
            variant.setFunction(rs.getString("function"));
            if (rs.wasNull()) variant.setFunction("");
            variant.setReferenceCount(rs.getInt("reference_count"));
            if (rs.wasNull()) variant.setReferenceCount(QciVariant.INT_NULL);

            variants.add(variant);
        }

        rs.close();
        stmt.close();
        conn.close();

        return variants;
    }
    
    public static SampleInfo getSampleInfo() throws SQLException {

        SampleInfo info = new SampleInfo();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
        PreparedStatement stmt = conn.prepareCall("SELECT COUNT(DISTINCT sample_id) AS sn, MAX(test_date)::VARCHAR AS ls FROM get_qci_query();");
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            info.setCount(rs.getInt("sn"));
            info.setLatest(rs.getString("ls"));
        }

        rs.close();
        stmt.close();
        conn.close();

        return info;
    }

    public static String getLatestTestDate() throws SQLException {

        Date latestTestDate = null;

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT MAX(test_date) AS test_date FROM qci_sample;");

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

    public static Set<String> getSampleIds() throws SQLException {

        Set<String> sampleIds = new HashSet<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT sample_id FROM qci_sample;");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            sampleIds.add(rs.getString("sample_id"));
        }

        rs.close();
        stmt.close();
        conn.close();

        return sampleIds;
    }
    
    public static void saveSamples(List<QciSample> samples) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("qci_sample", QciSample.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_qci_sample(?);");
     
        QciSample a[] = new QciSample[samples.size()];
        samples.toArray(a);
        updt.setArray(1, conn.createArrayOf("qci_sample", a));
    
        updt.execute();
        updt.close();

        conn.close();
    }

    public static void saveVariants(List<QciVariant> variants) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("qci_variant", QciVariant.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_qci_variant(?);");
     
        QciVariant a[] = new QciVariant[variants.size()];
        variants.toArray(a);
        updt.setArray(1, conn.createArrayOf("qci_variant", a));
    
        updt.execute();
        updt.close();
        
        conn.close();
    }
}
