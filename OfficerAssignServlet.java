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

@WebServlet(name = "OfficerAssignServlet", urlPatterns = {"/officer/assign-department"})
public class OfficerAssignServlet extends HttpServlet {

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
        String deptIdParam = req.getParameter("departmentId");
        String officerUserIdParam = req.getParameter("officerUserId");
        String remarks = req.getParameter("remarks");

        if (complaintIdParam == null || complaintIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/officer/complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdParam.trim());
            Integer deptId = (deptIdParam != null && !deptIdParam.trim().isEmpty()) ? Integer.parseInt(deptIdParam.trim()) : null;
            Integer officerUserId = (officerUserIdParam != null && !officerUserIdParam.trim().isEmpty()) ? Integer.parseInt(officerUserIdParam.trim()) : null;

            boolean success = complaintDAO.assignDepartmentAndOfficer(complaintId, deptId, officerUserId, user.getUserId(), remarks);

            if (success) {
                session.setAttribute("successMessage", "Complaint department/officer reassigned successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to assign complaint.");
            }
            resp.sendRedirect(req.getContextPath() + "/officer/complaint-details?id=" + complaintId);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/officer/complaints");
        }
    }
}

