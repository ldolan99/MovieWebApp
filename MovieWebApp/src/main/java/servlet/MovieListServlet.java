package servlet;

import db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/movies")
public class MovieListServlet extends HttpServlet {

    public static class Movie {
        private int id;
        private String title;
        private Date releaseDate;
        private double cost;
        private String rating;
        private int lengthMin;
        private String category;
        private String synopsis;

        public Movie(int id, String title, Date releaseDate, double cost,
                     String rating, int lengthMin, String category, String synopsis) {

            this.id = id;
            this.title = title;
            this.releaseDate = releaseDate;
            this.cost = cost;
            this.rating = rating;
            this.lengthMin = lengthMin;
            this.category = category;
            this.synopsis = synopsis;
        }

        // Getters so JSP can access properties
        public int getId() { return id; }
        public String getTitle() { return title; }
        public Date getReleaseDate() { return releaseDate; }
        public double getCost() { return cost; }
        public String getRating() { return rating; }
        public int getLengthMin() { return lengthMin; }
        public String getCategory() { return category; }
        public String getSynopsis() { return synopsis; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Movie> movies = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT movie_id, title, release_date, cost, rating, length_min, category, synopsis FROM movie"
             );
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                movies.add(new Movie(
                        rs.getInt("movie_id"),
                        rs.getString("title"),
                        rs.getDate("release_date"),
                        rs.getDouble("cost"),
                        rs.getString("rating"),
                        rs.getInt("length_min"),
                        rs.getString("category"),
                        rs.getString("synopsis")
                ));
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        System.out.println("Movies found by servlet: " + movies.size());
        req.setAttribute("movies", movies);
        req.getRequestDispatcher("/movies.jsp").forward(req, resp);
    }
}
