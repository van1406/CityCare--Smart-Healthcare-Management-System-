package com.citycare.controller;

import com.citycare.dao.DepartmentDAO;
import com.citycare.dao.OfficerDAO;
import com.citycare.dao.UserDAO;
import com.citycare.model.Department;
import com.citycare.model.Officer;
import com.citycare.model.User;
import com.citycare.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOfficersServlet", urlPatterns = {"/admin/officers"})
public class AdminOfficersServlet extends HttpServlet {

    private OfficerDAO officerDAO;
    private DepartmentDAO departmentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        officerDAO = new OfficerDAO();
        departmentDAO = new DepartmentDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Officer> officers = officerDAO.getAllOfficers();
        List<Department> departments = departmentDAO.getAllDepartments();

        req.setAttribute("officers", officers);
        req.setAttribute("departments", departments);
        req.getRequestDispatcher("/admin/officers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String action = req.getParameter("action");

        if ("edit".equalsIgnoreCase(action)) {
            String officerIdParam = req.getParameter("officerId");
            String departmentIdParam = req.getParameter("departmentId");
            String designation = req.getParameter("designation");

            try {
                int officerId = Integer.parseInt(officerIdParam.trim());
                int departmentId = Integer.parseInt(departmentIdParam.trim());
                boolean updated = officerDAO.updateOfficer(officerId, departmentId, designation);

                if (updated) {
                    session.setAttribute("successMessage", "Officer details updated successfully.");
                } else {
                    session.setAttribute("errorMessage", "Failed to update officer.");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Invalid officer update data.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/officers");
            return;
        }

        // Add New Officer
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String departmentIdParam = req.getParameter("departmentId");
        String designation = req.getParameter("designation");
        String password = req.getParameter("password");

        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            departmentIdParam == null || departmentIdParam.trim().isEmpty()) {
            session.setAttribute("errorMessage", "All mandatory officer fields must be provided.");
            resp.sendRedirect(req.getContextPath() + "/admin/officers");
            return;
        }

        if (userDAO.emailExists(email)) {
            session.setAttribute("errorMessage", "An account with this email address already exists.");
            resp.sendRedirect(req.getContextPath() + "/admin/officers");
            return;
        }

        try {
            int departmentId = Integer.parseInt(departmentIdParam.trim());

            User newOfficerUser = new User();
            newOfficerUser.setFullName(fullName.trim());
            newOfficerUser.setEmail(email.trim().toLowerCase());
            newOfficerUser.setPhone(phone.trim());
            newOfficerUser.setAddress(address != null ? address.trim() : "Municipal Ward Office");
            newOfficerUser.setPasswordHash(PasswordUtil.hashPassword(password));

            boolean added = officerDAO.addOfficer(newOfficerUser, departmentId, designation);
            if (added) {
                session.setAttribute("successMessage", "Officer " + fullName + " registered and assigned successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to register officer due to a database error.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid department selected.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/officers");
    }
}

