package Servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username == null || password == null || role == null ||
            username.isEmpty() || password.isEmpty() || role.isEmpty()) {
            response.sendRedirect("signup.jsp?error=All fields are required.");
            return;
        }

        if (!role.equals("user") && !role.equals("admin") && !role.equals("super_admin")) {
            response.sendRedirect("signup.jsp?error=Invalid role selection.");
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            String checkUserQuery = "SELECT user_name FROM account WHERE user_name = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkUserQuery)) {
                checkStmt.setString(1, username);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    response.sendRedirect("signup.jsp?error=Username already exists.");
                    return;
                }
            }

            String insertQuery = "INSERT INTO account (user_name, password, user_role) VALUES (?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setString(1, username);
                insertStmt.setString(2, password);
                insertStmt.setString(3, role);

                int rowsInserted = insertStmt.executeUpdate();
                if (rowsInserted > 0) {
                    response.sendRedirect("login.jsp?success=Account created successfully! You can now log in.");
                } else {
                    response.sendRedirect("signup.jsp?error=Failed to create account. Try again.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=Database error: " + e.getMessage());
        }
    }
}
