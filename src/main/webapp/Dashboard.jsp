<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // 🔐 Session protection
    if (session == null || session.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int studentId = (int) session.getAttribute("student_id");
    String studentName = (String) session.getAttribute("studentName");

    int totalProjects = 0;
    int activeProjects = 0;
    int completedProjects = 0;
    int joinRequests = 0;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Project Portal | Dashboard</title>

<!-- ✅ YOUR UI CSS — ONLY COLOR CHANGES -->
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

body {
    background: linear-gradient(135deg, #2C2C2C 0%, #1A1A1A 100%);
    min-height: 100vh;
    color: #333;
}

/* Top Navigation */
.top-nav {
    background: white;
    padding: 15px 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 100;
}

.logo {
    font-size: 24px;
    font-weight: bold;
    color: #2C2C2C;
}

.logo span {
    color: #FF6B35;
}

.nav-links {
    display: flex;
    gap: 20px;
}

.nav-link {
    color: #6C6C6C;
    text-decoration: none;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.3s;
}

.nav-link:hover {
    background: #f8f9fa;
    color: #FF6B35;
}

.nav-link.active {
    background: linear-gradient(135deg, #FF6B35 0%, #E55A2B 100%);
    color: white;
}

/* Container */
.container {
    max-width: 1200px;
    margin: 30px auto;
    padding: 0 20px;
}

/* Welcome Card */
.welcome-card {
    background: linear-gradient(135deg, #FF6B35 0%, #E55A2B 100%);
    color: white;
    padding: 30px;
    border-radius: 15px;
    margin-bottom: 30px;
    box-shadow: 0 10px 20px rgba(255, 107, 53, 0.3);
}

.welcome-title {
    font-size: 28px;
    margin-bottom: 10px;
}

.welcome-text {
    font-size: 16px;
    opacity: 0.9;
}

/* Stats Section */
.stats-section {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 40px;
}

.stat-card {
    background: white;
    padding: 25px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    border: 1px solid #e9ecef;
    transition: transform 0.3s;
}

.stat-card:hover {
    transform: translateY(-5px);
}

.stat-number {
    font-size: 36px;
    font-weight: bold;
    color: #FF6B35;
    margin-bottom: 10px;
}

.stat-label {
    color: #6c757d;
    font-size: 16px;
}

/* Join Requests specific styling */
.stat-card.requests {
    border-top: 4px solid #FF6B35;
}

.stat-card.requests .stat-number {
    color: #FF6B35;
}

.stat-card.requests .stat-label a {
    color: #FF6B35;
    text-decoration: none;
}

.stat-card.requests .stat-label a:hover {
    text-decoration: underline;
}

/* Section Title */
.section-title {
    font-size: 24px;
    color: white;
    margin: 30px 0 20px 0;
    padding-bottom: 10px;
    border-bottom: 2px solid rgba(255, 255, 255, 0.2);
}

/* Actions Grid */
.actions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 25px;
    margin-bottom: 40px;
}

.action-card {
    background: white;
    padding: 30px;
    border-radius: 12px;
    text-decoration: none;
    color: inherit;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    border: 1px solid #e9ecef;
    transition: all 0.3s;
    display: block;
}

.action-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    border-color: #FF6B35;
}

.action-icon {
    font-size: 40px;
    color: #FF6B35;
    margin-bottom: 20px;
}

.action-title {
    font-size: 20px;
    color: #343a40;
    margin-bottom: 10px;
}

.action-text {
    color: #6c757d;
    line-height: 1.5;
}

/* Projects Section */
.projects-section {
    background: white;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    margin-bottom: 40px;
    border: 1px solid #e9ecef;
}

.projects-section .section-title {
    color: #2C2C2C;
    border-bottom-color: #e9ecef;
}

.project-item {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 15px;
    border-left: 4px solid #FF6B35;
}

.project-title {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 18px;
    color: #343a40;
}

.project-status {
    padding: 5px 15px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
}

.status-active {
    background: rgba(255, 107, 53, 0.1);
    color: #FF6B35;
}

.status-completed {
    background: #d4edda;
    color: #155724;
}

/* View All Button */
.view-all {
    text-align: center;
    margin-top: 30px;
}

.view-all-btn {
    display: inline-block;
    padding: 12px 30px;
    background: linear-gradient(135deg, #FF6B35 0%, #E55A2B 100%);
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s;
}

.view-all-btn:hover {
    background: linear-gradient(135deg, #E55A2B 0%, #CC4A1E 100%);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(255, 107, 53, 0.3);
}

/* Responsive Design */
@media (max-width: 768px) {
    .container {
        padding: 0 15px;
    }
    
    .top-nav {
        padding: 15px 20px;
        flex-direction: column;
        gap: 15px;
    }
    
    .nav-links {
        width: 100%;
        justify-content: center;
        flex-wrap: wrap;
    }
    
    .welcome-title {
        font-size: 24px;
    }
    
    .stats-section {
        grid-template-columns: repeat(2, 1fr);
    }
    
    .actions-grid {
        grid-template-columns: 1fr;
    }
    
    .project-title {
        flex-direction: column;
        align-items: flex-start;
        gap: 10px;
    }
}

@media (max-width: 480px) {
    .stats-section {
        grid-template-columns: 1fr;
    }
}
</style>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<!-- TOP NAV -->
<div class="top-nav">
    <div class="logo">Collab<span>Portal</span></div>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link active">Dashboard</a>
        <a href="viewProject.jsp" class="nav-link">Projects</a>
        <a href="addProject.jsp" class="nav-link">Add Project</a>
        <a href="profile.jsp" class="nav-link">Profile</a>
    </div>
</div>

<div class="container">

<!-- ✅ WELCOME -->
<div class="welcome-card">
    <h1 class="welcome-title">Welcome back, <%= studentName %>!</h1>
    <p class="welcome-text">Here's an overview of your projects and activities.</p>
</div>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_portal",
            "root",
            "pranav@123"
        );

        // 🔢 TOTAL PROJECTS (created + joined)
        PreparedStatement psTotal = con.prepareStatement(
            "SELECT COUNT(DISTINCT p.project_id) " +
            "FROM projects p " +
            "LEFT JOIN project_applications pa ON p.project_id = pa.project_id " +
            "WHERE p.created_by=? OR pa.student_id=?"
        );
        psTotal.setInt(1, studentId);
        psTotal.setInt(2, studentId);
        ResultSet rsTotal = psTotal.executeQuery();
        if (rsTotal.next()) totalProjects = rsTotal.getInt(1);

        // 🔵 ACTIVE PROJECTS
        PreparedStatement psActive = con.prepareStatement(
            "SELECT COUNT(DISTINCT p.project_id) " +
            "FROM projects p " +
            "LEFT JOIN project_applications pa ON p.project_id = pa.project_id " +
            "WHERE (p.created_by=? OR pa.student_id=?) AND p.status!='completed'"
        );
        psActive.setInt(1, studentId);
        psActive.setInt(2, studentId);
        ResultSet rsActive = psActive.executeQuery();
        if (rsActive.next()) activeProjects = rsActive.getInt(1);

        // ✅ COMPLETED PROJECTS
        PreparedStatement psCompleted = con.prepareStatement(
            "SELECT COUNT(DISTINCT p.project_id) " +
            "FROM projects p " +
            "LEFT JOIN project_applications pa ON p.project_id = pa.project_id " +
            "WHERE (p.created_by=? OR pa.student_id=?) AND p.status='completed'"
        );
        psCompleted.setInt(1, studentId);
        psCompleted.setInt(2, studentId);
        ResultSet rsCompleted = psCompleted.executeQuery();
        if (rsCompleted.next()) completedProjects = rsCompleted.getInt(1);
        
        // 📥 JOIN REQUESTS (pending requests for projects created by this student)
        PreparedStatement psRequests = con.prepareStatement(
            "SELECT COUNT(*) as request_count " +
            "FROM project_applications pa " +
            "JOIN projects p ON pa.project_id = p.project_id " +
            "WHERE p.created_by=? AND pa.status='pending'"
        );
        psRequests.setInt(1, studentId);
        ResultSet rsRequests = psRequests.executeQuery();
        if (rsRequests.next()) joinRequests = rsRequests.getInt("request_count");
%>

<!-- ✅ STATS -->
<div class="stats-section">
    <div class="stat-card">
        <div class="stat-number"><%= totalProjects %></div>
        <div class="stat-label">Total Projects</div>
    </div>
    <div class="stat-card">
        <div class="stat-number"><%= activeProjects %></div>
        <div class="stat-label">Active</div>
    </div>
    <div class="stat-card">
        <div class="stat-number"><%= completedProjects %></div>
        <div class="stat-label">Completed</div>
    </div>
    <div class="stat-card requests">
        <div class="stat-number"><%= joinRequests %></div>
        <div class="stat-label"> <a href="admin.jsp" class="nav-link">Join Requests</a></div>
    </div>
</div>

<!-- QUICK ACTIONS (UNCHANGED) -->
<h2 class="section-title">Quick Actions</h2>
<div class="actions-grid">
    <a href="addProject.jsp" class="action-card">
        <i class="fas fa-plus-circle action-icon"></i>
        <h3 class="action-title">Add New Project</h3>
        <p class="action-text">Start a new collaborative project</p>
    </a>

    <a href="viewProject.jsp" class="action-card">
        <i class="fas fa-project-diagram action-icon"></i>
        <h3 class="action-title">Browse Projects</h3>
        <p class="action-text">Find projects to join</p>
    </a>

    <a href="profile.jsp" class="action-card">
        <i class="fas fa-user-edit action-icon"></i>
        <h3 class="action-title">Edit Profile</h3>
        <p class="action-text">Update your information</p>
    </a>
</div>

<!-- ✅ RECENT PROJECTS -->
<div class="projects-section">
<h2 class="section-title">Recent Projects</h2>

<%
        PreparedStatement psRecent = con.prepareStatement(
            "SELECT DISTINCT p.title, p.status, p.created_at " +
            "FROM projects p " +
            "LEFT JOIN project_applications pa ON p.project_id = pa.project_id " +
            "WHERE p.created_by=? OR pa.student_id=? " +
            "ORDER BY p.created_at DESC LIMIT 3"
        );
        psRecent.setInt(1, studentId);
        psRecent.setInt(2, studentId);
        ResultSet rsRecent = psRecent.executeQuery();

        while (rsRecent.next()) {
%>

<div class="project-item">
    <h3 class="project-title">
        <%= rsRecent.getString("title") %>
        <span class="project-status
        <%= "completed".equalsIgnoreCase(rsRecent.getString("status"))
                ? "status-completed" : "status-active" %>">
            <%= rsRecent.getString("status") %>
        </span>
    </h3>
</div>

<%
        }
        con.close();
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    }
%>

<div class="view-all">
    <a href="viewProject.jsp" class="view-all-btn">View All Projects</a>
</div>

</div>
</div>

</body>
</html>