package com.citycare.controller;

import com.citycare.dao.UserDAO;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login.jsp?logout=true");
            return;
        }

        // Check if user is already logged in
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectToDashboard(resp, req.getContextPath(), user.getRole());
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String selectedRole = req.getParameter("role"); // CITIZEN, OFFICER, ADMIN

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Email and password are required.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(email, password);

        if (user == null) {
            req.setAttribute("errorMessage", "Invalid email or password.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if ("INACTIVE".equalsIgnoreCase(user.getStatus())) {
            req.setAttribute("errorMessage", "Your account has been deactivated. Please contact administrator.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Role verification
        if (selectedRole != null && !selectedRole.trim().isEmpty() && !selectedRole.equalsIgnoreCase(user.getRole())) {
            req.setAttribute("errorMessage", "Access Denied: You cannot log in as " + selectedRole + " with this account.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Establish secure session
        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userRole", user.getRole());

        redirectToDashboard(resp, req.getContextPath(), user.getRole());
    }

    private void redirectToDashboard(HttpServletResponse resp, String contextPath, String role) throws IOException {
        if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(contextPath + "/admin/dashboard");
        } else if ("OFFICER".equalsIgnoreCase(role)) {
            resp.sendRedirect(contextPath + "/officer/dashboard");
        } else {
            resp.sendRedirect(contextPath + "/citizen/dashboard");
        }
    }
}

