<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.QueryDAO.Movie" %>
<%@ page import="dao.QueryDAO.PersonName" %>
<%@ page import="dao.QueryDAO.ActressPayment" %>
<%@ page import="dao.QueryDAO.Performer" %>
<%@ page import="dao.QueryDAO.MoviePopularity" %>

<!DOCTYPE html>
<html>
<head>
    <title>MovieMatrix – Query Results</title>

    <!-- Same font family as index.jsp -->
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&display=swap" rel="stylesheet">

    <!-- Shared MovieMatrix styles -->
    <link rel="stylesheet" href="css/moviematrix.css">
</head>
<body>

<div class="container">

    <div class="top-bar">
        <div>
            <h1>
                <%= (request.getAttribute("title") != null)
                        ? request.getAttribute("title")
                        : "Query Results" %>
            </h1>
            <p class="subtitle">Below are the results returned from the database.</p>
        </div>

        <a href="index.jsp" class="btn-back">&larr; Back to queries</a>
    </div>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error">
            <strong>Error:</strong> <%= error %>
        </div>
    <%
        }
    %>

    <%
        // Movies list (Q1, Q2, Q4, Q8)
        List<Movie> movies = (List<Movie>) request.getAttribute("movies");
        if (movies != null) {
    %>
        <h2 class="section-title">Movies</h2>
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
                <td><%= m.id %></td>
                <td><%= m.title %></td>
                <td><%= m.releaseDate %></td>
                <td><%= m.rating %></td>
                <td><%= m.lengthMin %></td>
                <td><%= m.category %></td>
                <td><%= m.cost %></td>
                <td><%= m.synopsis %></td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        }
    %>

    <%
        // Single movie (Q3)
        Movie singleMovie = (Movie) request.getAttribute("singleMovie");
        if (singleMovie != null) {
    %>
        <h2 class="section-title">Most Expensive Movie</h2>
        <div class="info-block">
            <b>Title:</b> <%= singleMovie.title %><br/>
            <b>Cost:</b> <%= singleMovie.cost %><br/>
            <b>Release date:</b> <%= singleMovie.releaseDate %><br/>
            <b>Rating:</b> <%= singleMovie.rating %><br/>
            <b>Category:</b> <%= singleMovie.category %><br/>
            <b>Synopsis:</b> <%= singleMovie.synopsis %>
        </div>
    <%
        }
    %>

    <%
        // People (actresses, producers, etc) – Q5 & Q9
        List<PersonName> persons = (List<PersonName>) request.getAttribute("persons");
        if (persons != null) {
    %>
        <h2 class="section-title">People</h2>
        <ul>
            <%
                for (PersonName pn : persons) {
            %>
            <li><%= pn.firstName %> <%= pn.lastName %></li>
            <%
                }
            %>
        </ul>
    <%
        }
    %>

    <%
        // Highest paid actress – Q6
        ActressPayment ap = (ActressPayment) request.getAttribute("actressPayment");
        if (ap != null) {
    %>
        <h2 class="section-title">Highest Paid Actress</h2>
        <div class="info-block">
            <b>Name:</b> <%= ap.firstName %> <%= ap.lastName %><br/>
            <b>Movie:</b> <%= ap.movieTitle %><br/>
            <b>Pay in movie:</b> <%= ap.payInMovie %>
        </div>
    <%
        }
    %>

    <%
        // Performers in movie – Q7
        List<Performer> performers = (List<Performer>) request.getAttribute("performers");
        if (performers != null) {
    %>
        <h2 class="section-title">Performers</h2>
        <table>
            <tr>
                <th>Movie</th>
                <th>Type</th>
                <th>Name</th>
                <th>Role</th>
            </tr>
            <%
                for (Performer p : performers) {
            %>
            <tr>
                <td><%= p.movieTitle %></td>
                <td><%= p.type %></td>
                <td><%= p.performerName %></td>
                <td><%= p.role %></td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        }
    %>

    <%
        // Popularity (Q10)
        List<MoviePopularity> popularity = (List<MoviePopularity>) request.getAttribute("popularity");
        if (popularity != null) {
    %>
        <h2 class="section-title">Most Watched Movies</h2>
        <table>
            <tr>
                <th>Title</th>
                <th>View count</th>
            </tr>
            <%
                for (MoviePopularity mp : popularity) {
            %>
            <tr>
                <td><%= mp.title %></td>
                <td><%= mp.viewCount %></td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        }
    %>

</div>

</body>
</html>
