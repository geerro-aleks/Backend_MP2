<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("username") == null || session.getAttribute("userRole") == null) {
        response.sendRedirect("login.jsp?error=Please login first.");
        return;
    }

    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole) && !"super_admin".equals(userRole)) {
        response.sendRedirect("login.jsp?error=Unauthorized access.");
        return;
    }

    List<String[]> users = (List<String[]>) request.getAttribute("users");
    List<String[]> messages = (List<String[]>) request.getAttribute("messages");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="refresh" content="1000;url=AdminServlet">
        <title>Admin Dashboard</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #F3F9D2;
                margin: 0;
                padding: 0;
            }
            .navbar {
                background-color: #2F2F2F; 
                overflow: hidden;
            }
            .navbar a, .navbar button {
                float: left;
                display: block;
                color: #F3F9D2; 
                text-align: center;
                padding: 14px 20px;
                text-decoration: none;
                border: none;
                cursor: pointer;
                font-size: 16px;
            }
            .navbar a:hover, .navbar button:hover {
                background-color: #93827F; 
            }
            .content {
                padding: 20px;
            }
            h1 {
                color: #2F2F2F; 
                font-size: 28px;
                margin-bottom: 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #BDC4A7;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #92B4A7; 
                color: #2F2F2F; 
            }
            tr:nth-child(even) {
                background-color: #F3F9D2; 
            }
            tr:nth-child(odd) {
                background-color: #FFFFFF; 
            }
            .error {
                color: #93827F; 
                font-size: 14px;
                margin-bottom: 15px;
            }
            .success {
                color: #92B4A7; 
                font-size: 14px;
                margin-bottom: 15px;
            }
            button {
                background-color: #92B4A7; 
                color: #2F2F2F; 
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                transition: background 0.3s;
            }
            button:hover {
                background-color: #BDC4A7; 
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <a href="AdminServlet">Dashboard</a>
            <a href="CreateUserServlet">Create User</a>
            <a href="UpdateUserServlet">Update User</a>
            <a href="DeleteUserServlet">Delete User</a>
            <a href="LogoutServlet">Logout</a>
        </div>

        <div class="content">
            <h1>Admin Dashboard</h1>

            <form action="AdminServlet" method="get" style="display:inline;">
                <button type="submit">Refresh Data</button>
            </form>

            <% if (request.getAttribute("error") != null) {%>
            <p class="error"><%= request.getAttribute("error")%></p>
            <% } %>

            <% if (request.getAttribute("createSuccess") != null) {%>
            <p class="success"><%= request.getAttribute("createSuccess")%></p>
            <% }%>

            <h2 id="updateUser">List of Users</h2>
            <table>
                <tr>
                    <th>Username</th>
                    <th>Password</th>
                    <th>Role</th>
                </tr>
                <% if (users != null && !users.isEmpty()) {
                        for (String[] user : users) {%>
                <tr>
                    <td><%= user[0]%></td> 
                    <td><%= user[1]%></td> 
                    <td><%= user[2]%></td>
                </tr>
                <%  }
                } else { %>
                <tr><td colspan="3">No users found.</td></tr>
                <% } %>
            </table>

            <h2>Recent Messages</h2>
            <table>
                <tr>
                    <th>From</th>
                    <th>Subject</th>
                    <th>Message</th>
                </tr>
                <% if (messages != null && !messages.isEmpty()) {
                        for (String[] message : messages) {%>
                <tr>
                    <td><%= message[0]%></td>
                    <td><%= message[1]%></td>
                    <td><%= message[2]%></td>
                </tr>
                <%  }
                } else { %>
                <tr><td colspan="4">No messages found.</td></tr>
                <% }%>
            </table>
        </div>
    </body>
</html>