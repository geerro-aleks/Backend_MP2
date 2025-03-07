<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?error=Please login first.");
        return;
    }

    List<String> followedUsers = (List<String>) session.getAttribute("followedUsers");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Following</title>
        <style>
            body {
                font-family: Arial, sans-serif;
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
            p {
                background-color: #FFFFFF;
                padding: 15px;
                margin: 10px 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                color: #333;
                font-size: 16px;
            }
            p a {
                color: #F4989C;
                text-decoration: none;
                font-weight: bold;
            }
            p a:hover {
                text-decoration: underline;
            }
            .error {
                color: #F4989C;
                font-size: 16px;
                text-align: center;
                margin: 20px;
            }
            h2 {
                color: #000000;
                font-size: 28px;
                text-align: center;
                margin: 20px 0;
            }
            form {
                background-color: #FFFFFF;
                padding: 20px;
                margin: 20px auto;
                max-width: 600px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            label {
                display: block;
                margin-bottom: 10px;
                font-size: 16px;
                color: #333;
            }
            input[type="text"] {
                width: 100%;
                padding: 10px;
                margin-bottom: 20px;
                border: 1px solid #BDC4A7;
                border-radius: 5px;
                font-size: 16px;
            }
            button {
                background-color: #92B4A7;
                color: #000000;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            button:hover {
                background-color: #BDC4A7;
            }
        </style>
    </head>
    <body>
        <h1>Following</h1>

        <nav>
            <a href="LandingServlet">Home</a> | 
            <a href="UsersServlet">Refresh Following</a>
        </nav>

        <%
            String errorMessage = request.getParameter("error");
            if (errorMessage != null) {
                out.println("<p class='error'>" + errorMessage + "</p>");
            }
        %>

        <%
            if (followedUsers != null && !followedUsers.isEmpty()) {
                for (String user : followedUsers) {
                    out.println("<p>" + user + " <a href='UnfollowUserServlet?user=" + user + "'>Unfollow</a></p>");
                }
            } else {
                out.println("<p>You are not following anyone.</p>");
            }
        %>

        <h2>Follow a User</h2>
        <form action="FollowUserServlet" method="post">
            <label for="followUser">Enter Username:</label>
            <input type="text" id="followUser" name="followUser" required>
            <button type="submit">Follow</button>
        </form>
    </body>
</html>