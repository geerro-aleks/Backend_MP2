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
            <table>
                <tr>
                    <th>Username</th>
                    <th>Password</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
                <% if (users != null && !users.isEmpty()) {
                    for (String[] user : users) {%>
                <tr>
                    <td><%= user[0]%></td>
                    <td><%= user[1]%></td>
                    <td><%= user[2]%></td>
                    <td>
                        <form action="UpdateUserServlet" method="post" style="display:inline;">
                            <input type="hidden" name="username" value="<%= user[0]%>">
                            <input type="text" name="newUsername" placeholder="New Username">
                            <input type="password" name="newPassword" placeholder="New Password">
                            <select name="newRole">
                                <option value="">Change Role</option>
                                <option value="user">User</option>
                                <option value="admin">Admin</option>
                                <% if ("super_admin".equals(userRole)) { %>
                                <option value="super_admin">Super Admin</option>
                                <% } %>
                            </select>
                            <button type="submit" onclick="return confirm('Are you sure you want to update this user?')">Update</button>
                        </form>
                    </td>
                </tr>
                <%  }
                } else { %>
                <tr><td colspan="4">No users found.</td></tr>
                <% }%>
            </table>
        </div>
    </body>
</html>