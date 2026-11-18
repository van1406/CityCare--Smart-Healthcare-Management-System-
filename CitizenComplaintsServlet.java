package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.Complaint;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "CitizenComplaintsServlet", urlPatterns = {"/citizen/my-complaints"})
public class CitizenComplaintsServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        String statusFilter = req.getParameter("status");
        String categoryFilter = req.getParameter("category");
        String search = req.getParameter("search");

        List<Complaint> complaints = complaintDAO.getComplaintsByCitizen(user.getUserId());

        // Apply client filter in-memory for citizen list
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            complaints = complaints.stream()
                    .filter(c -> c.getStatus().equalsIgnoreCase(statusFilter.trim()))
                    .collect(Collectors.toList());
        }

        if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !categoryFilter.equalsIgnoreCase("ALL")) {
            complaints = complaints.stream()
                    .filter(c -> c.getCategory().equalsIgnoreCase(categoryFilter.trim()))
                    .collect(Collectors.toList());
        }

        if (search != null && !search.trim().isEmpty()) {
            String lowerSearch = search.trim().toLowerCase();
            complaints = complaints.stream()
                    .filter(c -> c.getTrackingId().toLowerCase().contains(lowerSearch) ||
                                 c.getTitle().toLowerCase().contains(lowerSearch) ||
                                 c.getLocation().toLowerCase().contains(lowerSearch) ||
                                 c.getDescription().toLowerCase().contains(lowerSearch))
                    .collect(Collectors.toList());
        }

        req.setAttribute("complaints", complaints);
        req.setAttribute("selectedStatus", statusFilter);
        req.setAttribute("selectedCategory", categoryFilter);
        req.setAttribute("searchKeyword", search);

        req.getRequestDispatcher("/citizen/my-complaints.jsp").forward(req, resp);
    }
}

