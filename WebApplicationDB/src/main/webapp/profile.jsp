<%-- 
    Document   : profile
    Created on : Feb 27, 2025, 4:51:11 PM
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
        <title>Profile</title>
    </head>
    <body>
        <h1>Your Posts</h1>

        <nav>
            <a href="landing.jsp">Home</a>
        </nav>

        <h2>Your Posts</h2>
        <%
            List<String> posts = (List<String>) request.getAttribute("posts");
            if (posts != null && !posts.isEmpty()) {
                for (int i = 0; i < posts.size(); i++) {
                    out.println("<p>" + posts.get(i)
                            + " <a href='DeletePostServlet?index=" + (i + 1) + "'>Delete</a></p>");
                }
            } else {
                out.println("<p>You have no posts.</p>");
            }
        %>

        <h2>Create a New Post</h2>
        <form action="CreatePostServlet" method="post">
            <textarea name="content" required></textarea>
            <br>
            <button type="submit">Post</button>
        </form>
    </body>
</html>
