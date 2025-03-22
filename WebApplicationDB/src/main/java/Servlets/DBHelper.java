package Servlets;
import java.util.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.*;

public class DBHelper {

    private static final String DATABASE_NAME = "WebAppDB";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";
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
    
    public boolean updateUser(String oldUsername, String newUsername, String newPassword, String newRole) throws SQLException {
        if (oldUsername == null || oldUsername.trim().isEmpty()) {
            return false;
        }

        try (Connection conn = DBHelper.getConnection()) {
            String checkUserSql = "SELECT * FROM account WHERE user_name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkUserSql)) {
                stmt.setString(1, oldUsername);
                ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        String updateSql = "UPDATE account SET user_name = ?, password = ?, user_role = ? WHERE user_name = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setString(1, newUsername); 
                            updateStmt.setString(2, newPassword); 
                            updateStmt.setString(3, newRole);     
                            updateStmt.setString(4, oldUsername); 

                            int rowsUpdated = updateStmt.executeUpdate();
                            return rowsUpdated > 0;
                        }
                    } else {
                        return false;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        return true;
    }
    
    public Boolean deleteUser(String username) throws SQLException {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        try (Connection conn = DBHelper.getConnection()) {
            String sql = "DELETE FROM account WHERE user_name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username); 
                int rowsDeleted = stmt.executeUpdate(); 
                return rowsDeleted > 0; 
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
}
}
