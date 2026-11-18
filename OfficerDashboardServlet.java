package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.OfficerDAO;
import com.citycare.model.Complaint;
import com.citycare.model.DashboardStats;
import com.citycare.model.Officer;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OfficerDashboardServlet", urlPatterns = {"/officer/dashboard"})
public class OfficerDashboardServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;
    private OfficerDAO officerDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        officerDAO = new OfficerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        Officer officer = officerDAO.getOfficerByUserId(user.getUserId());
        DashboardStats stats = complaintDAO.getOfficerDashboardStats(user.getUserId());
        List<Complaint> assignedComplaints = complaintDAO.getComplaintsByOfficer(user.getUserId(), null, null, null);

        req.setAttribute("officer", officer);
        req.setAttribute("stats", stats);
        req.setAttribute("complaints", assignedComplaints);
        req.getRequestDispatcher("/officer/dashboard.jsp").forward(req, resp);
    }
}

