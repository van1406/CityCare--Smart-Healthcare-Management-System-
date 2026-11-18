<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.ComplaintHistory" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="com.citycare.model.Officer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    List<ComplaintHistory> history = (List<ComplaintHistory>) request.getAttribute("history");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    List<Officer> officers = (List<Officer>) request.getAttribute("officers");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    String statusBadgeClass = "badge-submitted";
    String st = complaint.getStatus().toLowerCase();
    if (st.contains("review")) statusBadgeClass = "badge-under-review";
    else if (st.contains("assigned")) statusBadgeClass = "badge-assigned";
    else if (st.contains("progress")) statusBadgeClass = "badge-in-progress";
    else if (st.contains("resolved")) statusBadgeClass = "badge-resolved";
    else if (st.contains("rejected")) statusBadgeClass = "badge-rejected";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Complaint <%= complaint.getTrackingId() %> – Officer</title>
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
                    <h1 class="page-title">Complaint Redressal Console</h1>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/officer/complaints" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-left"></i> Back to Tasks
                    </a>
                </div>
            </header>

            <div class="content-body" style="max-width: 1080px;">

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

                <div style="display: grid; grid-template-columns: 1.3fr 0.9fr; gap: 1.5rem; align-items: start;">
                    
                    <!-- Left: Grievance Details & Citizen Info -->
                    <div>
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <span class="tracking-code"><%= complaint.getTrackingId() %></span>
                                    <h2 style="font-size: 1.25rem; font-weight: 800; margin-top: 0.35rem; color: var(--slate-900);"><%= complaint.getTitle() %></h2>
                                </div>
                                <span class="badge <%= statusBadgeClass %>" style="font-size: 0.88rem; padding: 0.4rem 0.8rem;">
                                    <%= complaint.getStatus() %>
                                </span>
                            </div>

                            <div class="card-body">
                                
                                <!-- Citizen Contact Box -->
                                <div style="background: var(--slate-50); border: 1px solid var(--slate-200); border-radius: var(--radius); padding: 1rem 1.25rem; margin-bottom: 1.25rem;">
                                    <h4 style="font-size: 0.85rem; font-weight: 700; text-transform: uppercase; color: var(--slate-500); margin-bottom: 0.5rem;">
                                        <i class="fa-solid fa-user"></i> Citizen Information
                                    </h4>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; font-size: 0.9rem;">
                                        <div><strong>Name:</strong> <%= complaint.getCitizenName() %></div>
                                        <div><strong>Phone:</strong> <a href="tel:<%= complaint.getCitizenPhone() %>"><i class="fa-solid fa-phone"></i> <%= complaint.getCitizenPhone() %></a></div>
                                        <div><strong>Email:</strong> <%= complaint.getCitizenEmail() %></div>
                                        <div><strong>Location:</strong> <%= complaint.getLocation() %></div>
                                    </div>
                                </div>

                                <div style="margin-bottom: 1.25rem;">
                                    <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--slate-700); margin-bottom: 0.35rem;">Problem Description</h4>
                                    <p style="white-space: pre-line; background: #fff; border: 1px solid var(--slate-200); padding: 1rem; border-radius: var(--radius); font-size: 0.925rem; color: var(--slate-800);"><%= complaint.getDescription() %></p>
                                </div>

                                <% if (complaint.getImagePath() != null && !complaint.getImagePath().trim().isEmpty()) { %>
                                    <div style="margin-bottom: 1.5rem;">
                                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--slate-700); margin-bottom: 0.35rem;">Field Photo Evidence</h4>
                                        <a href="<%= request.getContextPath() %>/view-image?file=<%= complaint.getImagePath() %>" target="_blank">
                                            <img src="<%= request.getContextPath() %>/view-image?file=<%= complaint.getImagePath() %>" alt="Evidence" style="max-width: 100%; max-height: 280px; border-radius: var(--radius); border: 1px solid var(--slate-300);">
                                        </a>
                                    </div>
                                <% } %>

                                <!-- Audit Trail -->
                                <h3 style="font-size: 1.1rem; font-weight: 800; border-bottom: 2px solid var(--slate-100); padding-bottom: 0.5rem; margin-top: 1.5rem;">
                                    <i class="fa-solid fa-clock-rotate-left"></i> Remediation Audit Trail
                                </h3>

                                <div class="timeline">
                                    <% if (history != null && !history.isEmpty()) { 
                                        for (ComplaintHistory item : history) { %>
                                            <div class="timeline-item">
                                                <div class="timeline-dot"></div>
                                                <div class="timeline-content">
                                                    <div class="timeline-header">
                                                        <div>
                                                            <span class="timeline-updater"><%= item.getUpdaterName() %></span>
                                                            <span style="font-size: 0.72rem; background: var(--slate-200); padding: 0.15rem 0.45rem; border-radius: var(--radius-sm); margin-left: 0.35rem; font-weight: 600;"><%= item.getUpdaterRole() %></span>
                                                            <span style="margin-left: 0.5rem; font-weight: 700; color: var(--primary);">→ <%= item.getNewStatus() %></span>
                                                        </div>
                                                        <span class="timeline-date"><%= sdf.format(item.getUpdatedAt()) %></span>
                                                    </div>
                                                    <div class="timeline-remarks"><%= item.getRemarks() %></div>
                                                </div>
                                            </div>
                                    <%  } 
                                    } %>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- Right: Remediation Actions -->
                    <div>
                        <!-- Update Status Form -->
                        <div class="card">
                            <div class="card-header" style="background: var(--secondary-bg);">
                                <h3 class="card-title" style="color: var(--secondary);">
                                    <i class="fa-solid fa-pen-to-square"></i> Update Progress Status
                                </h3>
                            </div>
                            <div class="card-body">
                                <form action="<%= request.getContextPath() %>/officer/update-status" method="post">
                                    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">

                                    <div class="form-group">
                                        <label class="form-label" for="status">New Status <span class="required">*</span></label>
                                        <select id="status" name="status" class="form-control" required>
                                            <option value="In Progress" <%= "In Progress".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>In Progress (Work Underway)</option>
                                            <option value="Resolved" <%= "Resolved".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Resolved (Work Completed)</option>
                                            <option value="Under Review" <%= "Under Review".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Under Review (Inspection Needed)</option>
                                            <option value="Rejected" <%= "Rejected".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Rejected (Invalid / Non-Jurisdiction)</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="remarks">Resolution Remarks / Notes <span class="required">*</span></label>
                                        <textarea id="remarks" name="remarks" class="form-control" style="min-height: 90px;" placeholder="Describe inspection findings, repair actions taken, or materials ordered..." required></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                                        <i class="fa-solid fa-check"></i> Commit Status Update
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Department / Officer Reassignment Form -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <i class="fa-solid fa-share-nodes"></i> Reassign Department
                                </h3>
                            </div>
                            <div class="card-body">
                                <form action="<%= request.getContextPath() %>/officer/assign-department" method="post">
                                    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">

                                    <div class="form-group">
                                        <label class="form-label" for="deptReassign">Target Department</label>
                                        <select id="deptReassign" name="departmentId" class="form-control" required>
                                            <% if (departments != null) { 
                                                for (Department d : departments) { %>
                                                    <option value="<%= d.getDepartmentId() %>" <%= (complaint.getDepartmentId() != null && complaint.getDepartmentId() == d.getDepartmentId()) ? "selected" : "" %>>
                                                        <%= d.getDepartmentName() %>
                                                    </option>
                                            <%  } 
                                            } %>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="reassignRemarks">Reason for Reassignment</label>
                                        <textarea id="reassignRemarks" name="remarks" class="form-control" style="min-height: 70px;" placeholder="e.g. Belongs to Water Supply department rather than Sanitation"></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-outline" style="width: 100%;">
                                        <i class="fa-solid fa-arrows-split-up-and-left"></i> Reassign Task
                                    </button>
                                </form>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

