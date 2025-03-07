package Servlets;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DATABASE_NAME = "WebAppDB";
    private static final String USER = "root";
    private static final String PASSWORD = "Jcarigma0810";
    private static final String PORT = "3310";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found!", e);
        }
        String jdbcUrl = "jdbc:mysql://localhost:" + PORT + "/" + DATABASE_NAME
                + "?user=" + USER + "&password=" + PASSWORD
                + "&allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        return DriverManager.getConnection(jdbcUrl);
    }
}
