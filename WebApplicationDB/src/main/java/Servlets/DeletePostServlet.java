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

@WebServlet("/DeletePostServlet")
public class DeletePostServlet extends HttpServlet {
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
            response.sendRedirect("profile.jsp?error=Invalid post selection.");
            return;
        }

        try {
            int index = Integer.parseInt(indexParam);
            if (index < 1 || index > 5) {
                response.sendRedirect("profile.jsp?error=Invalid post selection.");
                return;
            }

            try (Connection conn = DBHelper.getConnection()) {
                String updateQuery = "";
                switch (index) {
                    case 1:
                        updateQuery = "UPDATE posts SET post1 = post2, post2 = post3, post3 = post4, post4 = post5, post5 = NULL WHERE user_name = ?";
                        break;
                    case 2:
                        updateQuery = "UPDATE posts SET post2 = post3, post3 = post4, post4 = post5, post5 = NULL WHERE user_name = ?";
                        break;
                    case 3:
                        updateQuery = "UPDATE posts SET post3 = post4, post4 = post5, post5 = NULL WHERE user_name = ?";
                        break;
                    case 4:
                        updateQuery = "UPDATE posts SET post4 = post5, post5 = NULL WHERE user_name = ?";
                        break;
                    case 5:
                        updateQuery = "UPDATE posts SET post5 = NULL WHERE user_name = ?";
                        break;
                }

                try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
                    stmt.setString(1, currentUser);
                    stmt.executeUpdate();
                }
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Database error: " + e.getMessage());
            return;
        }

        response.sendRedirect("ProfileServlet");
    }
}
