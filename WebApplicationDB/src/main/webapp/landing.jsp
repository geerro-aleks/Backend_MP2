<%-- 
    Document   : landing
    Created on : Feb 27, 2025, 2:13:11 PM
    Author     : DELL
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?error=Please login first.");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Home</title>
    </head>
    <body>
        <h1>Home</h1>
        <p>Welcome, <%= session.getAttribute("username")%>!</p>

        <nav>
            <a href="profile.jsp">Profile</a> |
            <a href="users.jsp">Following</a> |
            <a href="help.jsp">Help</a> |
            <a href="LogoutServlet">Logout</a>
        </nav>

        <h2>Latest Posts</h2>
        <%
            List<String> followedPosts = (List<String>) request.getAttribute("followedPosts");
            if (followedPosts != null && !followedPosts.isEmpty()) {
                for (String post : followedPosts) {
                    out.println("<p>" + post + "</p>");
                }
            } else {
                out.println("<p>No posts from followed users.</p>");
            }
        %>
    </body>
</html>
