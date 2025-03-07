package Servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UnfollowUserServlet")
public class UnfollowUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String currentUser = (String) session.getAttribute("username");
        String unfollowUser = request.getParameter("user");

        if (unfollowUser == null || unfollowUser.trim().isEmpty()) {
            response.sendRedirect("UsersServlet?error=Invalid user selection.");
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            String selectQuery = "SELECT follow1, follow2, follow3 FROM follows WHERE user_name = ?";
            try (PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {
                selectStmt.setString(1, currentUser);
                ResultSet rs = selectStmt.executeQuery();

                if (rs.next()) {
                    String columnToUpdate = null;
                    if (unfollowUser.equals(rs.getString("follow1"))) {
                        columnToUpdate = "follow1";
                    } else if (unfollowUser.equals(rs.getString("follow2"))) {
                        columnToUpdate = "follow2";
                    } else if (unfollowUser.equals(rs.getString("follow3"))) {
                        columnToUpdate = "follow3";
                    }

                    if (columnToUpdate != null) {
                        String updateQuery = "UPDATE follows SET " + columnToUpdate + " = NULL WHERE user_name = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                            updateStmt.setString(1, currentUser);
                            updateStmt.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("UsersServlet?error=Database error: " + e.getMessage());
            return;
        }

        session.removeAttribute("followedUsers");
        response.sendRedirect("UsersServlet");
    }
}
