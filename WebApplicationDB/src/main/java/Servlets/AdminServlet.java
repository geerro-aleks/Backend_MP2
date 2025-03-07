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
            String userQuery = "SELECT user_name, password, user_role FROM account";
            if ("admin".equals(userRole)) {
                userQuery = "SELECT user_name, password, user_role FROM account WHERE user_role = 'user'";
            }

            System.out.println("Executing Query: " + userQuery);

            try (PreparedStatement stmt = conn.prepareStatement(userQuery); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String username = rs.getString("user_name");
                    String password = rs.getString("password");
                    String role = rs.getString("user_role");

                    System.out.println("User: " + username + ", Password: " + password + ", Role: " + role);

                    users.add(new String[]{username, password, role});

                }
            }

            String messageQuery = "SELECT user_name, subject, message FROM messages ORDER BY id DESC LIMIT 5";
            try (PreparedStatement stmt = conn.prepareStatement(messageQuery); ResultSet rs = stmt.executeQuery()) {
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

        String updateSuccess = request.getParameter("updateSuccess");
        String updateError = request.getParameter("updateError");
        String deleteSuccess = request.getParameter("deleteSuccess");
        String createSuccess = request.getParameter("createSuccess");

        if (updateSuccess != null) {
            request.setAttribute("updateSuccess", updateSuccess);
        }
        if (updateError != null) {
            request.setAttribute("updateError", updateError);
        }
        if (deleteSuccess != null) {
            request.setAttribute("deleteSuccess", deleteSuccess);
        }
        if (createSuccess != null) {
            request.setAttribute("createSuccess", createSuccess);
        }

        String redirectPage = request.getParameter("redirectPage");
        if (redirectPage != null) {
            switch (redirectPage) {
                case "create.jsp":
                    request.getRequestDispatcher("create.jsp").forward(request, response);
                    break;
                case "update.jsp":
                    request.setAttribute("users", users);
                    request.getRequestDispatcher("update.jsp").forward(request, response);
                    break;
                case "delete.jsp":
                    request.setAttribute("users", users);
                    request.getRequestDispatcher("delete.jsp").forward(request, response);
                    break;
                default:
                    request.getRequestDispatcher("admin.jsp").forward(request, response);
                    break;
            }
        } else {
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        }
    }
}
