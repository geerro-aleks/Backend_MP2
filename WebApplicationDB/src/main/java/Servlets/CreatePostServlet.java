package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CreatePostServlet")
public class CreatePostServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String currentUser = (String) session.getAttribute("username");
        String content = request.getParameter("content");

        if (content == null || content.trim().isEmpty()) {
            response.sendRedirect("profile.jsp?error=Post content cannot be empty.");
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            // Check if the user already has posts
            String checkQuery = "SELECT user_name FROM posts WHERE user_name = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setString(1, currentUser);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) { // User exists, shift posts
                    String updateQuery = "UPDATE posts SET post5 = post4, post4 = post3, post3 = post2, post2 = post1, post1 = ? WHERE user_name = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
                        stmt.setString(1, content);
                        stmt.setString(2, currentUser);
                        stmt.executeUpdate();
                    }
                } else { // User does not exist, insert new row
                    String insertQuery = "INSERT INTO posts (user_name, post1) VALUES (?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                        insertStmt.setString(1, currentUser);
                        insertStmt.setString(2, content);
                        insertStmt.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Database error: " + e.getMessage());
            return;
        }

        response.sendRedirect("ProfileServlet");
    }
}