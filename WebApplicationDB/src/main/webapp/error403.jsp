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
        <title>403 Error - Forbidden</title>
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
                background: linear-gradient(90deg, #FFB04D, #FFDDC1);
                text-align: center;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            p {
                color: #000000;
                font-size: 18px;
                padding: 20px;
                text-align: center;
                background-color: #FFD3B6;
                margin: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            nav {
                background-color: #FFDDC1;
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
                border-left: 5px solid #FFB04D;
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
                color: #FFB04D;
                font-size: 18px;
                margin: 20px;
            }
        </style>
    </head>
    <body>
        <h1>403 Error - Forbidden</h1>
        <p>You do not have permission to access this page.</p>

        <nav>
            <a href="home.jsp">Home</a>
            <a href="profile.jsp">Profile</a>
            <a href="help.jsp">Help</a>
            <a href="LogoutServlet">Logout</a>
        </nav>

        <div class="error-container">
            <h2>Access Denied</h2>
            <p>The page you're trying to access is restricted, and you do not have sufficient permissions to view it.</p>
            <p>If you believe this is a mistake, please contact an administrator.</p>
        </div>
    </body>
</html>