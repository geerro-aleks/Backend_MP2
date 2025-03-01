/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
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
            } else {
                request.setAttribute("deleteError", "User not found or deletion failed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("deleteError", "Database error: " + e.getMessage());
        }

        // Forward back to the admin page
        request.getRequestDispatcher("delete.jsp").forward(request, response);
    }
}