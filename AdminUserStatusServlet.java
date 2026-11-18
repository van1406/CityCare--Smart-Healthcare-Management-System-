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

@WebServlet(name = "AdminUserStatusServlet", urlPatterns = {"/admin/user-status"})
public class AdminUserStatusServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        String userIdParam = req.getParameter("userId");
        String action = req.getParameter("action"); // activate, deactivate, delete
        String returnUrl = req.getParameter("returnUrl");

        if (returnUrl == null || returnUrl.trim().isEmpty()) {
            returnUrl = req.getContextPath() + "/admin/citizens";
        }

        if (userIdParam == null || userIdParam.trim().isEmpty() || action == null) {
            resp.sendRedirect(returnUrl);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam.trim());

            if (userId == currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Action not allowed on your own administrator account.");
                resp.sendRedirect(returnUrl);
                return;
            }

            if ("deactivate".equalsIgnoreCase(action)) {
                userDAO.updateUserStatus(userId, "INACTIVE");
                session.setAttribute("successMessage", "User account deactivated successfully.");
            } else if ("activate".equalsIgnoreCase(action)) {
                userDAO.updateUserStatus(userId, "ACTIVE");
                session.setAttribute("successMessage", "User account activated successfully.");
            } else if ("delete".equalsIgnoreCase(action)) {
                userDAO.deleteUser(userId);
                session.setAttribute("successMessage", "User account deleted successfully.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid user ID.");
        }

        resp.sendRedirect(returnUrl);
    }
}

