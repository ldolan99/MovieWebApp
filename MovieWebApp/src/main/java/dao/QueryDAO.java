package dao;

import db.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QueryDAO {

    // ---------- DTO classes for results ----------

    public static class Movie {
        public int id;
        public String title;
        public Date releaseDate;
        public String rating;
        public int lengthMin;
        public String category;
        public double cost;
        public String synopsis;
    }

    public static class PersonName {
        public String firstName;
        public String lastName;
    }

    public static class ActressPayment {
        public String firstName;
        public String lastName;
        public String movieTitle;
        public double payInMovie;
    }

    public static class Performer {
        public String movieTitle;
        public String type;          // "Actor" or "Actress"
        public String performerName;
        public String role;
    }

    public static class MoviePopularity {
        public String title;
        public int viewCount;
    }

    // ---------- 1) Movies by producer ----------

    public List<Movie> getMoviesByProducer(String firstName, String lastName) throws Exception {
        String sql =
                "SELECT m.* " +
                        "FROM movie m " +
                        "JOIN movie_producer mp  ON m.movie_id = mp.movie_id " +
                        "JOIN producer p         ON mp.producer_id = p.producer_id " +
                        "JOIN person per         ON p.person_id = per.person_id " +
                        "WHERE per.first_name = ? AND per.last_name = ?";

        List<Movie> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, firstName);
            ps.setString(2, lastName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMovie(rs));
                }
            }
        }
        return list;
    }

    // ---------- 2) Movies by director ----------

    public List<Movie> getMoviesByDirector(String firstName, String lastName) throws Exception {
        String sql =
                "SELECT m.* " +
                        "FROM movie m " +
                        "JOIN movie_director md  ON m.movie_id = md.movie_id " +
                        "JOIN director d         ON md.director_id = d.director_id " +
                        "JOIN person per         ON d.person_id = per.person_id " +
                        "WHERE per.first_name = ? AND per.last_name = ?";

        List<Movie> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, firstName);
            ps.setString(2, lastName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMovie(rs));
                }
            }
        }
        return list;
    }

    // ---------- 3) Most expensive movie by producer ----------

    public Movie getMostExpensiveMovieByProducer(String firstName, String lastName) throws Exception {
        String sql =
                "SELECT m.* " +
                        "FROM movie m " +
                        "JOIN movie_producer mp  ON m.movie_id = mp.movie_id " +
                        "JOIN producer p         ON mp.producer_id = p.producer_id " +
                        "JOIN person per         ON p.person_id = per.person_id " +
                        "WHERE per.first_name = ? AND per.last_name = ? " +
                        "ORDER BY m.cost DESC " +
                        "LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, firstName);
            ps.setString(2, lastName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapMovie(rs);
                }
            }
        }
        return null;
    }

    // ---------- 4) Movies in a given year ----------

    public List<Movie> getMoviesByYear(int year) throws Exception {
        String sql =
                "SELECT m.* FROM movie m WHERE YEAR(m.release_date) = ?";

        List<Movie> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMovie(rs));
                }
            }
        }
        return list;
    }

    // ---------- 5) Actresses NOT in any movie of a given producer ----------

    public List<PersonName> getActressesNotWorkingWithProducer(String prodFirst, String prodLast) throws Exception {
        String sql =
                "SELECT DISTINCT per.first_name, per.last_name " +
                        "FROM actress a " +
                        "JOIN person per ON a.person_id = per.person_id " +
                        "WHERE NOT EXISTS ( " +
                        "  SELECT 1 " +
                        "  FROM movie_producer mp " +
                        "  JOIN producer p2 ON mp.producer_id = p2.producer_id " +
                        "  JOIN person per2 ON p2.person_id = per2.person_id " +
                        "  WHERE mp.movie_id = a.movie_id " +
                        "    AND per2.first_name = ? " +
                        "    AND per2.last_name  = ? " +
                        ")";

        List<PersonName> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, prodFirst);
            ps.setString(2, prodLast);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PersonName pn = new PersonName();
                    pn.firstName = rs.getString("first_name");
                    pn.lastName  = rs.getString("last_name");
                    list.add(pn);
                }
            }
        }
        return list;
    }

    // ---------- 6) Highest-paid actress ----------

    public ActressPayment getHighestPaidActress() throws Exception {
        String sql =
                "SELECT per.first_name, per.last_name, m.title, a.pay_in_movie " +
                        "FROM actress a " +
                        "JOIN person per ON a.person_id = per.person_id " +
                        "JOIN movie m    ON a.movie_id = m.movie_id " +
                        "ORDER BY a.pay_in_movie DESC " +
                        "LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                ActressPayment ap = new ActressPayment();
                ap.firstName  = rs.getString("first_name");
                ap.lastName   = rs.getString("last_name");
                ap.movieTitle = rs.getString("title");
                ap.payInMovie = rs.getDouble("pay_in_movie");
                return ap;
            }
        }
        return null;
    }

    // ---------- 7) Actors + actresses who joined a movie ----------

    public List<Performer> getPerformersForMovie(String movieTitle) throws Exception {
        List<Performer> list = new ArrayList<>();

        String actorSql =
                "SELECT m.title, 'Actor' AS type, " +
                        "       CONCAT(per.first_name, ' ', per.last_name) AS performer, a.role " +
                        "FROM movie m " +
                        "JOIN actor a    ON m.movie_id = a.movie_id " +
                        "JOIN person per ON a.person_id = per.person_id " +
                        "WHERE m.title = ?";

        String actressSql =
                "SELECT m.title, 'Actress' AS type, " +
                        "       CONCAT(per.first_name, ' ', per.last_name) AS performer, a.role " +
                        "FROM movie m " +
                        "JOIN actress a  ON m.movie_id = a.movie_id " +
                        "JOIN person per ON a.person_id = per.person_id " +
                        "WHERE m.title = ?";

        try (Connection conn = DBConnection.getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement(actorSql)) {
                ps.setString(1, movieTitle);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Performer p = new Performer();
                        p.movieTitle    = rs.getString("title");
                        p.type          = rs.getString("type");
                        p.performerName = rs.getString("performer");
                        p.role          = rs.getString("role");
                        list.add(p);
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(actressSql)) {
                ps.setString(1, movieTitle);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Performer p = new Performer();
                        p.movieTitle    = rs.getString("title");
                        p.type          = rs.getString("type");
                        p.performerName = rs.getString("performer");
                        p.role          = rs.getString("role");
                        list.add(p);
                    }
                }
            }
        }

        return list;
    }

    // ---------- 8) Movies below a price for a director ----------

    public List<Movie> getMoviesByDirectorBelowPrice(String firstName, String lastName, double maxCost) throws Exception {
        String sql =
                "SELECT m.* " +
                        "FROM movie m " +
                        "JOIN movie_director md ON m.movie_id = md.movie_id " +
                        "JOIN director d        ON md.director_id = d.director_id " +
                        "JOIN person per        ON d.person_id = per.person_id " +
                        "WHERE per.first_name = ? " +
                        "  AND per.last_name  = ? " +
                        "  AND m.cost < ?";

        List<Movie> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setDouble(3, maxCost);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMovie(rs));
                }
            }
        }
        return list;
    }

    // ---------- 9) Producers of most expensive movies in a year ----------

    public List<PersonName> getProducersOfMostExpensiveMoviesInYear(int year) throws Exception {
        String sql =
                "WITH max_cost AS ( " +
                        "  SELECT MAX(cost) AS max_cost " +
                        "  FROM movie " +
                        "  WHERE YEAR(release_date) = ? " +
                        "), expensive_movies AS ( " +
                        "  SELECT movie_id " +
                        "  FROM movie, max_cost " +
                        "  WHERE YEAR(release_date) = ? AND cost = max_cost " +
                        ") " +
                        "SELECT DISTINCT per.first_name, per.last_name " +
                        "FROM producer p " +
                        "JOIN person per        ON p.person_id = per.person_id " +
                        "JOIN movie_producer mp ON p.producer_id = mp.producer_id " +
                        "WHERE mp.movie_id IN (SELECT movie_id FROM expensive_movies)";

        List<PersonName> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);
            ps.setInt(2, year);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PersonName pn = new PersonName();
                    pn.firstName = rs.getString("first_name");
                    pn.lastName  = rs.getString("last_name");
                    list.add(pn);
                }
            }
        }
        return list;
    }

    // ---------- 10) Most-watched movies for actor / actress ----------

    public List<MoviePopularity> getMostWatchedMoviesForActor(int personId) throws Exception {
        String sql =
                "SELECT m.title, mw.view_count " +
                        "FROM movie m " +
                        "JOIN movie_watch mw ON m.movie_id = mw.movie_id " +
                        "JOIN actor a        ON m.movie_id = a.movie_id " +
                        "WHERE a.person_id = ? " +
                        "ORDER BY mw.view_count DESC";

        return getPopularity(personId, sql);
    }

    public List<MoviePopularity> getMostWatchedMoviesForActress(int personId) throws Exception {
        String sql =
                "SELECT m.title, mw.view_count " +
                        "FROM movie m " +
                        "JOIN movie_watch mw ON m.movie_id = mw.movie_id " +
                        "JOIN actress a      ON m.movie_id = a.movie_id " +
                        "WHERE a.person_id = ? " +
                        "ORDER BY mw.view_count DESC";

        return getPopularity(personId, sql);
    }

    private List<MoviePopularity> getPopularity(int personId, String sql) throws Exception {
        List<MoviePopularity> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, personId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MoviePopularity mp = new MoviePopularity();
                    mp.title     = rs.getString("title");
                    mp.viewCount = rs.getInt("view_count");
                    list.add(mp);
                }
            }
        }
        return list;
    }

    // ---------- helper to map a movie row ----------

    private Movie mapMovie(ResultSet rs) throws SQLException {
        Movie m = new Movie();
        m.id         = rs.getInt("movie_id");
        m.title      = rs.getString("title");
        m.releaseDate= rs.getDate("release_date");
        m.rating     = rs.getString("rating");
        m.lengthMin  = rs.getInt("length_min");
        m.category   = rs.getString("category");
        m.cost       = rs.getDouble("cost");
        m.synopsis   = rs.getString("synopsis");
        return m;
    }
}

