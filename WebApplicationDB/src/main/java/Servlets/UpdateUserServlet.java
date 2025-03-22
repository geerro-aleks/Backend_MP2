package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Enumeration;
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

        Enumeration<String> parameterNames = request.getParameterNames();
        boolean allUpdatesSuccessful = true;

        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();

            // Check if the parameter is a "newUsername" field
            if (paramName.startsWith("newUsername_")) {
                // Extract the oldUsername from the parameter name
                String oldUsername = paramName.substring("newUsername_".length());

                // Get the new values from the form
                String newUsername = request.getParameter(paramName);
                String newPassword = request.getParameter("newPassword_" + oldUsername);
                String newRole = request.getParameter("newRole_" + oldUsername);

                // Check if at least one field is being updated
                boolean hasUpdate = (newUsername != null && !newUsername.trim().isEmpty()) ||
                                   (newPassword != null && !newPassword.trim().isEmpty()) ||
                                   (newRole != null && !newRole.trim().isEmpty());

                if (hasUpdate) {
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
                            if (rowsUpdated <= 0) {
                                allUpdatesSuccessful = false;
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        allUpdatesSuccessful = false;
                    }
                }
            }
        }

        if (allUpdatesSuccessful) {
            response.sendRedirect("AdminServlet?redirectPage=update.jsp&updateSuccess=All users updated successfully.");
        } else {
            response.sendRedirect("AdminServlet?redirectPage=update.jsp&updateError=Some users could not be updated.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("AdminServlet?redirectPage=update.jsp");
    }
}