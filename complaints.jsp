<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigned Tasks – CityCare Officer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <div class="dashboard-layout">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="brand-icon"><i class="fa-solid fa-city"></i></div>
                <div>
                    <div class="sidebar-brand-name">City<span>Care</span></div>
                    <span class="sidebar-role-badge">Officer Desk</span>
                </div>
            </div>

            <ul class="sidebar-nav">
                <li class="sidebar-section-title">Navigation</li>
                <li>
                    <a href="<%= request.getContextPath() %>/officer/dashboard" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-gauge-high"></i></span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/officer/complaints" class="sidebar-link active">
                        <span class="sidebar-icon"><i class="fa-solid fa-clipboard-list"></i></span>
                        <span>Assigned Tasks</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/officer/complaints?status=Resolved" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-circle-check"></i></span>
                        <span>Resolved Archive</span>
                    </a>
                </li>
            </ul>

            <div class="sidebar-footer">
                <div class="user-profile-pill">
                    <div class="user-avatar" style="background: linear-gradient(135deg, var(--secondary), var(--primary-light));">
                        <%= user.getFullName().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="user-details">
                        <div class="user-name"><%= user.getFullName() %></div>
                        <div class="user-email"><%= user.getEmail() %></div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Body -->
        <main class="main-content">
            <header class="topbar">
                <div class="topbar-left">
                    <h1 class="page-title">Assigned Field Complaints</h1>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                    </a>
                </div>
            </header>

            <div class="content-body">

                <!-- Filter Bar -->
                <form action="<%= request.getContextPath() %>/officer/complaints" method="get" class="filter-bar">
                    <div class="filter-group">
                        <label style="font-size: 0.85rem; font-weight: 600; color: var(--slate-600);"><i class="fa-solid fa-filter"></i> Status:</label>
                        <select name="status" class="form-control" onchange="this.form.submit()">
                            <option value="ALL">All Statuses</option>
                            <option value="Assigned" <%= "Assigned".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Assigned</option>
                            <option value="In Progress" <%= "In Progress".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>In Progress</option>
                            <option value="Under Review" <%= "Under Review".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Under Review</option>
                            <option value="Resolved" <%= "Resolved".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Resolved</option>
                            <option value="Rejected" <%= "Rejected".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Rejected</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label style="font-size: 0.85rem; font-weight: 600; color: var(--slate-600);">Category:</label>
                        <select name="category" class="form-control" onchange="this.form.submit()">
                            <option value="ALL">All Categories</option>
                            <option value="Potholes and damaged roads" <%= "Potholes and damaged roads".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Potholes & Roads</option>
                            <option value="Overflowing garbage bins" <%= "Overflowing garbage bins".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Garbage & Sanitation</option>
                            <option value="Damaged streetlights" <%= "Damaged streetlights".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Streetlights</option>
                            <option value="Water leakage" <%= "Water leakage".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Water Leakage</option>
                            <option value="Drainage and sewage problems" <%= "Drainage and sewage problems".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Drainage & Sewage</option>
                            <option value="Other civic issues" <%= "Other civic issues".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Other Civic Issues</option>
                        </select>
                    </div>

                    <div class="filter-group" style="flex: 2;">
                        <input type="text" name="search" class="form-control" placeholder="Search by tracking ID, keyword, citizen..." value="<%= searchKeyword != null ? searchKeyword : "" %>">
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-search"></i> Search
                    </button>
                    <% if (selectedStatus != null || selectedCategory != null || searchKeyword != null) { %>
                        <a href="<%= request.getContextPath() %>/officer/complaints" class="btn btn-outline btn-sm">Reset</a>
                    <% } %>
                </form>

                <!-- Complaints Table -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fa-solid fa-clipboard-list" style="color: var(--secondary);"></i> Assigned Tasks (<%= complaints != null ? complaints.size() : 0 %>)
                        </h2>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Tracking ID</th>
                                        <th>Title & Category</th>
                                        <th>Citizen Details</th>
                                        <th>Location</th>
                                        <th>Priority</th>
                                        <th>Submitted</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (complaints != null && !complaints.isEmpty()) { 
                                        for (Complaint c : complaints) {
                                            String statusBadgeClass = "badge-submitted";
                                            String st = c.getStatus().toLowerCase();
                                            if (st.contains("review")) statusBadgeClass = "badge-under-review";
                                            else if (st.contains("assigned")) statusBadgeClass = "badge-assigned";
                                            else if (st.contains("progress")) statusBadgeClass = "badge-in-progress";
                                            else if (st.contains("resolved")) statusBadgeClass = "badge-resolved";
                                            else if (st.contains("rejected")) statusBadgeClass = "badge-rejected";

                                            String priorityClass = "priority-medium";
                                            if ("Low".equalsIgnoreCase(c.getPriority())) priorityClass = "priority-low";
                                            else if ("High".equalsIgnoreCase(c.getPriority())) priorityClass = "priority-high";
                                            else if ("Urgent".equalsIgnoreCase(c.getPriority())) priorityClass = "priority-urgent";
                                    %>
                                        <tr>
                                            <td>
                                                <span class="tracking-code"><%= c.getTrackingId() %></span>
                                            </td>
                                            <td>
                                                <div style="font-weight: 700; color: var(--slate-900);"><%= c.getTitle() %></div>
                                                <span style="font-size: 0.8rem; color: var(--slate-500);"><%= c.getCategory() %></span>
                                            </td>
                                            <td>
                                                <div style="font-weight: 600;"><%= c.getCitizenName() %></div>
                                                <div style="font-size: 0.78rem; color: var(--slate-500);"><i class="fa-solid fa-phone"></i> <%= c.getCitizenPhone() %></div>
                                            </td>
                                            <td><i class="fa-solid fa-location-dot" style="color: var(--danger); font-size: 0.8rem;"></i> <%= c.getLocation() %></td>
                                            <td>
                                                <span class="priority-pill <%= priorityClass %>"><%= c.getPriority() %></span>
                                            </td>
                                            <td><%= sdf.format(c.getCreatedAt()) %></td>
                                            <td>
                                                <span class="badge <%= statusBadgeClass %>"><%= c.getStatus() %></span>
                                            </td>
                                            <td>
                                                <a href="<%= request.getContextPath() %>/officer/complaint-details?id=<%= c.getComplaintId() %>" class="btn btn-primary btn-sm">
                                                    <i class="fa-solid fa-gear"></i> Manage
                                                </a>
                                            </td>
                                        </tr>
                                    <%  } 
                                    } else { %>
                                        <tr>
                                            <td colspan="8" style="text-align: center; padding: 3rem; color: var(--slate-500);">
                                                <i class="fa-solid fa-inbox" style="font-size: 2.5rem; color: var(--slate-300); margin-bottom: 0.75rem; display: block;"></i>
                                                No complaints found matching current filter parameters.
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

