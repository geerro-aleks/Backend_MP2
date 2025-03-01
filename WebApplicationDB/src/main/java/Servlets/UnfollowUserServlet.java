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
        String indexParam = request.getParameter("index");

        if (indexParam == null) {
            response.sendRedirect("users.jsp?error=Invalid user selection.");
            return;
        }

        try {
            int index = Integer.parseInt(indexParam);
            if (index < 1 || index > 3) {
                response.sendRedirect("users.jsp?error=Invalid user selection.");
                return;
            }

            try (Connection conn = DBHelper.getConnection()) {
                // Get current follows
                String selectQuery = "SELECT follow1, follow2, follow3 FROM follows WHERE user_name = ?";
                try (PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {
                    selectStmt.setString(1, currentUser);
                    ResultSet rs = selectStmt.executeQuery();

                    if (rs.next()) {
                        String follow1 = rs.getString("follow1");
                        String follow2 = rs.getString("follow2");
                        String follow3 = rs.getString("follow3");

                        // Remove the selected user and shift remaining follows
                        if (index == 1) {
                            follow1 = follow2;
                            follow2 = follow3;
                            follow3 = null;
                        } else if (index == 2) {
                            follow2 = follow3;
                            follow3 = null;
                        } else if (index == 3) {
                            follow3 = null;
                        }

                        // Update follows table with shifted values
                        String updateQuery = "UPDATE follows SET follow1 = ?, follow2 = ?, follow3 = ? WHERE user_name = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                            updateStmt.setString(1, follow1);
                            updateStmt.setString(2, follow2);
                            updateStmt.setString(3, follow3);
                            updateStmt.setString(4, currentUser);
                            updateStmt.executeUpdate();
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("users.jsp?error=Database error.");
            return;
        }

        response.sendRedirect("UsersServlet");
    }
}
