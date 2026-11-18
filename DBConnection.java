
package com.citycare.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static final String JDBC_URL =
            System.getenv("JDBC_URL");

    private static final String JDBC_USER =
            System.getenv("DB_USER");

    private static final String JDBC_PASSWORD =
            System.getenv("DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                    "MySQL JDBC Driver not found!", e);
        }
    }

    public static Connection getConnection() throws SQLException {

        if (JDBC_URL == null || JDBC_URL.isBlank()
                || JDBC_USER == null || JDBC_USER.isBlank()
                || JDBC_PASSWORD == null || JDBC_PASSWORD.isBlank()) {

            throw new SQLException(
                    "Missing database environment variables.");
        }

        String configuredUser = JDBC_USER.trim();
        if (JDBC_URL.contains("gateway01") && !configuredUser.contains(".")) {
            throw new SQLException(
                    "TiDB Cloud usernames must include the instance prefix (for example, <prefix>.root).");
        }

        return DriverManager.getConnection(
                JDBC_URL,
                configuredUser,
                JDBC_PASSWORD
        );
    }

    /** Logs database diagnostics without logging SQL values, credentials, or exception messages. */
    public static void logDatabaseError(String operation, SQLException exception) {
        SQLException current = exception;
        while (current != null) {
            LOGGER.log(Level.SEVERE,
                    "Database operation failed: {0}; exception={1}; SQLState={2}; vendorCode={3}",
                    new Object[] {
                            operation,
                            current.getClass().getSimpleName(),
                            current.getSQLState(),
                            current.getErrorCode()
                    });
            current = current.getNextException();
        }
    }
}
