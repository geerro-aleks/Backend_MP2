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

@WebServlet("/UsersServlet")
public class UsersServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String currentUser = (String) session.getAttribute("username");
        List<String> followedUsers = new ArrayList<>();

        try (Connection conn = DBHelper.getConnection()) {
            String query = "SELECT follow1, follow2, follow3 FROM follows WHERE user_name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, currentUser);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    for (int i = 1; i <= 3; i++) {
                        String followedUser = rs.getString("follow" + i);
                        if (followedUser != null) {
                            followedUsers.add(followedUser);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("followedUsers", followedUsers);
        request.getRequestDispatcher("users.jsp").forward(request, response);
    }
}
