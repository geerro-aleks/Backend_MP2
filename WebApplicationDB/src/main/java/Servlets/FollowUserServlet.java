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
            String checkUserQuery = "SELECT user_role FROM account WHERE user_name = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkUserQuery)) {
                checkStmt.setString(1, followUser);
                ResultSet rs = checkStmt.executeQuery();
                if (!rs.next()) {
                    response.sendRedirect("UsersServlet?error=User does not exist.");
                    return;
                }

                String userRole = rs.getString("user_role");
                if (userRole.equals("admin") || userRole.equals("super_admin")) {
                    response.sendRedirect("UsersServlet?error=You cannot follow an admin.");
                    return;
                }
            }

            String selectQuery = "SELECT follow1, follow2, follow3 FROM follows WHERE user_name = ?";
            List<String> followedUsers = new ArrayList<>();
            boolean userExists = false;

            try (PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {
                selectStmt.setString(1, currentUser);
                ResultSet rs = selectStmt.executeQuery();

                if (rs.next()) {
                    userExists = true;
                    for (int i = 1; i <= 3; i++) {
                        String followed = rs.getString("follow" + i);
                        if (followed != null) {
                            followedUsers.add(followed);
                        }
                    }
                }
            }

            if (!userExists) {
                String insertQuery = "INSERT INTO follows (user_name, follow1, follow2, follow3) VALUES (?, NULL, NULL, NULL)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                    insertStmt.setString(1, currentUser);
                    insertStmt.executeUpdate();
                }
            }

            if (followedUsers.contains(followUser)) {
                response.sendRedirect("UsersServlet?error=You are already following this user.");
                return;
            }

            if (followedUsers.size() < 3) {
                String updateQuery = "UPDATE follows SET follow" + (followedUsers.size() + 1) + " = ? WHERE user_name = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                    updateStmt.setString(1, followUser);
                    updateStmt.setString(2, currentUser);
                    updateStmt.executeUpdate();
                }
            } else {
                response.sendRedirect("UsersServlet?error=Follow limit reached (3 users max).");
                return;
            }

            followedUsers.add(followUser);
            session.setAttribute("followedUsers", followedUsers);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("UsersServlet?error=Database error: " + e.getMessage());
            return;
        }

        response.sendRedirect("users.jsp"); 
    }
}
