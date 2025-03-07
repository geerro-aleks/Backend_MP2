package Servlets;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

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
            // Checks if the username exists
            String checkUserQuery = "SELECT password, user_role FROM account WHERE user_name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkUserQuery)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String userRole = rs.getString("user_role");

                    if (storedPassword.equals(password)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("userRole", userRole);

                        List<String> followedUsers = new ArrayList<>();
                        String selectFollowsQuery = "SELECT follow1, follow2, follow3 FROM follows WHERE user_name = ?";
                        try (PreparedStatement followsStmt = conn.prepareStatement(selectFollowsQuery)) {
                            followsStmt.setString(1, username);
                            ResultSet followsRs = followsStmt.executeQuery();
                            if (followsRs.next()) {
                                for (int i = 1; i <= 3; i++) {
                                    String followedUser = followsRs.getString("follow" + i);
                                    if (followedUser != null) {
                                        followedUsers.add(followedUser);
                                    }
                                }
                            }
                        }
                        session.setAttribute("followedUsers", followedUsers);

                        if ("admin".equals(userRole) || "super_admin".equals(userRole)) {
                            response.sendRedirect("AdminServlet");
                        } else {
                            response.sendRedirect("LandingServlet"); // Now loads posts too!
                        }
                    } else {
                        response.sendRedirect("login.jsp?error=Incorrect password.");
                    }
                } else {
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
