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

@WebServlet("/LandingServlet")
public class LandingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String currentUser = (String) session.getAttribute("username");
        List<String> followedPosts = new ArrayList<>();

        try (Connection conn = DBHelper.getConnection()) {
            String postQuery = "SELECT p.user_name, p.post5 FROM posts p " +
                               "JOIN follows f ON p.user_name = f.follow1 OR p.user_name = f.follow2 OR p.user_name = f.follow3 " +
                               "WHERE f.user_name = ? AND p.post5 IS NOT NULL";

            try (PreparedStatement stmt = conn.prepareStatement(postQuery)) {
                stmt.setString(1, currentUser);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String post = "<strong>" + rs.getString("user_name") + ":</strong> " + rs.getString("post5");
                    followedPosts.add(post);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("followedPosts", followedPosts);
        request.getRequestDispatcher("landing.jsp").forward(request, response);
    }
}