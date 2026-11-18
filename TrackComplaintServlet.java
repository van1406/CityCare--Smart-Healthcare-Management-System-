package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.Complaint;
import com.citycare.model.ComplaintHistory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TrackComplaintServlet", urlPatterns = {"/track"})
public class TrackComplaintServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String trackingId = req.getParameter("trackingId");

        if (trackingId != null && !trackingId.trim().isEmpty()) {
            Complaint complaint = complaintDAO.getComplaintByTrackingId(trackingId.trim());
            if (complaint != null) {
                List<ComplaintHistory> history = complaintDAO.getComplaintHistory(complaint.getComplaintId());
                req.setAttribute("complaint", complaint);
                req.setAttribute("history", history);
            } else {
                req.setAttribute("notFound", true);
                req.setAttribute("searchedTrackingId", trackingId.trim());
            }
        }

        req.getRequestDispatcher("/track.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String trackingId = req.getParameter("trackingId");
        if (trackingId != null && !trackingId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/track?trackingId=" + trackingId.trim());
        } else {
            resp.sendRedirect(req.getContextPath() + "/track");
        }
    }
}

