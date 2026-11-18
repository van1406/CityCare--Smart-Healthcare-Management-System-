<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint – CityCare</title>
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
                    <span class="sidebar-role-badge">Citizen Portal</span>
                </div>
            </div>

            <ul class="sidebar-nav">
                <li class="sidebar-section-title">Navigation</li>
                <li>
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-gauge-high"></i></span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="sidebar-link active">
                        <span class="sidebar-icon"><i class="fa-solid fa-file-circle-plus"></i></span>
                        <span>Submit Complaint</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-list-check"></i></span>
                        <span>My Complaints</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/track" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <span>Track Reference</span>
                    </a>
                </li>
            </ul>

            <div class="sidebar-footer">
                <div class="user-profile-pill">
                    <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                    <div class="user-details">
                        <div class="user-name"><%= user.getFullName() %></div>
                        <div class="user-email"><%= user.getEmail() %></div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="topbar">
                <div class="topbar-left">
                    <h1 class="page-title">Submit Civic Complaint</h1>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </header>

            <div class="content-body" style="max-width: 900px;">

                <% String error = (String) request.getAttribute("errorMessage"); %>
                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <span><i class="fa-solid fa-circle-exclamation"></i> <%= error %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fa-solid fa-bullhorn" style="color: var(--primary);"></i> Complaint Registration Details
                        </h2>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/citizen/submit-complaint" method="post" enctype="multipart/form-data">
                            
                            <div class="form-group">
                                <label class="form-label" for="title">Complaint Title / Summary <span class="required">*</span></label>
                                <input type="text" id="title" name="title" class="form-control" placeholder="e.g. Deep pothole near Ring Road signal" value="<%= request.getAttribute("title") != null ? request.getAttribute("title") : "" %>" required>
                                <span class="form-hint">Provide a concise, descriptive title for quick identification.</span>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem;">
                                <div class="form-group">
                                    <label class="form-label" for="category">Category <span class="required">*</span></label>
                                    <select id="category" name="category" class="form-control" required onchange="autoSelectDept()">
                                        <option value="">-- Select Problem Category --</option>
                                        <option value="Potholes and damaged roads">Potholes and damaged roads</option>
                                        <option value="Overflowing garbage bins">Overflowing garbage bins</option>
                                        <option value="Damaged streetlights">Damaged streetlights</option>
                                        <option value="Water leakage">Water leakage</option>
                                        <option value="Drainage and sewage problems">Drainage and sewage problems</option>
                                        <option value="Other civic issues">Other civic issues</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="departmentId">Target Department (Optional)</label>
                                    <select id="departmentId" name="departmentId" class="form-control">
                                        <option value="">-- Auto-Route by Category --</option>
                                        <% if (departments != null) { 
                                            for (Department d : departments) { %>
                                                <option value="<%= d.getDepartmentId() %>"><%= d.getDepartmentName() %></option>
                                        <%  } 
                                        } %>
                                    </select>
                                    <span class="form-hint">Leave blank to let system automatically route to the right department.</span>
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.25rem;">
                                <div class="form-group">
                                    <label class="form-label" for="location">Location / Landmark Address <span class="required">*</span></label>
                                    <input type="text" id="location" name="location" class="form-control" placeholder="e.g. Opp. Metro Pillar 142, MG Road, Ward 12" value="<%= request.getAttribute("location") != null ? request.getAttribute("location") : "" %>" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="priority">Urgency / Severity</label>
                                    <select id="priority" name="priority" class="form-control">
                                        <option value="Low">Low</option>
                                        <option value="Medium" selected>Medium</option>
                                        <option value="High">High</option>
                                        <option value="Urgent">Urgent (Safety Hazard)</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="descriptionTextarea">
                                    Detailed Problem Description <span class="required">*</span>
                                    <span style="float: right; font-weight: normal; color: var(--slate-400); font-size: 0.8rem;">
                                        Characters: <span id="charCount">0</span>
                                    </span>
                                </label>
                                <textarea id="descriptionTextarea" name="description" class="form-control" style="min-height: 120px;" placeholder="Provide thorough details: how long the problem has existed, exact hazard, frequency, etc." required><%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %></textarea>
                            </div>

                            <!-- Optional Image Attachment -->
                            <div class="form-group">
                                <label class="form-label" for="imageInput">
                                    <i class="fa-solid fa-camera"></i> Upload Photo Evidence (Optional)
                                </label>
                                <input type="file" id="imageInput" name="image" class="form-control" accept="image/jpeg,image/png,image/webp,image/gif">
                                <span class="form-hint">Accepted formats: JPG, PNG, WEBP, GIF. Max file size: 10 MB.</span>

                                <div id="imagePreviewContainer" style="display: none; margin-top: 1rem;">
                                    <span style="font-size: 0.8rem; font-weight: 700; color: var(--slate-600); display: block; margin-bottom: 0.35rem;">Preview:</span>
                                    <img id="imagePreview" src="" alt="Selected Photo" style="max-height: 200px; border-radius: var(--radius); border: 1px solid var(--slate-300);">
                                </div>
                            </div>

                            <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fa-solid fa-paper-plane"></i> Submit Grievance
                                </button>
                                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="btn btn-outline btn-lg">
                                    Cancel
                                </a>
                            </div>

                        </form>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
    <script>
        function autoSelectDept() {
            const cat = document.getElementById('category').value.toLowerCase();
            const deptSelect = document.getElementById('departmentId');
            if (cat.includes('road') || cat.includes('pothole')) {
                deptSelect.value = '1';
            } else if (cat.includes('garbage') || cat.includes('sanitation')) {
                deptSelect.value = '2';
            } else if (cat.includes('water')) {
                deptSelect.value = '3';
            } else if (cat.includes('light') || cat.includes('electric')) {
                deptSelect.value = '4';
            } else if (cat.includes('drain') || cat.includes('sew')) {
                deptSelect.value = '5';
            }
        }
    </script>
</body>
</html>

