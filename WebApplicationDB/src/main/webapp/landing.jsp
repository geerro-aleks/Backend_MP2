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
        <style>
            body {
                font-family: 'Arial', sans-serif;
                background-color: #D6F6DD;
                margin: 0;
                padding: 0;
                color: #333;
            }
            h1 {
                color: #000000;
                font-size: 32px;
                margin: 0;
                padding: 20px;
                background: linear-gradient(90deg, #ACECF7, #DAC4F7);
                text-align: center;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            p {
                color: #000000;
                font-size: 18px;
                padding: 20px;
                text-align: center;
                background-color: #EBD2B4;
                margin: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            nav {
                background-color: #DAC4F7;
                padding: 15px;
                margin-bottom: 20px;
                text-align: center;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            nav a {
                color: #000000;
                text-decoration: none;
                margin: 0 15px;
                font-size: 18px;
                font-weight: bold;
                transition: color 0.3s ease;
            }
            nav a:hover {
                color: #F4989C;
                text-decoration: underline;
            }
            h2 {
                color: #000000;
                font-size: 28px;
                text-align: center;
                margin: 20px 0;
            }
            .post {
                background-color: #FFFFFF;
                border-left: 5px solid #F4989C;
                padding: 15px;
                margin: 10px 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .post:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
            }
            .post p {
                margin: 0;
                color: #333;
                font-size: 16px;
            }
            .no-posts {
                text-align: center;
                color: #F4989C;
                font-size: 18px;
                margin: 20px;
            }
        </style>
    </head>
    <body>
        <h1>Home</h1>
        <p>Welcome, <%= session.getAttribute("username")%>!</p>

        <nav>
            <a href="profile.jsp">Profile</a>
            <a href="users.jsp">Following</a>
            <a href="help.jsp">Help</a>
            <a href="LogoutServlet">Logout</a>
        </nav>

        <h2>Latest Posts from Followed Users</h2>
        <%
            List<String> followedPosts = (List<String>) request.getAttribute("followedPosts");
            if (followedPosts != null && !followedPosts.isEmpty()) {
                for (String post : followedPosts) {
        %>
                    <div class="post">
                        <%= post %>
                    </div>
        <%
                }
            } else {
        %>
            <p class="no-posts">No posts from followed users.</p>
        <%
            }
        %>
    </body>
</html>