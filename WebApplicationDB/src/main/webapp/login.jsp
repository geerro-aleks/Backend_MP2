<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #D6F6DD, #ACECF7); 
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .container {
                background: #fff;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.1);
                width: 350px;
                text-align: center;
            }
            h1 {
                font-size: 28px;
                margin-bottom: 25px;
                color: #333;
            }
            label {
                display: block;
                font-weight: bold;
                text-align: left;
                margin-bottom: 8px;
                color: #555;
            }
            input {
                width: 100%;
                padding: 12px;
                margin-bottom: 20px;
                border: 1px solid #DAC4F7;
                border-radius: 8px;
                font-size: 16px;
                box-sizing: border-box;
                background-color: #F4F4F4; 
            }
            input:focus {
                border-color: #ACECF7; 
                outline: none;
                box-shadow: 0 0 8px rgba(172, 236, 247, 0.6); 
            }
            button {
                width: 100%;
                padding: 12px;
                border: none;
                background-color: #F4989C; 
                color: white;
                font-size: 16px;
                border-radius: 8px;
                cursor: pointer;
                transition: background 0.3s;
            }
            button:hover {
                background-color: #EBD2B4; 
            }
            p {
                margin-top: 15px;
                font-size: 14px;
                color: #666;
            }
            a {
                color: #DAC4F7; 
                text-decoration: none;
                font-weight: bold;
            }
            a:hover {
                color: #ACECF7;
                text-decoration: underline;
            }
            .error-message {
                color: #F4989C; 
                font-size: 14px;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Login</h1>

            <%
                String errorMessage = request.getParameter("error");
                if (errorMessage != null) {
                    out.println("<p class='error-message'>" + URLDecoder.decode(errorMessage, "UTF-8") + "</p>");
                }
            %>

            <form action="login" method="post">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
                
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                
                <button type="submit">Login</button>
            </form>            
            <p>Don't have an account yet? <a href="signup.jsp">Sign up</a></p>
        </div>
    </body>
</html>