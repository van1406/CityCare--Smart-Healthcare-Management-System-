<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Officer" %>
<%@ page import="com.citycare.model.DashboardStats" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    Officer officer = (Officer) request.getAttribute("officer");
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Officer Dashboard – CityCare</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <!-- Purple radial navigation menu (isolated to the dashboards) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/radial-menu.css">
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
                    <a href="<%= request.getContextPath() %>/officer/dashboard" class="sidebar-link active">
                        <span class="sidebar-icon"><i class="fa-solid fa-gauge-high"></i></span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/officer/complaints" class="sidebar-link">
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
                        <div class="user-email"><%= officer != null ? officer.getDepartmentName() : "Municipal Officer" %></div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Body -->
        <main class="main-content">
            <header class="topbar">
                <div class="topbar-left">
                    <h1 class="page-title">Officer Command Desk</h1>
                    <% if (officer != null) { %>
                        <span style="font-size: 0.82rem; background: var(--secondary-bg); color: var(--secondary); padding: 0.25rem 0.65rem; border-radius: var(--radius-full); font-weight: 700; border: 1px solid var(--secondary-light);">
                            <i class="fa-solid fa-building-user"></i> <%= officer.getDepartmentName() %> | <%= officer.getDesignation() %>
                        </span>
                    <% } %>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                    </a>
                </div>
            </header>

            <div class="content-body">

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-primary">
                            <i class="fa-solid fa-inbox"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getTotalComplaints() : 0 %></div>
                            <div class="stat-label">Total Assigned</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-warning">
                            <i class="fa-solid fa-bell"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getAssignedComplaints() : 0 %></div>
                            <div class="stat-label">Awaiting Action</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-info">
                            <i class="fa-solid fa-person-digging"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getInProgressComplaints() : 0 %></div>
                            <div class="stat-label">Work In Progress</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-success">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getResolvedComplaints() : 0 %></div>
                            <div class="stat-label">Resolved by You</div>
                        </div>
                    </div>
                </div>

                <!-- Recent Assigned Complaints -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fa-solid fa-list-check" style="color: var(--secondary);"></i> Active Field Complaints
                        </h2>
                        <a href="<%= request.getContextPath() %>/officer/complaints" class="btn btn-outline btn-sm">
                            View All <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Tracking ID</th>
                                        <th>Grievance Details</th>
                                        <th>Citizen</th>
                                        <th>Location</th>
                                        <th>Priority</th>
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
                                                <span style="font-size: 0.78rem; color: var(--slate-500);"><%= c.getCitizenPhone() %></span>
                                            </td>
                                            <td><i class="fa-solid fa-location-dot" style="color: var(--danger); font-size: 0.8rem;"></i> <%= c.getLocation() %></td>
                                            <td>
                                                <span class="priority-pill <%= priorityClass %>"><%= c.getPriority() %></span>
                                            </td>
                                            <td>
                                                <span class="badge <%= statusBadgeClass %>"><%= c.getStatus() %></span>
                                            </td>
                                            <td>
                                                <a href="<%= request.getContextPath() %>/officer/complaint-details?id=<%= c.getComplaintId() %>" class="btn btn-primary btn-sm">
                                                    <i class="fa-solid fa-pen-to-square"></i> Manage
                                                </a>
                                            </td>
                                        </tr>
                                    <%  } 
                                    } else { %>
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 3rem; color: var(--slate-500);">
                                                <i class="fa-solid fa-circle-check" style="font-size: 2.5rem; color: var(--success); margin-bottom: 0.75rem; display: block;"></i>
                                                Great job! You have no outstanding complaints pending your attention.
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

    <!-- Purple Radial Quick Navigation (visual enhancement, existing sidebar kept) -->
    <div class="radial-dock" role="navigation" aria-label="Quick navigation">
        <div class="radial-bar">
            <a class="radial-item active" href="<%= request.getContextPath() %>/officer/dashboard">
                <i class="fa-solid fa-house"></i>
                <span>Home</span>
            </a>
            <a class="radial-item" href="<%= request.getContextPath() %>/officer/complaints">
                <i class="fa-solid fa-clipboard-list"></i>
                <span>Tasks</span>
            </a>
            <div class="radial-home-dot"></div>
        </div>

        <div class="radial-nav">
            <input type="checkbox" id="radial-menu-toggle" class="radial-toggle">
            <label for="radial-menu-toggle" class="radial-fab" title="Open quick menu" aria-label="Open quick menu">
                <span class="bar h"></span>
                <span class="bar v"></span>
            </label>

            <a class="radial-action ra-1" href="<%= request.getContextPath() %>/officer/dashboard" title="Dashboard" aria-label="Dashboard">
                <i class="fa-solid fa-gauge-high"></i>
            </a>
            <a class="radial-action ra-2" href="<%= request.getContextPath() %>/officer/complaints" title="Assigned Tasks" aria-label="Assigned Tasks">
                <i class="fa-solid fa-clipboard-list"></i>
            </a>
            <a class="radial-action ra-3" href="<%= request.getContextPath() %>/officer/complaints?status=Resolved" title="Resolved Archive" aria-label="Resolved Archive">
                <i class="fa-solid fa-circle-check"></i>
            </a>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
    <script src="<%= request.getContextPath() %>/js/radial-menu.js"></script>
</body>
</html>

