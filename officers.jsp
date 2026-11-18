<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Officer" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Officer> officers = (List<Officer>) request.getAttribute("officers");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Municipal Officers – CityCare Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <div class="dashboard-layout">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="brand-icon" style="background: linear-gradient(135deg, #1e3a8a, #7c3aed);"><i class="fa-solid fa-shield-halved"></i></div>
                <div>
                    <div class="sidebar-brand-name">City<span>Care</span></div>
                    <span class="sidebar-role-badge" style="background: #4c1d95; color: #e9d5ff;">Admin Command</span>
                </div>
            </div>

            <ul class="sidebar-nav">
                <li class="sidebar-section-title">Administration</li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-chart-pie"></i></span>
                        <span>Overview</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/complaints" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-list-check"></i></span>
                        <span>All Complaints</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/citizens" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-users"></i></span>
                        <span>Registered Citizens</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/officers" class="sidebar-link active">
                        <span class="sidebar-icon"><i class="fa-solid fa-user-tie"></i></span>
                        <span>Municipal Officers</span>
                    </a>
                </li>
            </ul>

            <div class="sidebar-footer">
                <div class="user-profile-pill">
                    <div class="user-avatar" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">A</div>
                    <div class="user-details">
                        <div class="user-name"><%= currentUser.getFullName() %></div>
                        <div class="user-email">Administrator</div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Body -->
        <main class="main-content">
            <header class="topbar">
                <div class="topbar-left">
                    <h1 class="page-title">Municipal Officers & Engineers</h1>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                    </a>
                </div>
            </header>

            <div class="content-body">

                <% 
                    String success = (String) session.getAttribute("successMessage");
                    if (success != null) session.removeAttribute("successMessage");
                    String error = (String) session.getAttribute("errorMessage");
                    if (error != null) session.removeAttribute("errorMessage");
                %>
                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <span><i class="fa-solid fa-circle-check"></i> <%= success %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>
                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <span><i class="fa-solid fa-circle-exclamation"></i> <%= error %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 1.5rem; align-items: start;">
                    
                    <!-- Left: Officer Directory Table -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fa-solid fa-user-tie" style="color: var(--primary);"></i> Active Municipal Officers (<%= officers != null ? officers.size() : 0 %>)
                            </h2>
                        </div>
                        <div class="card-body" style="padding: 0;">
                            <div class="table-responsive">
                                <table class="custom-table">
                                    <thead>
                                        <tr>
                                            <th>Officer Name</th>
                                            <th>Department</th>
                                            <th>Designation</th>
                                            <th>Contact</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (officers != null && !officers.isEmpty()) { 
                                            for (Officer o : officers) {
                                                boolean isActive = "ACTIVE".equalsIgnoreCase(o.getStatus());
                                        %>
                                            <tr>
                                                <td>
                                                    <div style="font-weight: 700; color: var(--slate-900);"><%= o.getFullName() %></div>
                                                    <span style="font-size: 0.75rem; color: var(--slate-400);">ID: #<%= o.getOfficerId() %></span>
                                                </td>
                                                <td>
                                                    <span style="font-weight: 600; color: var(--secondary);"><%= o.getDepartmentName() %></span>
                                                </td>
                                                <td><%= o.getDesignation() %></td>
                                                <td>
                                                    <div style="font-size: 0.8rem;"><i class="fa-solid fa-envelope"></i> <%= o.getEmail() %></div>
                                                    <div style="font-size: 0.8rem;"><i class="fa-solid fa-phone"></i> <%= o.getPhone() %></div>
                                                </td>
                                                <td>
                                                    <span class="badge <%= isActive ? "badge-active" : "badge-inactive" %>">
                                                        <%= o.getStatus() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <form action="<%= request.getContextPath() %>/admin/user-status" method="post" style="display: inline;">
                                                        <input type="hidden" name="userId" value="<%= o.getUserId() %>">
                                                        <input type="hidden" name="returnUrl" value="<%= request.getContextPath() %>/admin/officers">
                                                        <input type="hidden" name="action" value="<%= isActive ? "deactivate" : "activate" %>">
                                                        <button type="submit" class="btn btn-outline btn-sm" title="<%= isActive ? "Deactivate" : "Activate" %>">
                                                            <% if (isActive) { %>
                                                                <i class="fa-solid fa-ban" style="color: var(--warning);"></i>
                                                            <% } else { %>
                                                                <i class="fa-solid fa-check" style="color: var(--success);"></i>
                                                            <% } %>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        <%  } 
                                        } else { %>
                                            <tr>
                                                <td colspan="6" style="text-align: center; padding: 2rem;">No officers configured.</td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Add New Officer Form -->
                    <div class="card">
                        <div class="card-header" style="background: var(--primary-bg);">
                            <h3 class="card-title" style="color: var(--primary);">
                                <i class="fa-solid fa-user-plus"></i> Add New Municipal Officer
                            </h3>
                        </div>
                        <div class="card-body">
                            <form action="<%= request.getContextPath() %>/admin/officers" method="post">
                                <input type="hidden" name="action" value="add">

                                <div class="form-group">
                                    <label class="form-label" for="fullName">Full Name <span class="required">*</span></label>
                                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="e.g. Vikramaditya Patil" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="email">Official Email <span class="required">*</span></label>
                                    <input type="email" id="email" name="email" class="form-control" placeholder="officer.dept@citycare.gov" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="phone">Phone Number <span class="required">*</span></label>
                                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="10-digit mobile" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="departmentId">Assigned Department <span class="required">*</span></label>
                                    <select id="departmentId" name="departmentId" class="form-control" required>
                                        <option value="">-- Select Department --</option>
                                        <% if (departments != null) { 
                                            for (Department d : departments) { %>
                                                <option value="<%= d.getDepartmentId() %>"><%= d.getDepartmentName() %></option>
                                        <%  } 
                                        } %>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="designation">Designation / Role</label>
                                    <input type="text" id="designation" name="designation" class="form-control" placeholder="e.g. Assistant Executive Engineer">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="password">Initial Password <span class="required">*</span></label>
                                    <input type="password" id="password" name="password" class="form-control" placeholder="Min. 6 chars" required>
                                </div>

                                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 0.5rem;">
                                    <i class="fa-solid fa-plus-circle"></i> Register Municipal Officer
                                </button>
                            </form>
                        </div>
                    </div>

                </div>

            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

