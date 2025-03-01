package Servlets;

import java.io.IOException;
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

        DBHelper userHelper = new DBHelper();
        try {
            boolean isUpdated = userHelper.updateUser(oldUsername, newUsername, newPassword, newRole);
            if (isUpdated) {
                request.setAttribute("updateSuccess", "User updated successfully.");
            } else {
                request.setAttribute("updateError", "User not found or no changes made.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("updateError", "Database error: " + e.getMessage());
        }

        // Forward back to the admin page
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}