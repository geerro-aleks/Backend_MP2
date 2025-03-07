<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?error=Please login first.");
        return;
    }

    if (request.getAttribute("posts") == null) {
        response.sendRedirect("ProfileServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Profile</title>
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
            textarea {
                width: 100%;
                padding: 10px;
                margin-bottom: 20px;
                border: 1px solid #BDC4A7;
                border-radius: 5px;
                font-size: 16px;
                resize: vertical;
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
        <h1>Your Posts</h1>

        <nav>
            <a href="LandingServlet">Home</a> | 
            <a href="ProfileServlet">Refresh Posts</a>
        </nav>

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