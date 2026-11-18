package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.DepartmentDAO;
import com.citycare.model.Complaint;
import com.citycare.model.Department;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminComplaintsServlet", urlPatterns = {"/admin/complaints"})
public class AdminComplaintsServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String category = req.getParameter("category");
        String status = req.getParameter("status");
        String deptParam = req.getParameter("departmentId");
        String search = req.getParameter("search");

        Integer deptId = null;
        if (deptParam != null && !deptParam.trim().isEmpty() && !deptParam.equalsIgnoreCase("ALL")) {
            try {
                deptId = Integer.parseInt(deptParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Complaint> complaints = complaintDAO.getAllComplaints(category, status, deptId, search);
        List<Department> departments = departmentDAO.getAllDepartments();

        req.setAttribute("complaints", complaints);
        req.setAttribute("departments", departments);
        req.setAttribute("selectedCategory", category);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("selectedDept", deptParam);
        req.setAttribute("searchKeyword", search);

        req.getRequestDispatcher("/admin/complaints.jsp").forward(req, resp);
    }
}

