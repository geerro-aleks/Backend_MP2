<%-- 
    Document   : signup
    Created on : Feb 27, 2025, 1:43:23 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Signup</title>
    </head>
    <body>
        <h1>Create Account</h1>

        <%
            String errorMessage = request.getParameter("error");
            String successMessage = request.getParameter("success");
            if (errorMessage != null) {
                out.println("<p style='color: red;'>" + URLDecoder.decode(errorMessage, "UTF-8") + "</p>");
            } else if (successMessage != null) {
                out.println("<p style='color: green;'>" + URLDecoder.decode(successMessage, "UTF-8") + "</p>");
            }
        %>

        <form action="signup" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <br><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <br><br>

            <label for="role">Select Role:</label>
            <select id="role" name="role" required>
                <option value="user">User</option>
                <option value="admin">Admin</option>
                <option value="super_admin">Super Admin</option>
            </select>
            <br><br>

            <button type="submit">Sign Up</button>
        </form>

        <p>Already have an account? <a href="login.jsp">Login here</a></p>
    </body>
</html>
