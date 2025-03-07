<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Result Page</title>
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
            .success {
                color: #92B4A7;
                font-size: 14px;
                margin-bottom: 15px;
            }
            .error {
                color: #93827F;
                font-size: 14px;
                margin-bottom: 15px;
            }
            a {
                color: #2F2F2F;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <a href="AdminServlet">Return to Admin Dashboard</a>
        </div>

        <div class="content">
            <h1>Result</h1>

            <% if (request.getAttribute("updateMessage") != null) {%>
            <p class="success"><%= request.getAttribute("updateMessage")%></p>
            <table>
                <tr>
                    <th>Updated Username</th>
                    <th>Updated Password</th>
                    <th>Updated Role</th>
                </tr>
                <% String[] updatedUser = (String[]) request.getAttribute("updatedUser");%>
                <tr>
                    <td><%= updatedUser[0]%></td>
                    <td><%= updatedUser[1]%></td>
                    <td><%= updatedUser[2]%></td>
                </tr>
            </table>
            <% } %>

            <% if (request.getAttribute("deleteSuccess") != null) {%>
            <p class="success"><%= request.getAttribute("deleteSuccess")%></p>
            <% if (request.getAttribute("deletedUser") != null) {%>
            <p>Deleted User: <strong><%= request.getAttribute("deletedUser")%></strong></p>
            <% } else { %>
            <p class="error">Error: Deleted user not found.</p>
            <% } %>
            <% } %>

            <% if (request.getAttribute("deleteError") != null) {%>
            <p class="error"><%= request.getAttribute("deleteError")%></p>
            <% }%>
        </div>
    </body>
</html>