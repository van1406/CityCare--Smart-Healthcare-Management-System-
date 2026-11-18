<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<User> citizens = (List<User>) request.getAttribute("citizens");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Citizens – CityCare Admin</title>
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
                    <a href="<%= request.getContextPath() %>/admin/citizens" class="sidebar-link active">
                        <span class="sidebar-icon"><i class="fa-solid fa-users"></i></span>
                        <span>Registered Citizens</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/officers" class="sidebar-link">
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
                    <h1 class="page-title">Registered Citizen Directory</h1>
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

                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fa-solid fa-users" style="color: var(--primary);"></i> Citizen Accounts (<%= citizens != null ? citizens.size() : 0 %>)
                        </h2>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Citizen Name</th>
                                        <th>Contact Details</th>
                                        <th>Registered Address</th>
                                        <th>Registered On</th>
                                        <th>Account Status</th>
                                        <th>Admin Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (citizens != null && !citizens.isEmpty()) { 
                                        for (User c : citizens) {
                                            boolean isActive = "ACTIVE".equalsIgnoreCase(c.getStatus());
                                    %>
                                        <tr>
                                            <td>
                                                <div style="font-weight: 700; color: var(--slate-900);"><%= c.getFullName() %></div>
                                                <span style="font-size: 0.78rem; color: var(--slate-400);">ID: #<%= c.getUserId() %></span>
                                            </td>
                                            <td>
                                                <div><i class="fa-solid fa-envelope" style="color: var(--slate-400); font-size: 0.8rem;"></i> <%= c.getEmail() %></div>
                                                <div style="font-size: 0.82rem; color: var(--slate-600);"><i class="fa-solid fa-phone" style="color: var(--slate-400); font-size: 0.8rem;"></i> <%= c.getPhone() %></div>
                                            </td>
                                            <td><%= c.getAddress() %></td>
                                            <td><%= sdf.format(c.getCreatedAt()) %></td>
                                            <td>
                                                <span class="badge <%= isActive ? "badge-active" : "badge-inactive" %>">
                                                    <%= c.getStatus() %>
                                                </span>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 0.4rem;">
                                                    <form action="<%= request.getContextPath() %>/admin/user-status" method="post" style="display: inline;">
                                                        <input type="hidden" name="userId" value="<%= c.getUserId() %>">
                                                        <input type="hidden" name="returnUrl" value="<%= request.getContextPath() %>/admin/citizens">
                                                        <input type="hidden" name="action" value="<%= isActive ? "deactivate" : "activate" %>">
                                                        <button type="submit" class="btn btn-outline btn-sm" title="<%= isActive ? "Deactivate" : "Activate" %>">
                                                            <% if (isActive) { %>
                                                                <i class="fa-solid fa-ban" style="color: var(--warning);"></i> Deactivate
                                                            <% } else { %>
                                                                <i class="fa-solid fa-check" style="color: var(--success);"></i> Activate
                                                            <% } %>
                                                        </button>
                                                    </form>

                                                    <form action="<%= request.getContextPath() %>/admin/user-status" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to permanently delete this citizen account and all associated data?');">
                                                        <input type="hidden" name="userId" value="<%= c.getUserId() %>">
                                                        <input type="hidden" name="returnUrl" value="<%= request.getContextPath() %>/admin/citizens">
                                                        <input type="hidden" name="action" value="delete">
                                                        <button type="submit" class="btn btn-outline btn-sm" style="color: var(--danger);" title="Delete User">
                                                            <i class="fa-solid fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    <%  } 
                                    } else { %>
                                        <tr>
                                            <td colspan="6" style="text-align: center; padding: 3rem; color: var(--slate-500);">
                                                No citizens registered yet.
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

