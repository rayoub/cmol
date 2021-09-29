package edu.kumc.qci.db;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.qci.app.Constants;

public class Ds {

    public static PGSimpleDataSource getDataSource() {

        PGSimpleDataSource ds = new PGSimpleDataSource();
        ds.setDatabaseName(Constants.DB_NAME);
        ds.setUser(Constants.DB_USER);
        ds.setPassword(Constants.DB_PASSWORD);

        return ds;
    }
}

