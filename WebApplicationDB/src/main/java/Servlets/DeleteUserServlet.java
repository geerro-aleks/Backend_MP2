package Servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] usernames = request.getParameterValues("usernames");
        String userRole = (String) request.getSession().getAttribute("userRole");

        DBHelper dbHelper = new DBHelper();
        try {
            boolean allDeleted = true;
            for (String username : usernames) {
                boolean isDeleted = dbHelper.deleteUser(username);
                if (!isDeleted) {
                    allDeleted = false;
                }
            }
            if (allDeleted) {
                request.setAttribute("deleteSuccess", "Selected users deleted successfully.");
            } else {
                request.setAttribute("deleteError", "Some users could not be deleted.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("deleteError", "Database error: " + e.getMessage());
        }

        request.getRequestDispatcher("/ResultServlet").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("AdminServlet?redirectPage=delete.jsp");
    }
}