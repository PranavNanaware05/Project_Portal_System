<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Session protection
    if (session == null || session.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int studentId = (int) session.getAttribute("student_id");
    String studentName = (String) session.getAttribute("studentName");
    if (studentName == null) studentName = "Student";
    
    // Handle request actions (approve/reject)
    String action = request.getParameter("action");
    String requestId = request.getParameter("request_id");
    
    if (action != null && requestId != null) {
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
            
            if (action.equals("approve")) {
                con.setAutoCommit(false);
                
                try {
                    ps = con.prepareStatement(
                        "SELECT project_id, student_id as applicant_id FROM project_applications " +
                        "WHERE application_id=? AND status='pending' AND EXISTS " +
                        "(SELECT 1 FROM projects p WHERE p.project_id = project_applications.project_id AND p.created_by=?)"
                    );
                    ps.setString(1, requestId);
                    ps.setInt(2, studentId);
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        int projectId = rs.getInt("project_id");
                        int applicantId = rs.getInt("applicant_id");
                        
                        rs.close();
                        ps.close();
                        
                        ps = con.prepareStatement(
                            "SELECT member_id FROM project_members WHERE project_id=? AND student_id=?"
                        );
                        ps.setInt(1, projectId);
                        ps.setInt(2, applicantId);
                        rs = ps.executeQuery();
                        
                        if (!rs.next()) {
                            rs.close();
                            ps.close();
                            
                            ps = con.prepareStatement(
                                "INSERT INTO project_members (project_id, student_id, role) VALUES (?, ?, 'member')"
                            );
                            ps.setInt(1, projectId);
                            ps.setInt(2, applicantId);
                            ps.executeUpdate();
                        }
                        
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        
                        ps = con.prepareStatement(
                            "UPDATE project_applications SET status='approved' WHERE application_id=?"
                        );
                        ps.setString(1, requestId);
                        ps.executeUpdate();
                        
                        con.commit();
                    } else {
                        con.rollback();
                    }
                } catch (SQLException e) {
                    con.rollback();
                    throw e;
                }
            } else if (action.equals("reject")) {
                ps = con.prepareStatement(
                    "UPDATE project_applications SET status='rejected' WHERE application_id=? AND EXISTS " +
                    "(SELECT 1 FROM projects p WHERE p.project_id = project_applications.project_id AND p.created_by=?)"
                );
                ps.setString(1, requestId);
                ps.setInt(2, studentId);
                ps.executeUpdate();
            }
            
            response.sendRedirect("viewRequests.jsp?message=processed");
            return;
            
        } catch (Exception e) {
            out.print("<script>alert('Error: " + e.getMessage() + "');</script>");
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { 
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close(); 
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join Requests | CollabPortal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }

        body {
            background: var(--gradient-bg);
            min-height: 100vh;
            color: var(--charcoal);
        }

        /* Header Styles */
        .header {
            background: var(--white);
            padding: 20px 40px;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: var(--charcoal);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo span {
            color: var(--orange);
        }

        .logo i {
            color: var(--orange);
            font-size: 28px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            background: var(--gradient-btn);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 18px;
        }

        .user-name {
            font-weight: 600;
            color: var(--charcoal);
        }

        /* Navigation */
        .nav-container {
            background: var(--white);
            padding: 0 40px;
            border-bottom: 1px solid #E8E8E8;
        }

        .nav-links {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            gap: 5px;
            padding: 10px 0;
        }

        .nav-link {
            padding: 12px 24px;
            text-decoration: none;
            color: var(--gray);
            border-radius: 12px;
            transition: all 0.3s;
            font-weight: 500;
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
        .main-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        /* Page Header */
        .page-header {
            background: var(--white);
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            border-left: 5px solid var(--orange);
        }

        .page-title {
            font-size: 32px;
            color: var(--charcoal);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-title i {
            color: var(--orange);
        }

        .page-subtitle {
            color: var(--gray);
            font-size: 15px;
            line-height: 1.6;
        }

        /* Filter Tabs */
        .filter-section {
            background: var(--white);
            padding: 20px;
            border-radius: 16px;
            margin-bottom: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .filter-tabs {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 10px 24px;
            background: var(--light-gray);
            border: 2px solid transparent;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 500;
            color: var(--gray);
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-btn:hover {
            background: #E8E8E8;
            transform: translateY(-2px);
        }

        .filter-btn.active {
            background: var(--gradient-btn);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
        }

        /* Stats Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--white);
            padding: 25px;
            border-radius: 16px;
            box-shadow: var(--shadow);
            text-align: center;
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-label {
            color: var(--gray);
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-pending .stat-icon { color: #F59E0B; }
        .stat-pending .stat-number { color: #F59E0B; }
        .stat-approved .stat-icon { color: #10B981; }
        .stat-approved .stat-number { color: #10B981; }
        .stat-rejected .stat-icon { color: #EF4444; }
        .stat-rejected .stat-number { color: #EF4444; }

        /* Requests Container */
        .requests-container {
            background: var(--white);
            border-radius: 20px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        /* Table Styling */
        .requests-table {
            width: 100%;
            border-collapse: collapse;
        }

        .requests-table thead {
            background: var(--gradient-btn);
        }

        .requests-table th {
            padding: 18px 20px;
            text-align: left;
            color: white;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .requests-table tbody tr {
            border-bottom: 1px solid #E8E8E8;
            transition: all 0.3s;
        }

        .requests-table tbody tr:hover {
            background: var(--light-gray);
        }

        .requests-table td {
            padding: 20px;
            vertical-align: middle;
        }

        /* Student Info Cell */
        .student-cell {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .student-avatar {
            width: 50px;
            height: 50px;
            background: var(--gradient-btn);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 18px;
            flex-shrink: 0;
        }

        .student-details h4 {
            color: var(--charcoal);
            margin-bottom: 5px;
            font-size: 16px;
            font-weight: 600;
        }

        .student-details p {
            color: var(--gray);
            font-size: 13px;
        }

        /* Project Cell */
        .project-cell {
            color: var(--orange);
            font-weight: 500;
            font-size: 15px;
        }

        /* Date Cell */
        .date-cell {
            color: var(--gray);
            font-size: 14px;
        }

        /* Status Badges */
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.1);
            color: #F59E0B;
            border: 1px solid rgba(245, 158, 11, 0.2);
        }

        .status-approved {
            background: rgba(16, 185, 129, 0.1);
            color: #10B981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .status-rejected {
            background: rgba(239, 68, 68, 0.1);
            color: #EF4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Action Buttons */
        .action-cell {
            min-width: 280px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 500;
            font-size: 13px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-approve {
            background: linear-gradient(135deg, #10B981, #059669);
            color: white;
        }

        .btn-approve:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .btn-reject {
            background: linear-gradient(135deg, #EF4444, #DC2626);
            color: white;
        }

        .btn-reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }

        .btn-view {
            background: var(--gradient-btn);
            color: white;
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
        }

        .btn-completed {
            background: var(--gray);
            color: white;
            cursor: default;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-icon {
            font-size: 80px;
            color: #E8E8E8;
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 24px;
            color: var(--charcoal);
            margin-bottom: 10px;
        }

        .empty-text {
            color: var(--gray);
            font-size: 15px;
            max-width: 500px;
            margin: 0 auto 30px;
            line-height: 1.6;
        }

        /* Alert Message */
        .alert-message {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: #10B981;
        }

        .alert-success i {
            color: #10B981;
        }

        /* Back Button */
        .back-section {
            text-align: center;
            margin-top: 40px;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 32px;
            background: var(--white);
            color: var(--charcoal);
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s;
            box-shadow: var(--shadow);
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }

        /* Responsive */
        @media (max-width: 900px) {
            .header-container {
                flex-direction: column;
                gap: 15px;
            }
            
            .nav-links {
                overflow-x: auto;
                padding: 10px 0;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 0 15px;
            }
            
            .requests-table {
                display: block;
                overflow-x: auto;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .action-btn {
                width: 100%;
                justify-content: center;
            }
            
            .page-title {
                font-size: 24px;
            }
            
            .filter-tabs {
                flex-direction: column;
            }
            
            .filter-btn {
                width: 100%;
                justify-content: center;
            }
            
            .student-cell {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <a href="dashboard.jsp" class="logo">
                <i class="fas fa-project-diagram"></i>
                Collab<span>Portal</span>
            </a>
            <div class="user-info">
                <div class="user-avatar">
                    <%= studentName.substring(0, 1).toUpperCase() %>
                </div>
                <div class="user-name">Welcome, <%= studentName %></div>
            </div>
        </div>
    </header>

    <!-- Navigation -->
    <nav class="nav-container">
        <div class="nav-links">
            <a href="dashboard.jsp" class="nav-link"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
            <a href="viewProject.jsp" class="nav-link"><i class="fas fa-project-diagram"></i> Projects</a>
            <a href="addProject.jsp" class="nav-link"><i class="fas fa-plus-circle"></i> Add Project</a>
            <a href="profile.jsp" class="nav-link"><i class="fas fa-user"></i> Profile</a>
            <a href="viewRequests.jsp" class="nav-link active"><i class="fas fa-user-plus"></i> Join Requests</a>
            <a href="logout" class="nav-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-user-plus"></i>
                Join Requests Management
            </h1>
            <p class="page-subtitle">
                Review and manage requests from students who want to join your projects.
            </p>
        </div>

        <!-- Success Message -->
        <%
            String message = request.getParameter("message");
            if (message != null && message.equals("processed")) {
        %>
            <div class="alert-message alert-success">
                <i class="fas fa-check-circle"></i>
                <span>Request has been processed successfully!</span>
            </div>
        <%
            }
        %>

        <!-- Stats Cards -->
        <div class="stats-container">
            <%
                Connection conStats = null;
                PreparedStatement psStats = null;
                ResultSet rsStats = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conStats = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_portal",
                        "root",
                        "pranav@123"
                    );
                    
                    String[] statuses = {"pending", "approved", "rejected"};
                    int[] counts = new int[3];
                    
                    for (int i = 0; i < statuses.length; i++) {
                        psStats = conStats.prepareStatement(
                            "SELECT COUNT(*) as count FROM project_applications pa " +
                            "JOIN projects p ON pa.project_id = p.project_id " +
                            "WHERE p.created_by=? AND pa.status=?"
                        );
                        psStats.setInt(1, studentId);
                        psStats.setString(2, statuses[i]);
                        rsStats = psStats.executeQuery();
                        if (rsStats.next()) {
                            counts[i] = rsStats.getInt("count");
                        }
                        rsStats.close();
                        psStats.close();
                    }
            %>
            <div class="stat-card stat-pending">
                <div class="stat-icon"><i class="fas fa-clock"></i></div>
                <div class="stat-number"><%= counts[0] %></div>
                <div class="stat-label">Pending</div>
            </div>
            <div class="stat-card stat-approved">
                <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                <div class="stat-number"><%= counts[1] %></div>
                <div class="stat-label">Approved</div>
            </div>
            <div class="stat-card stat-rejected">
                <div class="stat-icon"><i class="fas fa-times-circle"></i></div>
                <div class="stat-number"><%= counts[2] %></div>
                <div class="stat-label">Rejected</div>
            </div>
            <%
                } catch (Exception e) {
                    out.print("<!-- Error loading stats -->");
                } finally {
                    try { if (rsStats != null) rsStats.close(); } catch (Exception e) {}
                    try { if (psStats != null) psStats.close(); } catch (Exception e) {}
                    try { if (conStats != null) conStats.close(); } catch (Exception e) {}
                }
            %>
        </div>

        <!-- Filter Tabs -->
        <div class="filter-section">
            <div class="filter-tabs">
                <button class="filter-btn active" onclick="filterRequests('pending')">
                    <i class="fas fa-clock"></i> Pending
                </button>
                <button class="filter-btn" onclick="filterRequests('approved')">
                    <i class="fas fa-check-circle"></i> Approved
                </button>
                <button class="filter-btn" onclick="filterRequests('rejected')">
                    <i class="fas fa-times-circle"></i> Rejected
                </button>
                <button class="filter-btn" onclick="filterRequests('all')">
                    <i class="fas fa-list"></i> All
                </button>
            </div>
        </div>

        <!-- Requests Table -->
        <div class="requests-container">
            <%
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
                    
                    String filter = request.getParameter("filter");
                    if (filter == null) filter = "pending";
                    
                    String whereClause = "p.created_by=?";
                    if (!filter.equals("all")) {
                        whereClause += " AND pa.status='" + filter + "'";
                    }
                    
                    ps = con.prepareStatement(
                        "SELECT pa.*, p.title as project_title, " +
                        "s.student_id as applicant_id, s.name as applicant_name, s.email as applicant_email, " +
                        "pa.applied_at, pa.status " +
                        "FROM project_applications pa " +
                        "JOIN projects p ON pa.project_id = p.project_id " +
                        "JOIN students s ON pa.student_id = s.student_id " +
                        "WHERE " + whereClause + " " +
                        "ORDER BY pa.applied_at DESC"
                    );
                    ps.setInt(1, studentId);
                    rs = ps.executeQuery();
                    
                    boolean hasRequests = false;
            %>
            
            <table class="requests-table">
                <thead>
                    <tr>
                        <th>Student</th>
                        <th>Project</th>
                        <th>Applied Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            hasRequests = true;
                            String status = rs.getString("status");
                            String statusClass = "status-" + status;
                            
                            String applicantName = rs.getString("applicant_name");
                            String initials = applicantName.substring(0, Math.min(2, applicantName.length())).toUpperCase();
                            
                            java.sql.Timestamp appliedDate = rs.getTimestamp("applied_at");
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm");
                            String formattedDate = sdf.format(appliedDate);
                    %>
                    <tr>
                        <td>
                            <div class="student-cell">
                                <div class="student-avatar"><%= initials %></div>
                                <div class="student-details">
                                    <h4><%= applicantName %></h4>
                                    <p><%= rs.getString("applicant_email") %></p>
                                </div>
                            </div>
                        </td>
                        <td class="project-cell"><%= rs.getString("project_title") %></td>
                        <td class="date-cell"><%= formattedDate %></td>
                        <td>
                            <span class="status-badge <%= statusClass %>">
                                <i class="fas fa-<%= status.equals("pending") ? "clock" : status.equals("approved") ? "check" : "times" %>"></i>
                                <%= status %>
                            </span>
                        </td>
                        <td class="action-cell">
                            <div class="action-buttons">
                                <% if (status.equals("pending")) { %>
                                    <a href="viewRequests.jsp?action=approve&request_id=<%= rs.getInt("application_id") %>&filter=<%= filter %>" 
                                       class="action-btn btn-approve"
                                       onclick="return confirm('Approve this request?')">
                                        <i class="fas fa-check"></i> Approve
                                    </a>
                                    <a href="viewRequests.jsp?action=reject&request_id=<%= rs.getInt("application_id") %>&filter=<%= filter %>" 
                                       class="action-btn btn-reject"
                                       onclick="return confirm('Reject this request?')">
                                        <i class="fas fa-times"></i> Reject
                                    </a>
                                <% } else { %>
                                    <span class="action-btn btn-completed">
                                        <i class="fas fa-check-double"></i> Processed
                                    </span>
                                <% } %>
                                <a href="viewProjectDetails.jsp?project_id=<%= rs.getInt("project_id") %>" 
                                   class="action-btn btn-view">
                                    <i class="fas fa-eye"></i> View
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                        
                        if (!hasRequests) {
                            String emptyMessage = "";
                            if (filter.equals("pending")) {
                                emptyMessage = "No pending join requests at the moment.";
                            } else if (filter.equals("approved")) {
                                emptyMessage = "No approved requests found.";
                            } else if (filter.equals("rejected")) {
                                emptyMessage = "No rejected requests found.";
                            } else {
                                emptyMessage = "No join requests found for your projects.";
                            }
                    %>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <div class="empty-icon"><i class="fas fa-inbox"></i></div>
                                <h3 class="empty-title">No Requests Found</h3>
                                <p class="empty-text"><%= emptyMessage %></p>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                } catch (Exception e) {
                    out.print("<div class='empty-state'><h3>Error Loading Requests</h3><p>" + e.getMessage() + "</p></div>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (con != null) con.close(); } catch (Exception e) {}
                }
            %>
        </div>

        <!-- Back Button -->
        <div class="back-section">
            <a href="dashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </main>

    <script>
        function filterRequests(status) {
            window.location.href = 'viewRequests.jsp?filter=' + status;
        }
    </script>
</body>
</html>