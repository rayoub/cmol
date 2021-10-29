package edu.kumc.qci.db;

import org.postgresql.ds.PGSimpleDataSource;

import edu.kumc.qci.app.Config;

public class Ds {

    public static PGSimpleDataSource getDataSource() {

        PGSimpleDataSource ds = new PGSimpleDataSource();
        ds.setDatabaseName(Config.DB_NAME);
        ds.setUser(Config.DB_USER);
        ds.setPassword(Config.DB_PASSWORD);

        return ds;
    }
}

