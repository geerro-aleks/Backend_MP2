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
        <title>404 Error - Page Not Found</title>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                background-color: #F1F1F1;
                margin: 0;
                padding: 0;
                color: #333;
            }
            h1 {
                color: #000000;
                font-size: 32px;
                margin: 0;
                padding: 20px;
                background: linear-gradient(90deg, #FF7F7F, #FFD6D6);
                text-align: center;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            p {
                color: #000000;
                font-size: 18px;
                padding: 20px;
                text-align: center;
                background-color: #F8D0D0;
                margin: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            nav {
                background-color: #FFD6D6;
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
            .error-container {
                background-color: #FFFFFF;
                border-left: 5px solid #FF7F7F;
                padding: 30px;
                margin: 10px 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
            .error-container p {
                font-size: 18px;
                color: #333;
            }
            .no-posts {
                text-align: center;
                color: #FF7F7F;
                font-size: 18px;
                margin: 20px;
            }
        </style>
    </head>
    <body>
        <h1>404 Error - Page Not Found</h1>
        <p>Sorry, the page you are looking for could not be found.</p>

        <nav>
            <a href="home.jsp">Home</a>
            <a href="profile.jsp">Profile</a>
            <a href="help.jsp">Help</a>
            <a href="LogoutServlet">Logout</a>
        </nav>

        <div class="error-container">
            <h2>Oops! Something went wrong.</h2>
            <p>The page you requested does not exist. It may have been moved, deleted, or you may have entered the wrong URL.</p>
            <p>Please try one of the links above to continue.</p>
        </div>
    </body>
</html>