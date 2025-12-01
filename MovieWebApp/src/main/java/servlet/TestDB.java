package servlet;

import db.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/testdb")
public class TestDB extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            Connection conn = DBConnection.getConnection();
            resp.getWriter().println("Database Connected Successfully!");
        } catch (Exception e) {
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
