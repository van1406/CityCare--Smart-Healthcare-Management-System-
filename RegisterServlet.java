package com.citycare.controller;

import com.citycare.dao.UserDAO;
import com.citycare.model.User;
import com.citycare.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Retain form inputs
        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
        req.setAttribute("address", address);

        // Server-side validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Passwords do not match.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.emailExists(email)) {
            req.setAttribute("errorMessage", "An account with this email address already exists.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User newUser = new User();
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPhone(phone.trim());
        newUser.setAddress(address.trim());
        newUser.setPasswordHash(PasswordUtil.hashPassword(password));

        boolean success = userDAO.registerCitizen(newUser);
        if (success) {
            req.getSession(true).setAttribute("successMessage", "Registration successful! You can now log in with your credentials.");
            resp.sendRedirect(req.getContextPath() + "/login.jsp?registered=true");
        } else {
            req.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}

