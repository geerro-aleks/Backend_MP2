package Servlets;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole) && !"super_admin".equals(userRole)) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        List<String[]> users = new ArrayList<>();
        List<String[]> messages = new ArrayList<>();

        try (Connection conn = DBHelper.getConnection()) {
            // Retrieve users
            String userQuery = "SELECT user_name, user_role FROM account";
            if ("admin".equals(userRole)) {
                userQuery = "SELECT user_name, user_role FROM account WHERE user_role = 'user'";
            }

            System.out.println("Executing Query: " + userQuery);

            try (PreparedStatement stmt = conn.prepareStatement(userQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String username = rs.getString("user_name");
                    String role = rs.getString("user_role");
                    System.out.println("User: " + username + ", Role: " + role);
                    users.add(new String[]{username, role});
                }
            }

            // Retrieve latest 5 messages
            String messageQuery = "SELECT user_name, subject, message FROM messages LIMIT 5";
            try (PreparedStatement stmt = conn.prepareStatement(messageQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(new String[]{rs.getString("user_name"), rs.getString("subject"), rs.getString("message")});
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("users", users);
        request.setAttribute("messages", messages);
        request.setAttribute("userRole", userRole);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}