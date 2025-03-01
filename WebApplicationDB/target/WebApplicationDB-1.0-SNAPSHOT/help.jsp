<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Help Page</title>
</head>
<body>
    <h1>Help Page</h1>

    <nav>
        <a href="landing.jsp">Home</a> | 
        <a href="LogoutServlet">Logout</a>
    </nav>

    <%-- Show error message if message submission fails --%>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <%-- Show success message if message is sent successfully --%>
    <% if (request.getAttribute("success") != null) { %>
        <p style="color: green;"><%= request.getAttribute("success") %></p>
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