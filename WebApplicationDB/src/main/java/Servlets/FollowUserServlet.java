package Servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/FollowUserServlet")
public class FollowUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String currentUser = (String) session.getAttribute("username");
        String followUser = request.getParameter("followUser");

        if (followUser == null || followUser.trim().isEmpty()) {
            response.sendRedirect("UsersServlet?error=Enter a valid username.");
            return;
        }

        if (currentUser.equals(followUser)) {
            response.sendRedirect("UsersServlet?error=You cannot follow yourself.");
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            // Check if followUser exists in account table
            String checkUserQuery = "SELECT user_name FROM account WHERE user_name = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkUserQuery)) {
                checkStmt.setString(1, followUser);
                ResultSet rs = checkStmt.executeQuery();
                if (!rs.next()) {
                    response.sendRedirect("UsersServlet?error=User does not exist.");
                    return;
                }
            }

            // Get the current followed users
            String selectQuery = "SELECT follow1, follow2, follow3 FROM follows WHERE user_name = ?";
            try (PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {
                selectStmt.setString(1, currentUser);
                ResultSet rs = selectStmt.executeQuery();

                if (rs.next()) {
                    String follow1 = rs.getString("follow1");
                    String follow2 = rs.getString("follow2");
                    String follow3 = rs.getString("follow3");

                    // Prevent following the same user multiple times
                    if (follow1 != null && follow1.equals(followUser) ||
                        follow2 != null && follow2.equals(followUser) ||
                        follow3 != null && follow3.equals(followUser)) {
                        response.sendRedirect("UsersServlet?error=You are already following this user.");
                        return;
                    }

                    String updateQuery = "";
                    if (follow1 == null) {
                        updateQuery = "UPDATE follows SET follow1 = ? WHERE user_name = ?";
                    } else if (follow2 == null) {
                        updateQuery = "UPDATE follows SET follow2 = ? WHERE user_name = ?";
                    } else if (follow3 == null) {
                        updateQuery = "UPDATE follows SET follow3 = ? WHERE user_name = ?";
                    } else {
                        response.sendRedirect("UsersServlet?error=Follow limit reached (3 users max).");
                        return;
                    }

                    try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                        updateStmt.setString(1, followUser);
                        updateStmt.setString(2, currentUser);
                        updateStmt.executeUpdate();
                    }

                } else { // No record exists for this user, insert a new row
                    String insertQuery = "INSERT INTO follows (user_name, follow1) VALUES (?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                        insertStmt.setString(1, currentUser);
                        insertStmt.setString(2, followUser);
                        insertStmt.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("UsersServlet?error=Database error: " + e.getMessage());
            return;
        }

        response.sendRedirect("UsersServlet");
    }
}
