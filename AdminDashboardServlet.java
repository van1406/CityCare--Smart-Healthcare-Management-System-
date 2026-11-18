package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.Complaint;
import com.citycare.model.DashboardStats;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardStats stats = complaintDAO.getAdminDashboardStats();
        List<Complaint> recentComplaints = complaintDAO.getAllComplaints(null, null, null, null);

        req.setAttribute("stats", stats);
        req.setAttribute("complaints", recentComplaints);
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}

