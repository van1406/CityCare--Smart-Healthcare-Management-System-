package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.DepartmentDAO;
import com.citycare.dao.OfficerDAO;
import com.citycare.model.Complaint;
import com.citycare.model.ComplaintHistory;
import com.citycare.model.Department;
import com.citycare.model.Officer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OfficerComplaintDetailServlet", urlPatterns = {"/officer/complaint-details"})
public class OfficerComplaintDetailServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;
    private DepartmentDAO departmentDAO;
    private OfficerDAO officerDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        departmentDAO = new DepartmentDAO();
        officerDAO = new OfficerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/officer/complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(idParam.trim());
            Complaint complaint = complaintDAO.getComplaintById(complaintId);

            if (complaint == null) {
                req.setAttribute("errorMessage", "Complaint record not found.");
                req.getRequestDispatcher("/officer/complaints").forward(req, resp);
                return;
            }

            List<ComplaintHistory> history = complaintDAO.getComplaintHistory(complaintId);
            List<Department> departments = departmentDAO.getAllDepartments();
            List<Officer> officers = officerDAO.getAllOfficers();

            req.setAttribute("complaint", complaint);
            req.setAttribute("history", history);
            req.setAttribute("departments", departments);
            req.setAttribute("officers", officers);

            req.getRequestDispatcher("/officer/complaint-details.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/officer/complaints");
        }
    }
}

