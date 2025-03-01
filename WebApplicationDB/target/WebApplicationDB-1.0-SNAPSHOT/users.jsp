<%-- 
    Document   : users
    Created on : Feb 27, 2025, 4:51:25 PM
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
        <title>Following</title>
    </head>
    <body>
        <h1>Following List</h1>

        <nav>
            <a href="landing.jsp">Home</a>
        </nav>

        <%-- Display error message if exists --%>
        <%
            String errorMessage = request.getParameter("error");
            if (errorMessage != null) {
                out.println("<p style='color:red;'>" + errorMessage + "</p>");
            }
        %>

        <h2>Your Followed Users</h2>
        <%
            List<String> followedUsers = (List<String>) request.getAttribute("followedUsers");
            if (followedUsers != null && !followedUsers.isEmpty()) {
                for (int i = 0; i < followedUsers.size(); i++) {
                    out.println("<p>" + followedUsers.get(i) + 
                                " <a href='UnfollowUserServlet?index=" + (i+1) + "'>Unfollow</a></p>");
                }
            } else {
                out.println("<p>You are not following anyone.</p>");
            }
        %>

        <h2>Follow a New User</h2>
        <form action="FollowUserServlet" method="post">
            <label for="followUser">Enter Username:</label>
            <input type="text" id="followUser" name="followUser" required>
            <button type="submit">Follow</button>
        </form>
    </body>
</html>
