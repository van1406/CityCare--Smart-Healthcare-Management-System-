package com.citycare.controller;

import com.citycare.dao.UserDAO;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCitizensServlet", urlPatterns = {"/admin/citizens"})
public class AdminCitizensServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> citizens = userDAO.getAllCitizens();
        req.setAttribute("citizens", citizens);
        req.getRequestDispatcher("/admin/citizens.jsp").forward(req, resp);
    }
}

