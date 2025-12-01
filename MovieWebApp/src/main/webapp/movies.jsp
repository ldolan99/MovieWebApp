<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="servlet.MovieListServlet.Movie" %>

<html>
<head>
    <title>Movies</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        h1 {
            font-family: Arial, sans-serif;
        }
    </style>
</head>

<body>

<h1>Movies</h1>

<%
    // Get the list of movies that the servlet put in the request
    List<Movie> movies = (List<Movie>) request.getAttribute("movies");
    if (movies == null || movies.isEmpty()) {
%>
    <p>No movies found.</p>
<%
    } else {
%>
    <table>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Release Date</th>
            <th>Rating</th>
            <th>Length (min)</th>
            <th>Category</th>
            <th>Cost</th>
            <th>Synopsis</th>
        </tr>

        <%
            for (Movie m : movies) {
        %>
        <tr>
            <td><%= m.getId() %></td>
            <td><%= m.getTitle() %></td>
            <td><%= m.getReleaseDate() %></td>
            <td><%= m.getRating() %></td>
            <td><%= m.getLengthMin() %></td>
            <td><%= m.getCategory() %></td>
            <td><%= m.getCost() %></td>
            <td><%= m.getSynopsis() %></td>
        </tr>
        <%
            }
        %>
    </table>
<%
    }
%>

</body>
</html>
