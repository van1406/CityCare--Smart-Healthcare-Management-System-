package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "OfficerUpdateStatusServlet", urlPatterns = {"/officer/update-status"})
public class OfficerUpdateStatusServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        String complaintIdParam = req.getParameter("complaintId");
        String newStatus = req.getParameter("status");
        String remarks = req.getParameter("remarks");

        if (complaintIdParam == null || complaintIdParam.trim().isEmpty() ||
            newStatus == null || newStatus.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/officer/complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdParam.trim());
            boolean success = complaintDAO.updateStatus(complaintId, newStatus.trim(), user.getUserId(), remarks);

            if (success) {
                session.setAttribute("successMessage", "Complaint status updated to '" + newStatus + "' successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to update complaint status.");
            }
            resp.sendRedirect(req.getContextPath() + "/officer/complaint-details?id=" + complaintId);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/officer/complaints");
        }
    }
}

