<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – CityCare Smart City Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <!-- Page-specific glassmorphism login styles (isolated to body.login-page) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/login-ui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700&display=swap"
        rel="stylesheet"
    >
</head>
<body class="login-page">

    <!-- Animated Background -->
    <div class="login-bg" aria-hidden="true">
        <div class="wave wave-one"></div>
        <div class="wave wave-two"></div>

        <div class="glow glow-one"></div>
        <div class="glow glow-two"></div>
    </div>

    <!-- Login -->
    <main class="login-wrapper">

        <section class="login-card">

            <div class="card-content">

                <div class="heading">
                    <div class="brand-icon"><i class="fa-solid fa-city"></i></div>
                    <h1>CityCare Portal Login</h1>
                    <span>Select your user role and enter credentials to proceed</span>
                </div>

                <!-- Alert Messages -->
                <% 
                    String error = (String) request.getAttribute("errorMessage");
                    if (error == null) {
                        error = (String) session.getAttribute("errorMessage");
                        session.removeAttribute("errorMessage");
                    }
                    String success = (String) session.getAttribute("successMessage");
                    if (success != null) {
                        session.removeAttribute("successMessage");
                    }
                %>

                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <span><i class="fa-solid fa-circle-exclamation"></i> <%= error %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <span><i class="fa-solid fa-circle-check"></i> <%= success %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <% if ("true".equals(request.getParameter("logout"))) { %>
                    <div class="alert alert-info">
                        <span><i class="fa-solid fa-info-circle"></i> You have logged out successfully.</span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <!-- Role Switcher Tabs -->
                <div class="role-switcher-tabs">
                    <button type="button" class="role-tab-btn active" data-role="CITIZEN" onclick="selectRole('CITIZEN')">
                        <i class="fa-solid fa-user"></i> Citizen
                    </button>
                    <button type="button" class="role-tab-btn" data-role="OFFICER" onclick="selectRole('OFFICER')">
                        <i class="fa-solid fa-user-shield"></i> Officer
                    </button>
                    <button type="button" class="role-tab-btn" data-role="ADMIN" onclick="selectRole('ADMIN')">
                        <i class="fa-solid fa-user-gear"></i> Administrator
                    </button>
                </div>

                <form action="<%= request.getContextPath() %>/login" method="post">
                    <input type="hidden" name="role" id="role" value="CITIZEN">

                    <!-- Username / Email -->
                    <div class="input-group form-group">
                        <label class="form-label" for="email">Email Address <span class="required">*</span></label>
                        <span class="input-icon"><i class="fa-solid fa-envelope"></i></span>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            class="form-control"
                            placeholder="name@example.com"
                            autocomplete="username"
                            value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                            required
                            autofocus
                        >
                    </div>

                    <!-- Password -->
                    <div class="input-group form-group">
                        <label class="form-label" for="password">Password <span class="required">*</span></label>
                        <span class="input-icon"><i class="fa-solid fa-lock"></i></span>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            class="form-control"
                            placeholder="••••••••"
                            autocomplete="current-password"
                            required
                        >
                        <button
                            type="button"
                            class="eye"
                            onclick="toggleCityCarePassword()"
                            aria-label="Show or hide password"
                        >
                            <i class="fa-regular fa-eye" id="passwordEyeIcon"></i>
                        </button>
                    </div>

                    <!-- Login -->
                    <button type="submit" class="btn btn-primary login-btn">
                        <span><i class="fa-solid fa-right-to-bracket"></i> Sign In to CityCare</span>
                        <strong>&rarr;</strong>
                    </button>
                </form>

                <!-- Citizen Registration -->
                <p class="signup">
                    Don't have a citizen account?
                    <a href="<%= request.getContextPath() %>/register.jsp">Register as Citizen</a>
                </p>

                <!-- One-Click Demo Account Login Helper -->
                <div class="demo-account-chips">
                    <div class="demo-chips-title"><i class="fa-solid fa-flask"></i> Quick Demo Logins (Evaluation)</div>
                    <div class="chips-container">
                        <button type="button" class="chip-btn" onclick="fillDemoAccount('ADMIN', 'admin@citycare.gov', 'Admin@123')">
                            👑 Admin Demo
                        </button>
                        <button type="button" class="chip-btn" onclick="fillDemoAccount('OFFICER', 'officer.roads@citycare.gov', 'Officer@123')">
                            🚧 Roads Officer
                        </button>
                        <button type="button" class="chip-btn" onclick="fillDemoAccount('OFFICER', 'officer.sanitation@citycare.gov', 'Officer@123')">
                            🧹 Sanitation Officer
                        </button>
                        <button type="button" class="chip-btn" onclick="fillDemoAccount('CITIZEN', 'citizen@citycare.gov', 'Citizen@123')">
                            👤 Citizen Demo
                        </button>
                    </div>
                </div>

                <!-- Back to Homepage -->
                <p class="back-link">
                    <a href="<%= request.getContextPath() %>/">
                        <i class="fa-solid fa-arrow-left"></i> Back to Homepage
                    </a>
                </p>

            </div>

        </section>

    </main>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
    <script>
        function selectRole(role) {
            document.getElementById('role').value = role;
            const tabs = document.querySelectorAll('.role-tab-btn');
            tabs.forEach(tab => {
                if (tab.getAttribute('data-role') === role) {
                    tab.classList.add('active');
                } else {
                    tab.classList.remove('active');
                }
            });
        }

        function toggleCityCarePassword() {
            const password = document.getElementById('password');
            const icon = document.getElementById('passwordEyeIcon');

            if (password.type === 'password') {
                password.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                password.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>
