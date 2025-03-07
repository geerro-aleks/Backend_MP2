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

@WebServlet("/CreateUserServlet")
public class CreateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String userRole = request.getParameter("user_role").trim();

        if (username.isEmpty() || password.isEmpty() || userRole.isEmpty()) {
            request.setAttribute("createError", "All fields are required.");
            request.getRequestDispatcher("create.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBHelper.getConnection()) {
            String checkQuery = "SELECT user_name FROM account WHERE user_name = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setString(1, username);
                if (checkStmt.executeQuery().next()) {
                    request.setAttribute("createError", "Username already exists.");
                    request.getRequestDispatcher("create.jsp").forward(request, response);
                    return;
                }
            }

            String insertQuery = "INSERT INTO account (user_name, password, user_role) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                stmt.setString(3, userRole);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    response.sendRedirect("AdminServlet?createSuccess=User created successfully.");
                    return;
                } else {
                    request.setAttribute("createError", "Failed to create user.");
                    request.getRequestDispatcher("create.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("createError", "Database error: " + e.getMessage());
            request.getRequestDispatcher("create.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("create.jsp");
    }

}
