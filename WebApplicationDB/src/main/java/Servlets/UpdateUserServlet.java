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

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String oldUsername = request.getParameter("username"); 
        String newUsername = request.getParameter("newUsername");
        String newPassword = request.getParameter("newPassword");
        String newRole = request.getParameter("newRole");

        if (oldUsername == null || oldUsername.trim().isEmpty()) {
            response.sendRedirect("AdminServlet?redirectPage=update.jsp&updateError=Invalid username.");
            return;
        }

        boolean hasUpdate = (newUsername != null && !newUsername.trim().isEmpty()) ||
                            (newPassword != null && !newPassword.trim().isEmpty()) ||
                            (newRole != null && !newRole.trim().isEmpty());

        if (!hasUpdate) {
            response.sendRedirect("AdminServlet?redirectPage=update.jsp&updateError=Please enter at least one field to update.");
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            StringBuilder query = new StringBuilder("UPDATE account SET ");
            boolean needsComma = false;

            if (newUsername != null && !newUsername.trim().isEmpty()) {
                query.append("user_name = ?");
                needsComma = true;
            }
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (needsComma) query.append(", ");
                query.append("password = ?");
                needsComma = true;
            }
            if (newRole != null && !newRole.trim().isEmpty()) {
                if (needsComma) query.append(", ");
                query.append("user_role = ?");
            }

            query.append(" WHERE user_name = ?");

            try (PreparedStatement stmt = conn.prepareStatement(query.toString())) {
                int index = 1;

                if (newUsername != null && !newUsername.trim().isEmpty()) {
                    stmt.setString(index++, newUsername);
                }
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    stmt.setString(index++, newPassword);
                }
                if (newRole != null && !newRole.trim().isEmpty()) {
                    stmt.setString(index++, newRole);
                }

                stmt.setString(index, oldUsername);

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    request.setAttribute("updateMessage", "User updated successfully.");
                    request.setAttribute("updatedUser", new String[]{newUsername, newPassword, newRole});
                    request.getRequestDispatcher("ResultServlet").forward(request, response);
                } else {
                    response.sendRedirect("update.jsp?updateError=User not found or no changes made.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("update.jsp?updateError=Database error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("AdminServlet?redirectPage=update.jsp");
    }
}
