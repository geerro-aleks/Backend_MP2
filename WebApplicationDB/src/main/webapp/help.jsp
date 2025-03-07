<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Help Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #D6F6DD;
            margin: 0;
            padding: 0;
            color: #333;
        }
        nav {
            background-color: #DAC4F7;
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
        form {
            background-color: #FFFFFF;
            padding: 20px;
            margin: 20px auto;
            max-width: 600px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            margin-bottom: 10px;
            font-size: 16px;
            color: #333;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #BDC4A7;
            border-radius: 5px;
            font-size: 16px;
        }
        textarea {
            resize: vertical;
        }
        button {
            background-color: #92B4A7;
            color: #000000;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #BDC4A7;
        }
        .error {
            color: #F4989C;
            font-size: 16px;
            text-align: center;
            margin: 20px;
        }
        .success {
            color: #92B4A7;
            font-size: 16px;
            text-align: center;
            margin: 20px;
        }
    </style>
</head>
<body>
    <nav>
        <a href="LandingServlet">Home</a>
    </nav>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <p class="success"><%= request.getAttribute("success") %></p>
    <% } %>

    <h2>Send a Message to Admin</h2>
    <form action="HelpServlet" method="post">
        <label for="subject">Subject:</label>
        <input type="text" id="subject" name="subject" required>

        <label for="message">Message:</label>
        <textarea id="message" name="message" rows="5" required></textarea>

        <button type="submit">Send Message</button>
    </form>
</body>
</html>