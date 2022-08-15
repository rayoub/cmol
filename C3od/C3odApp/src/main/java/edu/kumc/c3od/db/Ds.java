package edu.kumc.c3od.db;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.c3od.app.Constants;

public class Ds {

    public static PGSimpleDataSource getDataSource() {

        PGSimpleDataSource ds = new PGSimpleDataSource();
        ds.setDatabaseName(Constants.PG_DB_NAME);
        ds.setUser(Constants.PG_DB_USER);
        ds.setPassword(Constants.PG_DB_PASSWORD);

        return ds;
    }
}

