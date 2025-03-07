<!DOCTYPE html>
<html>
    <head>
        <title>Create User</title>
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
            h2 {
                color: #2F2F2F; 
                font-size: 24px;
                margin-bottom: 20px;
            }
            label {
                display: block;
                font-weight: bold;
                margin-bottom: 8px;
                color: #2F2F2F;
            }
            input, select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #BDC4A7; 
                border-radius: 5px;
                font-size: 16px;
                box-sizing: border-box;
                background-color: #FFFFFF;
            }
            input:focus, select:focus {
                border-color: #92B4A7;
                outline: none;
                box-shadow: 0 0 5px rgba(146, 180, 167, 0.6); 
            }
            button {
                width: 100%;
                padding: 12px;
                border: none;
                background-color: #92B4A7;
                color: #2F2F2F; 
                font-size: 16px;
                border-radius: 5px;
                cursor: pointer;
                transition: background 0.3s;
            }
            button:hover {
                background-color: #BDC4A7; 
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
        </style>
    </head>
    <body>
        <div class="navbar">
            <a href="AdminServlet">Dashboard</a>
        </div>

        <div class="content">
            <h2>Create New User</h2>

            <% if (request.getAttribute("createError") != null) {%>
            <p class="error"><%= request.getAttribute("createError")%></p>
            <% } %>

            <% if (request.getAttribute("createSuccess") != null) {%>
            <p class="success"><%= request.getAttribute("createSuccess")%></p>
            <% }%>

            <form action="CreateUserServlet" method="post">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
                
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                
                <label for="user_role">User Role:</label>
                <select id="user_role" name="user_role" required>
                    <option value="user">User</option>
                    <option value="admin">Admin</option>
                    <option value="super_admin">Super Admin</option>
                </select>
                
                <button type="submit">Create User</button>
            </form>
        </div>
    </body>
</html>