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
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="refresh" content="1000;url=AdminServlet">
        <title>Update User Information</title>
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
            .navbar a {
                float: left;
                display: block;
                color: #F3F9D2;
                text-align: center;
                padding: 14px 20px;
                text-decoration: none;
                font-size: 16px;
            }
            .navbar a:hover {
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
            input[type="text"], input[type="password"], select {
                padding: 8px;
                border: 1px solid #BDC4A7;
                border-radius: 5px;
                margin-right: 10px;
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <a href="AdminServlet">Dashboard</a>
        </div>

        <div class="content">
            <h1>Update User Information</h1>

            <form action="AdminServlet" method="get" style="display:inline;">
                <input type="hidden" name="redirectPage" value="update.jsp">
                <button type="submit">Refresh Data</button>
            </form>

            <% if (request.getAttribute("updateError") != null) {%>
            <p class="error"><%= request.getAttribute("updateError")%></p>
            <% } %>
            <% if (request.getAttribute("updateSuccess") != null) {%>
            <p class="success"><%= request.getAttribute("updateSuccess")%></p>
            <% } %>

            <h2 id="updateUser">List of Users</h2>
            <form action="UpdateUserServlet" method="post">
                <table>
                    <tr>
                        <th>Username</th>
                        <th>Password</th>
                        <th>Role</th>
                        <th>New Username</th>
                        <th>New Password</th>
                        <th>New Role</th>
                    </tr>
                    <% if (users != null && !users.isEmpty()) {
                        for (String[] user : users) {
                            String oldUsername = user[0];
                    %>
                    <tr>
                        <td><%= oldUsername%></td>
                        <td><%= user[1]%></td>
                        <td><%= user[2]%></td>
                        <td>
                            <input type="text" name="newUsername_<%= oldUsername%>" placeholder="New Username">
                        </td>
                        <td>
                            <input type="password" name="newPassword_<%= oldUsername%>" placeholder="New Password">
                        </td>
                        <td>
                            <select name="newRole_<%= oldUsername%>">
                                <option value="">No Change</option>
                                <option value="user">User</option>
                                <option value="admin">Admin</option>
                                <% if ("super_admin".equals(userRole)) { %>
                                <option value="super_admin">Super Admin</option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    <%  }
                    } else { %>
                    <tr><td colspan="6">No users found.</td></tr>
                    <% }%>
                </table>
                <button type="submit" onclick="return confirm('Are you sure you want to update the selected users?')">Update Users</button>
            </form>
        </div>
    </body>
</html>