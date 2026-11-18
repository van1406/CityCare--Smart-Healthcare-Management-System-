package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.DepartmentDAO;
import com.citycare.model.Complaint;
import com.citycare.model.Department;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OfficerComplaintsServlet", urlPatterns = {"/officer/complaints"})
public class OfficerComplaintsServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        String category = req.getParameter("category");
        String status = req.getParameter("status");
        String search = req.getParameter("search");

        List<Complaint> complaints = complaintDAO.getComplaintsByOfficer(user.getUserId(), category, status, search);
        List<Department> departments = departmentDAO.getAllDepartments();

        req.setAttribute("complaints", complaints);
        req.setAttribute("departments", departments);
        req.setAttribute("selectedCategory", category);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("searchKeyword", search);

        req.getRequestDispatcher("/officer/complaints.jsp").forward(req, resp);
    }
}

