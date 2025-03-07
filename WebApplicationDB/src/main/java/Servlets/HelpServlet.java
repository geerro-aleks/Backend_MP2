package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/HelpServlet")
public class HelpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String username = (String) session.getAttribute("username");
        String subject = request.getParameter("subject").trim();
        String message = request.getParameter("message").trim();

        if (subject.isEmpty() || message.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("help.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            String insertQuery = "INSERT INTO messages (user_name, subject, message) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
                stmt.setString(1, username);
                stmt.setString(2, subject);
                stmt.setString(3, message);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    request.setAttribute("success", "Message sent successfully.");
                } else {
                    request.setAttribute("error", "Failed to send message.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.getRequestDispatcher("help.jsp").forward(request, response);
    }
}
