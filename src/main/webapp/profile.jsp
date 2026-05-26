<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>

<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int studentId = (int) s.getAttribute("student_id");
    String name = (String) s.getAttribute("studentName");
    String email = (String) s.getAttribute("email");
    String department = (String) s.getAttribute("department");
    String year = (String) s.getAttribute("studyYear");

    if (name == null || name.isEmpty()) name = "Student";
    if (department == null) department = "N/A";
    if (year == null) year = "N/A";
    
    // Get first letter for avatar
    String firstLetter = name.substring(0, 1).toUpperCase();
    
    // Database variables for real stats
    int totalProjects = 0;
    int activeProjects = 0;
    int completedProjects = 0;
    int totalTeamMembers = 0;
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_portal",
            "root",
            "pranav@123"
        );
        
        // 1. Get Total Projects (created by this student)
        ps = con.prepareStatement("SELECT COUNT(*) as total FROM projects WHERE created_by = ?");
        ps.setInt(1, studentId);
        rs = ps.executeQuery();
        if (rs.next()) {
            totalProjects = rs.getInt("total");
        }
        rs.close();
        ps.close();
        
        // 2. Get Active Projects (not completed)
        ps = con.prepareStatement("SELECT COUNT(*) as active FROM projects WHERE created_by = ? AND status != 'completed'");
        ps.setInt(1, studentId);
        rs = ps.executeQuery();
        if (rs.next()) {
            activeProjects = rs.getInt("active");
        }
        rs.close();
        ps.close();
        
        // 3. Get Completed Projects
        ps = con.prepareStatement("SELECT COUNT(*) as completed FROM projects WHERE created_by = ? AND status = 'completed'");
        ps.setInt(1, studentId);
        rs = ps.executeQuery();
        if (rs.next()) {
            completedProjects = rs.getInt("completed");
        }
        rs.close();
        ps.close();
        
        // 4. Get Total Team Members (from projects where student is creator)
        ps = con.prepareStatement(
            "SELECT COUNT(DISTINCT pm.student_id) as members " +
            "FROM project_members pm " +
            "JOIN projects p ON pm.project_id = p.project_id " +
            "WHERE p.created_by = ?"
        );
        ps.setInt(1, studentId);
        rs = ps.executeQuery();
        if (rs.next()) {
            totalTeamMembers = rs.getInt("members");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Portal | Profile</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        /* Charcoal Black + Orange Theme */
        :root {
            --charcoal: #2C2C2C;
            --charcoal-dark: #1A1A1A;
            --charcoal-light: #3A3A3A;
            --orange: #FF6B35;
            --orange-dark: #E55A2B;
            --orange-light: #FF8C5A;
            --gray: #6C6C6C;
            --light-gray: #F5F5F5;
            --white: #FFFFFF;
            --gradient-bg: linear-gradient(135deg, var(--charcoal) 0%, var(--charcoal-dark) 100%);
            --gradient-btn: linear-gradient(135deg, var(--orange) 0%, var(--orange-dark) 100%);
            --gradient-hover: linear-gradient(135deg, var(--orange-light) 0%, var(--orange) 100%);
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            --shadow-hover: 0 8px 20px rgba(255, 107, 53, 0.25);
        }
        
        body {
            background: var(--gradient-bg);
            min-height: 100vh;
            padding: 20px;
        }
        
        /* Header Navigation */
        .top-header {
            background: var(--white);
            border-radius: 20px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .logo-icon {
            width: 40px;
            height: 40px;
            background: var(--gradient-btn);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }
        
        .logo-text h1 {
            font-size: 22px;
            font-weight: 700;
            color: var(--charcoal);
        }
        
        .logo-text h1 span {
            color: var(--orange);
        }
        
        .logo-text p {
            font-size: 12px;
            color: var(--gray);
        }
        
        .nav-links {
            display: flex;
            gap: 10px;
        }
        
        .nav-link {
            padding: 10px 20px;
            text-decoration: none;
            color: var(--gray);
            font-weight: 500;
            border-radius: 12px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .nav-link:hover {
            background: var(--light-gray);
            color: var(--orange);
        }
        
        .nav-link.active {
            background: var(--gradient-btn);
            color: white;
        }
        
        /* Main Container */
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .page-title {
            font-size: 36px;
            font-weight: 700;
            color: var(--white);
            margin-bottom: 10px;
        }
        
        .page-title span {
            color: var(--orange);
        }
        
        .page-subtitle {
            color: rgba(255, 255, 255, 0.7);
            font-size: 16px;
        }
        
        /* Profile Container */
        .profile-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        
        /* Left Panel - Profile Info */
        .profile-info-card {
            background: var(--white);
            border-radius: 24px;
            padding: 40px;
            box-shadow: var(--shadow);
        }
        
        .profile-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
            padding-bottom: 30px;
            border-bottom: 2px solid var(--light-gray);
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            background: var(--gradient-btn);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 36px;
            font-weight: 600;
            flex-shrink: 0;
        }
        
        .profile-basic-info h2 {
            font-size: 24px;
            font-weight: 700;
            color: var(--charcoal);
            margin-bottom: 5px;
        }
        
        .profile-basic-info p {
            color: var(--gray);
            font-size: 14px;
        }
        
        /* Profile Details */
        .profile-details {
            margin-top: 30px;
        }
        
        .detail-item {
            margin-bottom: 20px;
        }
        
        .detail-label {
            font-size: 13px;
            color: var(--gray);
            margin-bottom: 6px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .detail-value {
            font-size: 15px;
            color: var(--charcoal);
            font-weight: 500;
            padding: 12px 16px;
            background: var(--light-gray);
            border-radius: 12px;
            border-left: 4px solid var(--orange);
        }
        
        /* Right Panel - Stats & Actions */
        .profile-stats-card {
            background: var(--white);
            border-radius: 24px;
            padding: 40px;
            box-shadow: var(--shadow);
        }
        
        .stats-header {
            font-size: 22px;
            font-weight: 700;
            color: var(--charcoal);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: var(--light-gray);
            padding: 25px;
            border-radius: 16px;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow);
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: var(--orange);
            margin-bottom: 8px;
        }
        
        .stat-label {
            font-size: 13px;
            color: var(--gray);
            font-weight: 500;
        }
        
        /* Action Buttons */
        .action-section {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid var(--light-gray);
        }
        
        .action-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--charcoal);
            margin-bottom: 20px;
        }
        
        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .action-btn {
            padding: 14px 20px;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            text-align: left;
        }
        
        .action-btn-primary {
            background: var(--gradient-btn);
            color: white;
        }
        
        .action-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        .action-btn-secondary {
            background: white;
            color: var(--charcoal);
            border: 2px solid var(--light-gray);
        }
        
        .action-btn-secondary:hover {
            background: var(--light-gray);
            border-color: var(--orange);
        }
        
        /* Responsive */
        @media (max-width: 900px) {
            .profile-container {
                grid-template-columns: 1fr;
            }
            
            .top-header {
                flex-direction: column;
                gap: 20px;
            }
            
            .nav-links {
                flex-wrap: wrap;
                justify-content: center;
            }
        }
        
        @media (max-width: 768px) {
            .page-title {
                font-size: 28px;
            }
            
            .profile-header {
                flex-direction: column;
                text-align: center;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .profile-info-card,
            .profile-stats-card {
                padding: 30px;
            }
        }
        
        @media (max-width: 480px) {
            .nav-links {
                flex-direction: column;
                width: 100%;
            }
            
            .nav-link {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Top Header Navigation -->
    <div class="top-header">
        <div class="logo">
            <div class="logo-icon">
                <i class="fas fa-users"></i>
            </div>
            <div class="logo-text">
                <h1>Collab<span>Portal</span></h1>
                <p>Student Project Portal</p>
            </div>
        </div>
        
        <div class="nav-links">
    <a href="Dashboard.jsp" class="nav-link"><i class="fas fa-home"></i> Dashboard</a>
    <a href="viewProject.jsp" class="nav-link"><i class="fas fa-project-diagram"></i> Projects</a>
    <a href="addProject.jsp" class="nav-link"><i class="fas fa-plus-circle"></i> Add Project</a>
    <a href="myProjects.jsp" class="nav-link"><i class="fas fa-folder-open"></i> My Projects</a>
    <a href="notification.jsp" class="nav-link"><i class="fas fa-bell"></i> Notifications</a>  <!-- ← ADD THIS LINE -->
    <a href="profile.jsp" class="nav-link"><i class="fas fa-user"></i> Profile</a>
    <a href="logout.jsp" class="nav-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>
    </div>
    
    <!-- Main Content -->
    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">My <span>Profile</span></h1>
            <p class="page-subtitle">View and manage your account information</p>
        </div>
        
        <!-- Profile Content -->
        <div class="profile-container">
            <!-- Left Panel: Profile Information -->
            <div class="profile-info-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <%= firstLetter %>
                    </div>
                    <div class="profile-basic-info">
                        <h2><%= name %></h2>
                        <p><%= department %> Student</p>
                    </div>
                </div>
                
                <div class="profile-details">
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-envelope"></i> Email Address
                        </div>
                        <div class="detail-value"><%= email %></div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-building"></i> Department
                        </div>
                        <div class="detail-value"><%= department %></div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-calendar-alt"></i> Year of Study
                        </div>
                        <div class="detail-value"><%= year %></div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-check-circle"></i> Account Status
                        </div>
                        <div class="detail-value">
                            <span style="color: var(--orange);">Active</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Right Panel: Statistics & Actions - NOW WITH REAL DATA -->
            <div class="profile-stats-card">
                <h2 class="stats-header">
                    <i class="fas fa-chart-line"></i> Your Activity
                </h2>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number"><%= totalProjects %></div>
                        <div class="stat-label">Total Projects</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-number"><%= activeProjects %></div>
                        <div class="stat-label">Active Projects</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-number"><%= completedProjects %></div>
                        <div class="stat-label">Completed</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-number"><%= totalTeamMembers %></div>
                        <div class="stat-label">Team Members</div>
                    </div>
                </div>
                
                <div class="action-section">
                    <h3 class="action-title">Quick Actions</h3>
                    <div class="action-buttons">
                        <a href="viewProject.jsp" class="action-btn action-btn-primary">
                            <i class="fas fa-folder-open"></i> View My Projects
                        </a>
                        <a href="addProject.jsp" class="action-btn action-btn-secondary">
                            <i class="fas fa-plus-circle"></i> Create New Project
                        </a>
                        <a href="editProfile.jsp" class="action-btn action-btn-secondary">
                            <i class="fas fa-user-edit"></i> Edit Profile
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</body>
</html>