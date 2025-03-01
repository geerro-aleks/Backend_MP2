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
    List<String[]> messages = (List<String[]>) request.getAttribute("messages");

    // Debugging: Check if users and messages are received
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
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; }
    </style>
</head>
<body>
    <h1>Admin Dashboard</h1>

    <nav>
        <a href="landing.jsp">Home</a> | 
        <a href="LogoutServlet">Logout</a>
    </nav>

    <form action="AdminServlet" method="get" style="display:inline;">
        <button type="submit">Refresh Data</button>
    </form>
    
    <%-- Show error message if database connection fails --%>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <h2>List of Users</h2>
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
                        <form action="DeleteUserServlet" method="post" style="display:inline;">
                            <input type="hidden" name="username" value="<%= user[0] %>">
                            <button type="submit" onclick="return confirm('Are you sure you want to delete this user?')">Delete</button>
                        </form>
                    </td>
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
            for (String[] message : messages) { %>
                <tr>
                    <td><%= message[0] %></td>
                    <td><%= message[1] %></td>
                    <td><%= message[2] %></td>
                </tr>
        <%  } 
        } else { %>
            <tr><td colspan="4">No messages found.</td></tr>
        <% } %>
    </table>

    <h2>Create New User</h2>
    <form action="CreateUserServlet" method="post">
        <label>Username:</label>
        <input type="text" name="username" required>
        <label>Password:</label>
        <input type="password" name="password" required>
        <label>Role:</label>
        <select name="role" required>
            <option value="user">User</option>
            <option value="admin">Admin</option>
            <% if ("super_admin".equals(userRole)) { %>
                <option value="super_admin">Super Admin</option>
            <% } %>
        </select>
        <button type="submit">Create</button>
    </form>
</body>
</html>