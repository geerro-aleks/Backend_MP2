package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import javax.servlet.http.HttpSession;

/**
 *
 * @author jyroa
 */
@WebServlet(name = "HelpServlet", urlPatterns = {"/HelpServlet"})
public class HelpServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HelpServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HelpServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        String username = (String) session.getAttribute("username");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        try (Connection conn = DBHelper.getConnection()) {
            // Insert the message into the database
            String sql = "INSERT INTO messages (user_name, subject, message) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, subject);
                stmt.setString(3, message);
                stmt.executeUpdate();
            }

            // Set success message
            request.setAttribute("success", "Your message has been sent to the admin.");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to send message. Please try again.");
        }

        request.getRequestDispatcher("help.jsp").forward(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
