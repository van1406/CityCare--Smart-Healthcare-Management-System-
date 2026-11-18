<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CityCare – Smart City Complaint Management System</title>
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
                    <li><a href="#categories">Civic Services</a></li>
                    <li><a href="#how-it-works">How It Works</a></li>
                    <li><a href="<%= request.getContextPath() %>/track">Track Complaint</a></li>
                </ul>
            </nav>

            <div class="nav-actions">
                <% if (loggedInUser != null) { %>
                    <a href="<%= request.getContextPath() %>/<%= loggedInUser.getRole().toLowerCase() %>/dashboard" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-gauge"></i> My Dashboard (<%= loggedInUser.getFullName().split(" ")[0] %>)
                    </a>
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                    </a>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-right-to-bracket"></i> Login
                    </a>
                    <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-user-plus"></i> Citizen Register
                    </a>
                <% } %>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-container">
            <div class="hero-content">
                <h1>Report Civic Issues. <span>Transform Your City.</span></h1>
                <p>
                    CityCare empowers citizens to voice local infrastructure challenges—from potholes to broken streetlights and water leakages—directly to municipal authorities with transparent real-time tracking.
                </p>
                <div class="hero-cta">
                    <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="btn btn-primary btn-lg">
                        <i class="fa-solid fa-bullhorn"></i> Submit a Complaint
                    </a>
                    <a href="<%= request.getContextPath() %>/track" class="btn btn-outline btn-lg" style="color: #ffffff; border-color: rgba(255,255,255,0.4);">
                        <i class="fa-solid fa-magnifying-glass"></i> Track by ID
                    </a>
                </div>
            </div>

            <!-- Quick Track Box -->
            <div class="hero-quick-track">
                <h3><i class="fa-solid fa-location-crosshairs"></i> Quick Complaint Tracking</h3>
                <p>Have a complaint reference tracking ID? Enter it below to check current resolution status.</p>
                <form action="<%= request.getContextPath() %>/track" method="get" class="track-input-group">
                    <input type="text" name="trackingId" placeholder="e.g. CC-2026-1001" required>
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-search"></i> Track
                    </button>
                </form>
            </div>
        </div>
    </section>

    <!-- Civic Categories Section -->
    <section class="section" id="categories">
        <div class="section-container">
            <div class="section-header">
                <span class="section-badge">Civic Categories</span>
                <h2 class="section-title">What Problems Can You Report?</h2>
                <p class="section-subtitle">CityCare automatically routes your grievance to the dedicated municipal engineering wing for prompt remediation.</p>
            </div>

            <div class="category-grid">
                <div class="category-card">
                    <div class="category-icon"><i class="fa-solid fa-road"></i></div>
                    <h4>Potholes & Roads</h4>
                    <p>Damaged asphalt, craters, pavement cracks, and traffic bottlenecks.</p>
                </div>
                <div class="category-card">
                    <div class="category-icon"><i class="fa-solid fa-trash-can"></i></div>
                    <h4>Garbage & Sanitation</h4>
                    <p>Overflowing community bins, uncollected waste, and street sweeping.</p>
                </div>
                <div class="category-card">
                    <div class="category-icon"><i class="fa-solid fa-faucet-drip"></i></div>
                    <h4>Water Leakage</h4>
                    <p>Underground pipe bursts, drinking water waste, and low supply pressure.</p>
                </div>
                <div class="category-card">
                    <div class="category-icon"><i class="fa-solid fa-lightbulb"></i></div>
                    <h4>Streetlights</h4>
                    <p>Non-functional streetlights, broken electrical poles, and dark avenues.</p>
                </div>
                <div class="category-card">
                    <div class="category-icon"><i class="fa-solid fa-water"></i></div>
                    <h4>Drainage & Sewage</h4>
                    <p>Clogged gutters, sewer overflow, contaminated runoff, and flood relief.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="section" id="how-it-works" style="background-color: var(--white); border-top: 1px solid var(--slate-200); border-bottom: 1px solid var(--slate-200);">
        <div class="section-container">
            <div class="section-header">
                <span class="section-badge">Transparent Process</span>
                <h2 class="section-title">How CityCare Works</h2>
                <p class="section-subtitle">Experience accountable e-governance with a closed-loop citizen resolution pipeline.</p>
            </div>

            <div class="steps-grid">
                <div class="step-card">
                    <div class="step-number">1</div>
                    <h4>Report & Evidence</h4>
                    <p>Submit your civic complaint in seconds with photos, category, and exact street location. Receive a unique tracking ID.</p>
                </div>
                <div class="step-card">
                    <div class="step-number">2</div>
                    <h4>Municipal Assignment</h4>
                    <p>The system and administrative desk inspect the issue and assign it directly to the designated department officer.</p>
                </div>
                <div class="step-card">
                    <div class="step-number">3</div>
                    <h4>Field Resolution & Audit</h4>
                    <p>Officers execute on-ground repair work, provide resolution remarks, and update status directly visible to citizens.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-brand">
                <h3><i class="fa-solid fa-city"></i> CityCare</h3>
                <p>Integrated Municipal Grievance Redressal Platform for modern smart cities. Built for responsive civic administration and empowered citizens.</p>
            </div>
            <div>
                <h4 style="color: var(--white); margin-bottom: 1rem;">Portals</h4>
                <ul style="list-style: none; line-height: 2;">
                    <li><a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--slate-400);">Citizen Portal</a></li>
                    <li><a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--slate-400);">Officer Desk</a></li>
                    <li><a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--slate-400);">Admin Command</a></li>
                </ul>
            </div>
            <div>
                <h4 style="color: var(--white); margin-bottom: 1rem;">Emergency Contacts</h4>
                <p style="font-size: 0.9rem; margin-bottom: 0.5rem;"><i class="fa-solid fa-phone"></i> Helpline: 1800-CITY-CARE</p>
                <p style="font-size: 0.9rem;"><i class="fa-solid fa-envelope"></i> helpdesk@citycare.gov</p>
            </div>
        </div>
        <div class="footer-bottom">
            <div>&copy; 2026 CityCare – Smart City Complaint Management System. All rights reserved.</div>
            <div>Developed for Academic & Municipal Evaluation.</div>
        </div>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

