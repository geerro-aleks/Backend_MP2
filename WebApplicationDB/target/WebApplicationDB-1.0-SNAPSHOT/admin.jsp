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
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .navbar { background-color: #333; overflow: hidden; }
        .navbar a, .navbar button { 
            float: left; 
            display: block; 
            color: white; 
            text-align: center; 
            padding: 14px 20px; 
            text-decoration: none; 
            border: none; 
            cursor: pointer; 
            font-size: 16px; 
        }
        .navbar a:hover, .navbar button:hover { background-color: #575757; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; }
        .content { padding: 20px; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <a href="landing.jsp">Home</a>
        <a href="LogoutServlet">Logout</a>
        <a href="#createUser">Create User</a>
        <a href="update.jsp">Update User</a>
        <a href="delete.jsp">Delete User</a>
    </div>

    <div class="content">
        <h1>Admin Dashboard</h1>

        <!-- Refresh Data Button -->
        <form action="AdminServlet" method="get" style="display:inline;">
            <button type="submit">Refresh Data</button>
        </form>
        
        <%-- Show error message if database connection fails --%>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <!-- List of Users -->
        <h2 id="updateUser">List of Users</h2>
        <table>
            <tr>
                <th>Username</th>
                <th>Role</th>
            </tr>
            <% if (users != null && !users.isEmpty()) { 
                for (String[] user : users) { %>
                    <tr>
                        <td><%= user[0] %></td>
                        <td><%= user[1] %></td>
                    </tr>
            <%  } 
            } else { %>
                <tr><td colspan="3">No users found.</td></tr>
            <% } %>
        </table>

        <!-- Recent Messages -->
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

        <!-- Create New User Form -->
        <h2 id="createUser">Create New User</h2>
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
    </div>
</body>
</html>