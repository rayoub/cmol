package edu.kumc.cmol.ion;

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

import org.postgresql.PGConnection;
import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.cmol.core.Ds;

public class IonDb {
    
    public static List<QueryRow> getQueryRows(QueryCriteria criteria) throws SQLException { 

        List<QueryRow> rows = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT * FROM get_ion_query(?,?,?,?,?,?,?,?);");

        // download type
        stmt.setString(1, criteria.getDownloadType());

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

        // cmol id
        if (criteria.getCmolId() == null || criteria.getCmolId().isBlank()) {
            stmt.setNull(4, Types.VARCHAR);
        }
        else {
            stmt.setString(4, criteria.getCmolId());
        }
        
        // mrns
        boolean mrnsIsNull = true;
        String mrns = criteria.getMrns();
        if (mrns != null) {
            mrns = mrns.replaceAll("\\s","");
            if (!mrns.isEmpty()) {
                String[] a = mrns.split(";");
                stmt.setArray(5, conn.createArrayOf("VARCHAR", a));
                mrnsIsNull = false;
            }
        }
        if (mrnsIsNull) {
            stmt.setNull(5, Types.ARRAY);
        }
        
        // genes
        boolean genesIsNull = true;
        String genes = criteria.getGenes();
        if (genes != null) {
            genes = genes.replaceAll("\\s","");
            if (!genes.isEmpty()) {
                String[] a = genes.split(";");
                stmt.setArray(6, conn.createArrayOf("VARCHAR", a));
                genesIsNull = false;
            }
        }
        if (genesIsNull) {
            stmt.setNull(6, Types.ARRAY);
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

            row.setAnalysisDate(rs.getString("analysis_date"));
            row.setAssayFolder(rs.getString("assay_folder"));
            row.setCmolId(rs.getString("cmol_id"));
            row.setMrn(rs.getString("mrn"));
            row.setAccessionId(rs.getString("accession_id"));
            row.setLocus(rs.getString("locus"));
            row.setType(rs.getString("type"));
            row.setSubtype(rs.getString("subtype"));
            if (rs.wasNull()) row.setSubtype("");
            row.setGenotype(rs.getString("genotype"));
            if (rs.wasNull()) row.setGenotype("");
            row.setFilter(rs.getString("filter"));
            if (rs.wasNull()) row.setFilter("");
            row.setRef(rs.getString("ref"));
            if (rs.wasNull()) row.setRef("");
            row.setNormalizedAlt(rs.getString("normalized_alt"));
            if (rs.wasNull()) row.setNormalizedAlt("");
            row.setCoverage(rs.getString("coverage"));
            if (rs.wasNull()) row.setCoverage("");
            row.setAlleleCoverage(rs.getString("allele_coverage"));
            if (rs.wasNull()) row.setAlleleCoverage("");
            row.setAlleleRatio(rs.getString("allele_ratio"));
            if (rs.wasNull()) row.setAlleleRatio("");
            row.setAlleleFrequency(rs.getString("allele_frequency"));
            if (rs.wasNull()) row.setAlleleFrequency("");
            row.setGenes(rs.getString("genes"));
            if (rs.wasNull()) row.setGenes("");
            row.setTranscript(rs.getString("transcript"));
            if (rs.wasNull()) row.setTranscript("");
            row.setLocation(rs.getString("location"));
            if (rs.wasNull()) row.setLocation("");
            row.setFunction(rs.getString("function"));
            if (rs.wasNull()) row.setFunction("");
            row.setExon(rs.getString("exon"));
            if (rs.wasNull()) row.setExon("");
            row.setCoding(rs.getString("coding"));
            if (rs.wasNull()) row.setCoding("");
            row.setProtein(rs.getString("protein"));
            if (rs.wasNull()) row.setProtein("");
            row.setCopyNumber(rs.getString("copy_number"));
            if (rs.wasNull()) row.setCopyNumber("");
            row.setCopyNumberType(rs.getString("copy_number_type"));
            if (rs.wasNull()) row.setCopyNumberType("");
            row.setFoldDiff(rs.getString("fold_diff"));
            if (rs.wasNull()) row.setFoldDiff("");

            rows.add(row);
        }

        rs.close();
        stmt.close();
        conn.close();

        return rows;
    }

    public static Set<String> getZipNames(DownloadType downloadType) throws SQLException {

        Set<String> zipNames = new HashSet<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT zip_name FROM ion_sample WHERE download_type = '" + downloadType.getPattern() + "';");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            zipNames.add(rs.getString("zip_name"));
        }

        rs.close();
        stmt.close();
        conn.close();

        return zipNames;
    }
    
    public static List<IonCnvStat> getCnvStats(CnvType cnvType) throws SQLException {

        List<IonCnvStat> stats = new ArrayList<>();

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT gene, sn, gn, gn_pct, min_cn, max_cn, avg_cn FROM get_ion_cnv_stats(" + cnvType.getId() + ");");

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {

            IonCnvStat stat = new IonCnvStat();

            stat.setGene(rs.getString("gene"));
            stat.setSn(rs.getInt("sn"));
            stat.setGn(rs.getInt("gn"));
            stat.setGnPct(rs.getDouble("gn_pct"));
            stat.setMinCn(rs.getDouble("min_cn"));
            stat.setMaxCn(rs.getDouble("max_cn"));
            stat.setAvgCn(rs.getDouble("avg_cn"));

            stats.add(stat);
        }

        rs.close();
        stmt.close();
        conn.close();

        return stats;
    }
    
    public static int getSampleCount(DownloadType downloadType) throws SQLException {

        int sampleCount = -1;

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();
            
        PreparedStatement stmt = conn.prepareCall("SELECT COUNT(DISTINCT zip_name) AS sn FROM ion_sample WHERE download_type = '" + downloadType.getPattern() + "';"); 

        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            sampleCount = rs.getInt("sn");
        }

        rs.close();
        stmt.close();
        conn.close();

        return sampleCount;
    }

    public static void saveSamples(List<IonSample> samples) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("ion_sample", IonSample.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_ion_sample(?);");

        IonSample a[] = new IonSample[samples.size()];
        samples.toArray(a);
        updt.setArray(1, conn.createArrayOf("ion_sample", a));

        updt.execute();
        updt.close();

        conn.close();
    }

    public static void saveVariants(List<IonVariant> variants) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("ion_variant", IonVariant.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_ion_variant(?);");

        IonVariant a[] = new IonVariant[variants.size()];
        variants.toArray(a);
        updt.setArray(1, conn.createArrayOf("ion_variant", a));

        updt.execute();
        updt.close();

        conn.close();
    }
    
    public static void saveMrns(List<IonMrn> mrns) throws SQLException {

        PGSimpleDataSource ds = Ds.getDataSource();

        Connection conn = ds.getConnection();

        ((PGConnection) conn).addDataType("ion_mrn", IonMrn.class);

        PreparedStatement updt = conn.prepareStatement("SELECT insert_ion_mrn(?);");

        IonMrn a[] = new IonMrn[mrns.size()];
        mrns.toArray(a);
        updt.setArray(1, conn.createArrayOf("ion_mrn", a));

        updt.execute();
        updt.close();

        conn.close();
    }
}
