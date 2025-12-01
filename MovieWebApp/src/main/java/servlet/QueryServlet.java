package servlet;

import dao.QueryDAO;
import dao.QueryDAO.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/queries")
public class QueryServlet extends HttpServlet {

    private final QueryDAO dao = new QueryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "q1":  handleQ1(req); break;
                case "q2":  handleQ2(req); break;
                case "q3":  handleQ3(req); break;
                case "q4":  handleQ4(req); break;
                case "q5":  handleQ5(req); break;
                case "q6":  handleQ6(req); break;
                case "q7":  handleQ7(req); break;
                case "q8":  handleQ8(req); break;
                case "q9":  handleQ9(req); break;
                case "q10_actor":   handleQ10Actor(req);   break;
                case "q10_actress": handleQ10Actress(req); break;
                default:
                    req.setAttribute("message", "Unknown or missing action.");
            }
            req.setAttribute("action", action);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
        }

        req.getRequestDispatcher("/queryResults.jsp").forward(req, resp);
    }

    private void handleQ1(HttpServletRequest req) throws Exception {
        String f = req.getParameter("firstName");
        String l = req.getParameter("lastName");
        List<Movie> movies = dao.getMoviesByProducer(f, l);
        req.setAttribute("movies", movies);
        req.setAttribute("title", "Movies produced by " + f + " " + l);
    }

    private void handleQ2(HttpServletRequest req) throws Exception {
        String f = req.getParameter("firstName");
        String l = req.getParameter("lastName");
        List<Movie> movies = dao.getMoviesByDirector(f, l);
        req.setAttribute("movies", movies);
        req.setAttribute("title", "Movies directed by " + f + " " + l);
    }

    private void handleQ3(HttpServletRequest req) throws Exception {
        String f = req.getParameter("firstName");
        String l = req.getParameter("lastName");
        Movie m = dao.getMostExpensiveMovieByProducer(f, l);
        req.setAttribute("singleMovie", m);
        req.setAttribute("title", "Most expensive movie produced by " + f + " " + l);
    }

    private void handleQ4(HttpServletRequest req) throws Exception {
        int year = Integer.parseInt(req.getParameter("year"));
        List<Movie> movies = dao.getMoviesByYear(year);
        req.setAttribute("movies", movies);
        req.setAttribute("title", "Movies released in " + year);
    }

    private void handleQ5(HttpServletRequest req) throws Exception {
        String f = req.getParameter("firstName");
        String l = req.getParameter("lastName");
        List<PersonName> persons = dao.getActressesNotWorkingWithProducer(f, l);
        req.setAttribute("persons", persons);
        req.setAttribute("title", "Actresses not working with producer " + f + " " + l);
    }

    private void handleQ6(HttpServletRequest req) throws Exception {
        ActressPayment ap = dao.getHighestPaidActress();
        req.setAttribute("actressPayment", ap);
        req.setAttribute("title", "Highest paid actress in a movie");
    }

    private void handleQ7(HttpServletRequest req) throws Exception {
        String title = req.getParameter("movieTitle");
        List<Performer> performers = dao.getPerformersForMovie(title);
        req.setAttribute("performers", performers);
        req.setAttribute("title", "Performers for movie " + title);
    }

    private void handleQ8(HttpServletRequest req) throws Exception {
        String f = req.getParameter("firstName");
        String l = req.getParameter("lastName");
        double maxCost = Double.parseDouble(req.getParameter("maxCost"));
        List<Movie> movies = dao.getMoviesByDirectorBelowPrice(f, l, maxCost);
        req.setAttribute("movies", movies);
        req.setAttribute("title", "Movies below " + maxCost + " directed by " + f + " " + l);
    }

    private void handleQ9(HttpServletRequest req) throws Exception {
        int year = Integer.parseInt(req.getParameter("year"));
        List<PersonName> persons = dao.getProducersOfMostExpensiveMoviesInYear(year);
        req.setAttribute("persons", persons);
        req.setAttribute("title", "Producers of most expensive movies in " + year);
    }

    private void handleQ10Actor(HttpServletRequest req) throws Exception {
        int personId = Integer.parseInt(req.getParameter("personId"));
        List<MoviePopularity> list = dao.getMostWatchedMoviesForActor(personId);
        req.setAttribute("popularity", list);
        req.setAttribute("title", "Most watched movies (actor ID " + personId + ")");
    }

    private void handleQ10Actress(HttpServletRequest req) throws Exception {
        int personId = Integer.parseInt(req.getParameter("personId"));
        List<MoviePopularity> list = dao.getMostWatchedMoviesForActress(personId);
        req.setAttribute("popularity", list);
        req.setAttribute("title", "Most watched movies (actress ID " + personId + ")");
    }
}

