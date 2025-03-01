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

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String currentUser = (String) session.getAttribute("username");
        List<String> userPosts = new ArrayList<>();

        try (Connection conn = DBHelper.getConnection()) {
            String postQuery = "SELECT post1, post2, post3, post4, post5 FROM posts WHERE user_name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(postQuery)) {
                stmt.setString(1, currentUser);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    for (int i = 1; i <= 5; i++) { // Retrieve posts in ascending order
                        String post = rs.getString("post" + i);
                        if (post != null && !post.trim().isEmpty()) {
                            userPosts.add(post);
                            System.out.println("Post " + i + ": " + post);
                        }
                    }
                } else {
                    System.out.println("You have no posts yet.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("posts", userPosts);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
