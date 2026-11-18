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

@WebServlet(name = "AdminAssignServlet", urlPatterns = {"/admin/assign"})
public class AdminAssignServlet extends HttpServlet {

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
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");

        if (complaintIdParam == null || complaintIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdParam.trim());
            Integer deptId = (deptIdParam != null && !deptIdParam.trim().isEmpty()) ? Integer.parseInt(deptIdParam.trim()) : null;
            Integer officerUserId = (officerUserIdParam != null && !officerUserIdParam.trim().isEmpty()) ? Integer.parseInt(officerUserIdParam.trim()) : null;

            if (status != null && !status.trim().isEmpty()) {
                complaintDAO.updateStatus(complaintId, status.trim(), user.getUserId(), remarks);
            }

            if (deptId != null || officerUserId != null) {
                complaintDAO.assignDepartmentAndOfficer(complaintId, deptId, officerUserId, user.getUserId(), remarks);
            }

            session.setAttribute("successMessage", "Complaint updated and assigned successfully.");
            resp.sendRedirect(req.getContextPath() + "/admin/complaint-details?id=" + complaintId);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/complaints");
        }
    }
}

