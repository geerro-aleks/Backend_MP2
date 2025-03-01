<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Session validation
    if (session == null || session.getAttribute("username") == null || session.getAttribute("userRole") == null) {
        response.sendRedirect("login.jsp?error=Please login first.");
        return;
    }

    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole) && !"super_admin".equals(userRole)) {
        response.sendRedirect("login.jsp?error=Unauthorized access.");
        return;
    }

    // Retrieve user and message lists from AdminServlet
    List<String[]> users = (List<String[]>) request.getAttribute("users");

    // Debugging: Check if users are received
    System.out.println("Users received: " + (users != null ? users.size() : "null"));
    if (users != null) {
        for (String[] user : users) {
            System.out.println("User: " + user[0] + ", Role: " + user[1]);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="refresh" content="1000;url=AdminServlet">
    <title>Update User Page</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; }
        .success { color: green; }
        .navbar { margin-bottom: 20px; }
        .navbar a { margin-right: 10px; text-decoration: none; color: #333; }
        .navbar a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <div class="navbar">
        <a href="admin.jsp">Back to Admin Dashboard</a>
        <a href="LogoutServlet">Logout</a>
    </div>

    <h1>Update User Here!</h1>

    <!-- Refresh Data Button -->
    <form action="AdminServlet" method="get" style="display:inline;">
        <input type="hidden" name="redirectPage" value="update.jsp">
        <button type="submit">Refresh Data</button>
    </form>

    <!-- Show error or success messages -->
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <p class="success"><%= request.getAttribute("success") %></p>
    <% } %>

    <!-- List of Users -->
    <h2 id="updateUser">List of Users</h2>
    <table>
        <tr>
            <th>Username</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
        <% if (users != null && !users.isEmpty()) { 
            for (String[] user : users) { %>
                <tr>
                    <td><%= user[0] %></td>
                    <td><%= user[1] %></td>
                    <td>
                        <form action="UpdateUserServlet" method="post" style="display:inline;">
                            <input type="hidden" name="username" value="<%= user[0] %>">
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
                            <button type="submit">Update</button>
                        </form>
                    </td>
                </tr>
        <%  } 
        } else { %>
            <tr><td colspan="3">No users found.</td></tr>
        <% } %>
    </table>
</body>
</html>