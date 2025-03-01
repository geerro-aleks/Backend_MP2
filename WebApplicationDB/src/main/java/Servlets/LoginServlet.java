/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

/**
 *
 * @author DELL
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            response.sendRedirect("login.jsp?error=Username and password are required.");
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            // First, check if the username exists
            String checkUserQuery = "SELECT password, user_role FROM account WHERE user_name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkUserQuery)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String userRole = rs.getString("user_role");

                    // Compare passwords
                    if (storedPassword.equals(password)) {
                        // Valid login, create session
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("userRole", userRole);

                        // Redirect based on role
                        if ("admin".equals(userRole) || "super_admin".equals(userRole)) {
                            response.sendRedirect("admin.jsp");
                        } else {
                            response.sendRedirect("landing.jsp");
                        }
                    } else {
                        // Password is incorrect
                        response.sendRedirect("login.jsp?error=Incorrect password.");
                    }
                } else {
                    // Username does not exist
                    response.sendRedirect("login.jsp?error=Username does not exist.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=An unexpected error occurred. Please try again.");
        }
    }
}
