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

        String username = request.getParameter("username");

        DBHelper dbHelper = new DBHelper();
        try {
            boolean isDeleted = dbHelper.deleteUser(username);
            if (isDeleted) {
                request.setAttribute("deleteSuccess", "User deleted successfully.");
                request.setAttribute("deletedUser", username);
            } else {
                request.setAttribute("deleteError", "User not found or deletion failed.");
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