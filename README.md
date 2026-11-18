# CityCare – Smart City Complaint Management System

[![Java](https://img.shields.io/badge/Java-21%20%2F%201.8%2B-ED8B00?logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-9.0-F8DC75?logo=apachetomcat&logoColor=black)](https://tomcat.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Architecture](https://img.shields.io/badge/Architecture-MVC%20Pattern-00599C)](#architecture)
[![License](https://img.shields.io/badge/License-Academic%20Project-green)](#)

---

## 1. Project Overview

**CityCare** is a web-based **Smart City Grievance Redressal and Complaint Management Platform** designed for modern municipal corporations and urban citizens. It provides a transparent, accountable, closed-loop channel for citizens to report civic infrastructure failures, and empowers municipal officers and municipal administrators to inspect, assign, monitor, and remediate problems with field evidence and audit tracking.

### Common Civic Issues Managed:
- 🚧 **Potholes and damaged roads**
- 🧹 **Overflowing garbage bins & solid waste**
- 💡 **Damaged streetlights & civic illumination**
- 💧 **Water leakage & pipeline bursts**
- 🌊 **Drainage and sewage flooding**
- 🏛️ **Other public civic infrastructure issues**

---

## 2. Key Modules & Features

### A. Citizen Module
- **Registration & Authentication:** Sign up with name, email, phone number, address, and password (securely hashed with SHA-256). Duplicate email registrations are strictly prevented.
- **Citizen Dashboard:** Real-time summary cards displaying:
  - Total complaints submitted
  - Pending review
  - In progress / active repairs
  - Resolved complaints
- **Submit Complaint:**
  - Descriptive title and problem category
  - Automatic or manual municipal department routing
  - Detailed grievance description with real-time character counter
  - Exact street location / landmark address
  - Severity level (`Low`, `Medium`, `High`, `Urgent`)
  - Optional photo evidence upload (`JPG`, `PNG`, `WEBP`, `GIF` up to 10 MB)
  - Automatically generates a unique tracking reference ID (e.g. `CC-2026-1001`)
- **My Complaints:** Searchable, filterable directory of all complaints submitted by the logged-in citizen with color-coded status badges.
- **Track Complaint:** Public & citizen real-time lookup by tracking ID, displaying complete department details, assigned officer, photo evidence, and full historical status transition trail.
- **Data Isolation:** Enforced role-based authorization ensuring citizens can only inspect their own complaint records.

### B. Municipal Officer Module
- **Officer Dashboard:** Department-tailored workbench displaying total assigned complaints, awaiting action, in progress, and resolved counts.
- **Assigned Tasks:** View all complaints assigned to the officer with category, status, priority, and date filtering.
- **Field Redressal Console:**
  - Citizen contact information (name, phone, address)
  - Grievance description and uploaded photo evidence
  - **Status Update:** Update status to `Under Review`, `In Progress`, `Resolved`, or `Rejected` with mandatory field notes / remediation remarks.
  - **Department Reassignment:** Transfer misplaced complaints to the correct department (e.g. from Sanitation to Water Supply) with reasons recorded.
  - **Resolved Archive:** Quick filter to review historically resolved civic cases.

### C. Administrator Module
- **Admin Command Dashboard:** City-wide analytics computed dynamically from live database tables:
  - Total complaints
  - Pending complaints
  - Active remediation / In-progress
  - Resolved grievances
  - Rejected / Non-jurisdiction complaints
  - Total registered citizens
  - Total municipal officers
  - Active municipal departments
- **Master Complaint Register:** Full-city oversight with multi-criteria filtering by category, department, status, and free-text search.
- **Master Assignment Console:** Directly assign/reassign any grievance to a department and specific field officer, or override status with administrative directives.
- **Citizen User Directory:** View all registered citizens, registration timestamps, and toggle account status (`ACTIVE` / `INACTIVE`) or delete accounts.
- **Municipal Officer Management:** View all officers, add new officers with departmental credentials, and edit officer designations.

---

## 3. Technology Stack & Architecture

| Layer | Technology | Details |
|---|---|---|
| **Frontend** | HTML5, CSS3, JavaScript | Modern civic UI with custom responsive CSS, JetBrains Mono font, and FontAwesome icons |
| **Dynamic Pages** | JSP (JavaServer Pages) | Scriptlets and EL (`${...}`), server-rendered, Tomcat 9 Jasper compiler |
| **Backend** | Java Servlets (`javax.servlet.*`) | Dynamic Web Project conforming to Servlet 4.0 specifications |
| **Database Connectivity**| JDBC (`java.sql.*`) | PreparedStatements, Connection pool, transaction commit/rollback |
| **Database** | MySQL 8.0+ | Normalized relational schema with foreign key constraints |
| **Web Server** | Apache Tomcat 9 | Compatible with Tomcat 9 (`javax.servlet`) and Java 21 / 1.8+ |
| **IDE** | Eclipse IDE for Enterprise Java | Preconfigured `.project`, `.classpath`, and `.settings/` WTP facets |

### Architecture Pattern: MVC (Model-View-Controller)
- **Model:** Java beans (`User`, `Complaint`, `Department`, `Officer`, `ComplaintHistory`, `DashboardStats`)
- **View:** JSP pages inside `WebContent/` (`citizen/`, `officer/`, `admin/`, `index.jsp`, `login.jsp`, `register.jsp`, `track.jsp`)
- **Controller:** Servlets in `com.citycare.controller.*` handling routing, form processing, file uploads, and session management.
- **DAO:** Data Access Objects (`UserDAO`, `ComplaintDAO`, `DepartmentDAO`, `OfficerDAO`) using parameterized queries to prevent SQL Injection.
- **Security Filter:** `AuthenticationFilter` guarding `/citizen/*`, `/officer/*`, and `/admin/*` routes with role-based access control.

---

## 4. Software Prerequisites

Before setting up the project, ensure you have:

1. **Java Development Kit (JDK):** JDK 8, 11, 17, or 21 (Tested on Eclipse Adoptium OpenJDK 21)
2. **Apache Tomcat:** Apache Tomcat 9.0.x (Configured with `javax.servlet` API)
3. **MySQL Server:** MySQL Server 8.0 or higher
4. **IDE:** Eclipse IDE for Enterprise Java and Web Developers (2020-06 or newer)
5. **Git:** Git CLI for repository management

---

## 5. Database Setup Instructions

CityCare uses MySQL-compatible SQL and can run with MySQL 8+ or TiDB Cloud Starter. The schema script at `database/citycare_db.sql` creates the five tables and sample records. It is safe to run more than once: it does not drop the database or overwrite existing seed rows.

For TiDB Cloud Starter, open the cluster's SQL Editor, select or connect to `citycare_db`, and execute `database/citycare_db.sql`. Then verify the schema:

```sql
USE citycare_db;
SHOW TABLES;
SELECT COUNT(*) FROM users;
```

The tables must include `departments`, `users`, `officers`, `complaints`, and `complaint_history`. If a table is missing, rerun the schema script; its `CREATE TABLE IF NOT EXISTS` statements create missing tables without deleting existing data.

### Database Schema Structure:
- `departments`: `department_id`, `department_name`, `description`, `contact_email`, `created_at`
- `users`: `user_id`, `full_name`, `email`, `phone`, `address`, `password_hash`, `role`, `status`, `created_at`
- `officers`: `officer_id`, `user_id`, `department_id`, `designation`, `created_at`
- `complaints`: `complaint_id`, `tracking_id`, `citizen_id`, `title`, `category`, `description`, `location`, `image_path`, `status`, `priority`, `department_id`, `assigned_officer_id`, `created_at`, `updated_at`
- `complaint_history`: `history_id`, `complaint_id`, `updated_by`, `old_status`, `new_status`, `remarks`, `updated_at`

### Database Connection Configuration

The application reads `JDBC_URL`, `DB_USER`, and `DB_PASSWORD` from its environment. Do not commit database credentials. For TiDB Cloud Starter, use the JDBC URL supplied for the cluster with `sslMode=VERIFY_IDENTITY`, and use the exact instance-prefixed username shown by TiDB (for example, `<prefix>.root`). Java and Connector/J use the JVM's trusted root certificates for TLS identity verification.

On Render, set these three environment variables in the CityCare web service. The URL should select `citycare_db`; the username must include the TiDB instance prefix. After setting them, redeploy the service.

---

## 6. Eclipse Project Setup Instructions

1. Open **Eclipse IDE for Enterprise Java and Web Developers**.
2. Go to **File** → **Import...** → **General** → **Existing Projects into Workspace**.
3. Select **Root Directory** and browse to the repository folder:
   ```
   C:\Users\Tanisha\.gemini\antigravity\scratch\jsf_mini_project
   ```
4. Check **CityCare** in the projects list and click **Finish**.
5. Configure the Tomcat 9 Runtime:
   - In Eclipse, open the **Servers** view (`Window` → `Show View` → `Servers`).
   - If not already added, click **No servers are available. Click this link to create a new server...**.
   - Select **Apache** → **Tomcat v9.0 Server**.
   - Point to your Tomcat 9 directory: `C:\Home\Tomcat\apache-tomcat-9.0.121`.
   - Click **Next**, add **CityCare** to the **Configured** column, and click **Finish**.
6. Right-click on the server and click **Start**.
7. Access the application in your browser at:
   ```
   http://localhost:8080/CityCare/
   ```

---

## 7. Running via Command Line / Apache Tomcat 9 Directly

If running outside Eclipse:
1. Copy the compiled `WebContent` folder to your Tomcat `webapps` directory:
   ```powershell
   Copy-Item -Recurse -Force WebContent "C:\Home\Tomcat\apache-tomcat-9.0.121\webapps\CityCare"
   ```
2. Start Tomcat:
   ```powershell
   & "C:\Home\Tomcat\apache-tomcat-9.0.121\bin\catalina.bat" run
   ```
3. Open your browser and navigate to:
   ```
   http://localhost:8080/CityCare/
   ```

---

## 8. Test Login Credentials for Demo Accounts

All passwords have been securely hashed using **SHA-256**. For convenience during evaluation, one-click demo login buttons are also embedded directly on the `login.jsp` page!

| Role | Name / Department | Email | Password |
|---|---|---|---|
| **Administrator** | CityCare Administrator | `admin@citycare.gov` | `Admin@123` |
| **Municipal Officer** | Rajesh Varma (Roads & Infra) | `officer.roads@citycare.gov` | `Officer@123` |
| **Municipal Officer** | Sunita Deshmukh (Sanitation) | `officer.sanitation@citycare.gov` | `Officer@123` |
| **Municipal Officer** | Arun Nair (Water Supply) | `officer.water@citycare.gov` | `Officer@123` |
| **Municipal Officer** | Kavita Iyer (Electricity) | `officer.electricity@citycare.gov` | `Officer@123` |
| **Municipal Officer** | Manoj Kulkarni (Drainage) | `officer.drainage@citycare.gov` | `Officer@123` |
| **Citizen** | Tanisha Rao | `citizen@citycare.gov` | `Citizen@123` |
| **Citizen** | Rahul Sharma | `rahul.sharma@example.com` | `Citizen@123` |

### Sample Complaint Tracking IDs for Instant Testing:
- `CC-2026-1001` (Roads – In Progress)
- `CC-2026-1002` (Sanitation – Assigned)
- `CC-2026-1003` (Water Leakage – Resolved)
- `CC-2026-1004` (Streetlights – Submitted)
- `CC-2026-1005` (Drainage – Under Review)

---

## 9. Security Implementation Highlights

- **Authentication & RBAC:** Session-based authentication via `AuthenticationFilter` prevents unauthorized URL tampering. Unauthorized role access triggers automated redirection to the role-specific dashboard.
- **SQL Injection Prevention:** 100% of database interactions across all DAOs use parameterized `PreparedStatement` queries.
- **Password Security:** Passwords are hashed with SHA-256 before insertion and authentication. No plain-text passwords exist anywhere in the database or logs.
- **Citizen Isolation:** Direct URL inspection checks (`complaint.getCitizenId() == user.getUserId()`) guarantee that citizens cannot view or manipulate complaints belonging to other citizens.
- **File Upload Safeguards:** Whitelisted image mime/extension checks (`JPG`, `PNG`, `WEBP`, `GIF`) and 10 MB file size limits prevent malicious payload uploads.
- **Session Security:** Complete session invalidation on logout and `Cache-Control: no-cache, no-store, must-revalidate` response headers prevent back-button cache leaks.

---

## 10. GitHub Repository Information

- **Repository:** `https://github.com/taniiiiiiiiiiii/jsf_mini_project.git`
- **Branch:** `main`
- **Commit History:** Developed in structured milestones with verified clean builds and pushes.

---

&copy; 2026 CityCare. Developed for Academic & Municipal Evaluation.
