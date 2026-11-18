<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citizen Registration – CityCare</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <div class="auth-wrapper">
        <div class="auth-card" style="max-width: 560px;">
            <div class="auth-header">
                <div class="brand-icon" style="margin: 0 auto 0.75rem;"><i class="fa-solid fa-user-plus"></i></div>
                <h2>Citizen Registration</h2>
                <p>Create your citizen profile to report and track civic complaints</p>
            </div>

            <div class="auth-body">

                <% String error = (String) request.getAttribute("errorMessage"); %>
                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <span><i class="fa-solid fa-circle-exclamation"></i> <%= error %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <form id="registerForm" action="<%= request.getContextPath() %>/register" method="post">
                    
                    <div class="form-group">
                        <label class="form-label" for="fullName">Full Name <span class="required">*</span></label>
                        <input type="text" id="fullName" name="fullName" class="form-control" placeholder="e.g. Ramesh Kumar" value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>" required>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label class="form-label" for="email">Email Address <span class="required">*</span></label>
                            <input type="email" id="email" name="email" class="form-control" placeholder="ramesh@example.com" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="phone">Phone Number <span class="required">*</span></label>
                            <input type="tel" id="phone" name="phone" class="form-control" placeholder="10-digit Mobile" maxlength="10" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="address">Residential Address / Ward <span class="required">*</span></label>
                        <textarea id="address" name="address" class="form-control" style="min-height: 70px;" placeholder="House/Flat No., Street, Ward, Area" required><%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %></textarea>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label class="form-label" for="password">Password <span class="required">*</span></label>
                            <input type="password" id="password" name="password" class="form-control" placeholder="Min. 6 chars" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="confirmPassword">Confirm Password <span class="required">*</span></label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Repeat password" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.75rem; font-size: 1rem; margin-top: 0.5rem;">
                        <i class="fa-solid fa-id-card"></i> Complete Registration
                    </button>
                </form>

                <div style="margin-top: 1.25rem; text-align: center; font-size: 0.9rem;">
                    Already have an account? <a href="<%= request.getContextPath() %>/login.jsp" style="font-weight: 700;">Sign in here</a>
                </div>

                <div style="text-align: center; margin-top: 1.25rem;">
                    <a href="<%= request.getContextPath() %>/" style="font-size: 0.85rem; color: var(--slate-500);">
                        <i class="fa-solid fa-arrow-left"></i> Back to Homepage
                    </a>
                </div>

            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

