package edu.kumc.c3od.db;

import org.postgresql.ds.PGSimpleDataSource;

import com.microsoft.sqlserver.jdbc.SQLServerDataSource;

import edu.kumc.c3od.app.Constants;

public class Ds {

    public static PGSimpleDataSource getPGDataSource() {

        PGSimpleDataSource ds = new PGSimpleDataSource();
        ds.setUser(Constants.PG_DB_USER);
        ds.setPassword(Constants.PG_DB_PASSWORD);
        ds.setDatabaseName(Constants.PG_DB_NAME);

        return ds;
    }
    
    public static SQLServerDataSource getSSDataSource() {

        SQLServerDataSource ds = new SQLServerDataSource();
        ds.setUser(Constants.SS_DB_USER);
        ds.setPassword(Constants.SS_DB_PASSWORD);
        ds.setDatabaseName(Constants.SS_DB_NAME);
        ds.setServerName(Constants.SS_DB_SERVER);
        ds.setPortNumber(1433);
        ds.setTrustServerCertificate(true);

        return ds;
    }
}

