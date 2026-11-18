package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.Complaint;
import com.citycare.model.ComplaintHistory;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CitizenComplaintDetailServlet", urlPatterns = {"/citizen/complaint-details"})
public class CitizenComplaintDetailServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/citizen/my-complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(idParam.trim());
            Complaint complaint = complaintDAO.getComplaintById(complaintId);

            if (complaint == null) {
                req.setAttribute("errorMessage", "Complaint not found.");
                req.getRequestDispatcher("/citizen/my-complaints").forward(req, resp);
                return;
            }

            // CRITICAL SECURITY CHECK: Citizens must ONLY view their own complaints
            if (complaint.getCitizenId() != user.getUserId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You are not authorized to view another citizen's complaint.");
                return;
            }

            List<ComplaintHistory> history = complaintDAO.getComplaintHistory(complaintId);

            req.setAttribute("complaint", complaint);
            req.setAttribute("history", history);
            req.getRequestDispatcher("/citizen/complaint-details.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/citizen/my-complaints");
        }
    }
}

