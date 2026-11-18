package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.Complaint;
import com.citycare.model.DashboardStats;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CitizenDashboardServlet", urlPatterns = {"/citizen/dashboard"})
public class CitizenDashboardServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        DashboardStats stats = complaintDAO.getCitizenDashboardStats(user.getUserId());
        List<Complaint> complaints = complaintDAO.getComplaintsByCitizen(user.getUserId());

        req.setAttribute("stats", stats);
        req.setAttribute("complaints", complaints);
        req.getRequestDispatcher("/citizen/dashboard.jsp").forward(req, resp);
    }
}

