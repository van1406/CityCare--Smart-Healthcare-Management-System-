<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.ComplaintHistory" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    List<ComplaintHistory> history = (List<ComplaintHistory>) request.getAttribute("history");
    Boolean notFound = (Boolean) request.getAttribute("notFound");
    String searchedId = (String) request.getAttribute("searchedTrackingId");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Complaint – CityCare</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <!-- Public Navigation Bar -->
    <header class="public-navbar">
        <div class="nav-container">
            <a href="<%= request.getContextPath() %>/" class="brand-logo">
                <div class="brand-icon"><i class="fa-solid fa-city"></i></div>
                <div>
                    <div class="brand-name">City<span>Care</span></div>
                    <span class="brand-tagline">Smart Municipal Governance</span>
                </div>
            </a>
            
            <nav>
                <ul class="nav-links">
                    <li><a href="<%= request.getContextPath() %>/#categories">Civic Services</a></li>
                    <li><a href="<%= request.getContextPath() %>/track" style="color: var(--primary-light); font-weight: 700;">Track Complaint</a></li>
                </ul>
            </nav>

            <div class="nav-actions">
                <% if (loggedInUser != null) { %>
                    <a href="<%= request.getContextPath() %>/<%= loggedInUser.getRole().toLowerCase() %>/dashboard" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-gauge"></i> My Dashboard
                    </a>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-right-to-bracket"></i> Login
                    </a>
                    <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-user-plus"></i> Register
                    </a>
                <% } %>
            </div>
        </div>
    </header>

    <div class="section-container" style="padding: 2.5rem 1.5rem; max-width: 900px;">
        
        <div class="card" style="margin-bottom: 2rem;">
            <div class="card-header" style="background: linear-gradient(135deg, var(--slate-900), var(--primary)); color: var(--white);">
                <h3 class="card-title" style="color: var(--white);">
                    <i class="fa-solid fa-magnifying-glass-location"></i> Live Civic Complaint Tracker
                </h3>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/track" method="get">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="trackingId">Enter Complaint Tracking ID:</label>
                        <div style="display: flex; gap: 0.75rem;">
                            <input type="text" id="trackingId" name="trackingId" class="form-control" placeholder="e.g. CC-2026-1001" value="<%= request.getParameter("trackingId") != null ? request.getParameter("trackingId") : "" %>" required style="font-family: 'JetBrains Mono', monospace; font-size: 1rem;">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa-solid fa-search"></i> Check Status
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <% if (notFound != null && notFound) { %>
            <div class="alert alert-danger">
                <span><i class="fa-solid fa-triangle-exclamation"></i> No complaint found with Tracking ID "<strong><%= searchedId %></strong>". Please verify the reference ID and try again.</span>
            </div>
        <% } %>

        <% if (complaint != null) { 
            String statusBadgeClass = "badge-submitted";
            String st = complaint.getStatus().toLowerCase();
            if (st.contains("review")) statusBadgeClass = "badge-under-review";
            else if (st.contains("assigned")) statusBadgeClass = "badge-assigned";
            else if (st.contains("progress")) statusBadgeClass = "badge-in-progress";
            else if (st.contains("resolved")) statusBadgeClass = "badge-resolved";
            else if (st.contains("rejected")) statusBadgeClass = "badge-rejected";
        %>
            <div class="card">
                <div class="card-header">
                    <div>
                        <span class="tracking-code" style="font-size: 1rem;"><%= complaint.getTrackingId() %></span>
                        <h2 style="font-size: 1.35rem; font-weight: 800; margin-top: 0.35rem; color: var(--slate-900);"><%= complaint.getTitle() %></h2>
                    </div>
                    <div>
                        <span class="badge <%= statusBadgeClass %>" style="font-size: 0.9rem; padding: 0.4rem 0.85rem;">
                            <i class="fa-solid fa-circle-dot"></i> <%= complaint.getStatus() %>
                        </span>
                    </div>
                </div>

                <div class="card-body">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 1.5rem; background: var(--slate-50); padding: 1.25rem; border-radius: var(--radius);">
                        <div>
                            <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Category</span>
                            <div style="font-weight: 700; color: var(--slate-800);"><%= complaint.getCategory() %></div>
                        </div>
                        <div>
                            <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Department</span>
                            <div style="font-weight: 700; color: var(--slate-800);"><%= complaint.getDepartmentName() != null ? complaint.getDepartmentName() : "Under Review" %></div>
                        </div>
                        <div>
                            <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Location</span>
                            <div style="font-weight: 600; color: var(--slate-800);"><i class="fa-solid fa-location-dot" style="color: var(--danger);"></i> <%= complaint.getLocation() %></div>
                        </div>
                        <div>
                            <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Submitted On</span>
                            <div style="font-weight: 600; color: var(--slate-700);"><%= sdf.format(complaint.getCreatedAt()) %></div>
                        </div>
                    </div>

                    <div style="margin-bottom: 1.5rem;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; margin-bottom: 0.4rem; color: var(--slate-800);">Description of Grievance</h4>
                        <p style="color: var(--slate-700); white-space: pre-line; background: #fff; border: 1px solid var(--slate-200); padding: 1rem; border-radius: var(--radius);"><%= complaint.getDescription() %></p>
                    </div>

                    <% if (complaint.getImagePath() != null && !complaint.getImagePath().trim().isEmpty()) { %>
                        <div style="margin-bottom: 1.75rem;">
                            <h4 style="font-size: 0.95rem; font-weight: 700; margin-bottom: 0.5rem; color: var(--slate-800);">Photo Evidence</h4>
                            <img src="<%= request.getContextPath() %>/view-image?file=<%= complaint.getImagePath() %>" alt="Complaint Evidence" style="max-width: 100%; max-height: 350px; border-radius: var(--radius); border: 1px solid var(--slate-200); box-shadow: var(--shadow-sm);">
                        </div>
                    <% } %>

                    <!-- Resolution Timeline & Audit History -->
                    <h3 style="font-size: 1.15rem; font-weight: 800; border-bottom: 2px solid var(--slate-100); padding-bottom: 0.5rem; margin-top: 2rem;">
                        <i class="fa-solid fa-clock-rotate-left"></i> Status Update History
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
                                                <span style="font-size: 0.75rem; background: var(--slate-200); padding: 0.15rem 0.45rem; border-radius: var(--radius-sm); margin-left: 0.35rem; font-weight: 600;"><%= item.getUpdaterRole() %></span>
                                                <span style="margin-left: 0.5rem; font-weight: 700; color: var(--primary);">→ <%= item.getNewStatus() %></span>
                                            </div>
                                            <span class="timeline-date"><i class="fa-regular fa-clock"></i> <%= sdf.format(item.getUpdatedAt()) %></span>
                                        </div>
                                        <div class="timeline-remarks"><%= item.getRemarks() %></div>
                                    </div>
                                </div>
                        <%  } 
                        } else { %>
                            <p style="color: var(--slate-500);">No history updates recorded yet.</p>
                        <% } %>
                    </div>

                </div>
            </div>
        <% } %>

    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

