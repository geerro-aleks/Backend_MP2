<%-- 
    Document   : login
    Created on : Feb 25, 2025, 12:28:19 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <h1>Login</h1>

        <%
            String errorMessage = request.getParameter("error");
            if (errorMessage != null) {
                out.println("<p style='color: red;'>" + URLDecoder.decode(errorMessage, "UTF-8") + "</p>");
            }
        %>

        <form action="login" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <br><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <br><br>

            <button type="submit">Login</button>
        </form>
        
        <p>Don't have an account yet? <a href="signup.jsp">Sign up</a></p>
    </body>
</html>
