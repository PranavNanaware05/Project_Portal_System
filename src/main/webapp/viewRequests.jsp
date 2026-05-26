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
                // Start transaction
                con.setAutoCommit(false);
                String projectTitle = "";
                int applicantId = 0;
                int projectId = 0;
                
                try {
                    // 1. Get project details and applicant
                    ps = con.prepareStatement(
                        "SELECT p.project_id, pa.student_id as applicant_id, p.title as project_title " +
                        "FROM project_applications pa " +
                        "JOIN projects p ON pa.project_id = p.project_id " +
                        "WHERE pa.application_id=? AND pa.status='pending' AND p.created_by=?"
                    );
                    ps.setString(1, requestId);
                    ps.setInt(2, studentId);
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        projectId = rs.getInt("project_id");
                        applicantId = rs.getInt("applicant_id");
                        projectTitle = rs.getString("project_title");
                        
                        rs.close();
                        ps.close();
                        
                        // 2. Check if already a member
                        ps = con.prepareStatement(
                            "SELECT member_id FROM project_members WHERE project_id=? AND student_id=?"
                        );
                        ps.setInt(1, projectId);
                        ps.setInt(2, applicantId);
                        rs = ps.executeQuery();
                        
                        if (!rs.next()) {
                            rs.close();
                            ps.close();
                            
                            // 3. Add to project_members
                            ps = con.prepareStatement(
                                "INSERT INTO project_members (project_id, student_id, role) VALUES (?, ?, 'member')"
                            );
                            ps.setInt(1, projectId);
                            ps.setInt(2, applicantId);
                            ps.executeUpdate();
                            ps.close();
                        }
                        
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        
                        // 4. Update application status to approved
                        ps = con.prepareStatement(
                            "UPDATE project_applications SET status='approved' WHERE application_id=?"
                        );
                        ps.setString(1, requestId);
                        ps.executeUpdate();
                        ps.close();
                        
                        // 5. 🆕 INSERT NOTIFICATION for the student
                        ps = con.prepareStatement(
                            "INSERT INTO notifications (student_id, project_id, message) VALUES (?, ?, ?)"
                        );
                        ps.setInt(1, applicantId);
                        ps.setInt(2, projectId);
                        ps.setString(3, "🎉 Congratulations! Your request to join project '" + projectTitle + "' has been APPROVED! You are now a team member.");
                        ps.executeUpdate();
                        
                        // Commit transaction
                        con.commit();
                        
                    } else {
                        con.rollback();
                    }
                    
                } catch (SQLException e) {
                    con.rollback();
                    throw e;
                }
                
            } else if (action.equals("reject")) {
                // Update status to rejected
                ps = con.prepareStatement(
                    "UPDATE project_applications SET status='rejected' WHERE application_id=? AND EXISTS " +
                    "(SELECT 1 FROM projects p WHERE p.project_id = project_applications.project_id AND p.created_by=?)"
                );
                ps.setString(1, requestId);
                ps.setInt(2, studentId);
                ps.executeUpdate();
            }
            
            // Redirect to refresh the page and show updated status
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

        body {
            background: linear-gradient(135deg, #2C2C2C 0%, #1A1A1A 100%);
            min-height: 100vh;
            color: #333;
        }

        /* Header Styles */
        .header {
            background: white;
            padding: 20px 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
            color: #2C2C2C;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo span {
            color: #FF6B35;
        }

        .logo i {
            font-size: 32px;
            color: #FF6B35;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
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
            color: #343a40;
        }

        /* Navigation */
        .nav-container {
            background: white;
            padding: 0 40px;
            border-bottom: 1px solid #e9ecef;
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
            color: #495057;
            border-radius: 8px;
            transition: all 0.3s;
            font-weight: 500;
        }

        .nav-link:hover {
            background: #f8f9fa;
            color: #FF6B35;
        }

        .nav-link.active {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
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
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            border-left: 5px solid #FF6B35;
        }

        .page-title {
            font-size: 32px;
            color: #343a40;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-title i {
            color: #FF6B35;
        }

        .page-subtitle {
            color: #6c757d;
            font-size: 16px;
            line-height: 1.6;
        }

        /* Filter Tabs */
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
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
            background: #f8f9fa;
            border: 2px solid transparent;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            color: #495057;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-btn:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        .filter-btn.active {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
            color: white;
            border-color: #FF6B35;
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.2);
        }

        /* Requests Container */
        .requests-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        /* Table Styling */
        .requests-table {
            width: 100%;
            border-collapse: collapse;
        }

        .requests-table thead {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
        }

        .requests-table th {
            padding: 18px 20px;
            text-align: left;
            color: white;
            font-weight: 600;
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .requests-table tbody tr {
            border-bottom: 1px solid #e9ecef;
            transition: all 0.3s;
        }

        .requests-table tbody tr:hover {
            background: #f8fafd;
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
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
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
            color: #343a40;
            margin-bottom: 5px;
            font-size: 16px;
            font-weight: 600;
        }

        .student-details p {
            color: #6c757d;
            font-size: 14px;
        }

        /* Project Cell */
        .project-cell {
            color: #FF6B35;
            font-weight: 500;
            font-size: 15px;
        }

        /* Date Cell */
        .date-cell {
            color: #6c757d;
            font-size: 14px;
        }

        /* Status Badges */
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.1);
            color: #ffc107;
            border: 1px solid rgba(255, 193, 7, 0.2);
        }

        .status-approved {
            background: rgba(40, 167, 69, 0.1);
            color: #28a745;
            border: 1px solid rgba(40, 167, 69, 0.2);
        }

        .status-rejected {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
            border: 1px solid rgba(220, 53, 69, 0.2);
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
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-approve {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-approve:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .btn-reject {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
            color: white;
        }

        .btn-reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        .btn-view {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
            color: white;
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
        }

        .btn-completed {
            background: #6c757d;
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
            color: #dee2e6;
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 24px;
            color: #343a40;
            margin-bottom: 10px;
        }

        .empty-text {
            color: #6c757d;
            font-size: 16px;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Stats Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
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
            color: #6c757d;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-pending .stat-icon { color: #ffc107; }
        .stat-pending .stat-number { color: #ffc107; }
        .stat-approved .stat-icon { color: #28a745; }
        .stat-approved .stat-number { color: #28a745; }
        .stat-rejected .stat-icon { color: #dc3545; }
        .stat-rejected .stat-number { color: #dc3545; }

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
            background: linear-gradient(135deg, #6c757d, #495057);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(108, 117, 125, 0.3);
        }

        /* Alert Message */
        .alert-message {
            padding: 16px 20px;
            border-radius: 10px;
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
            background: rgba(40, 167, 69, 0.1);
            border: 1px solid rgba(40, 167, 69, 0.2);
            color: #155724;
        }

        .alert-success i {
            color: #28a745;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 15px;
            }
            .nav-links {
                overflow-x: auto;
            }
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
            <a href="myProjects.jsp" class="nav-link"><i class="fas fa-folder-open"></i> My Projects</a>
            <a href="profile.jsp" class="nav-link"><i class="fas fa-user"></i> Profile</a>
            <a href="viewRequests.jsp" class="nav-link active"><i class="fas fa-user-plus"></i> Join Requests</a>
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
                <span>Request processed successfully! Student has been notified.</span>
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
                <button class="filter-btn active" onclick="filterRequests('pending')"><i class="fas fa-clock"></i> Pending</button>
                <button class="filter-btn" onclick="filterRequests('approved')"><i class="fas fa-check-circle"></i> Approved</button>
                <button class="filter-btn" onclick="filterRequests('rejected')"><i class="fas fa-times-circle"></i> Rejected</button>
                <button class="filter-btn" onclick="filterRequests('all')"><i class="fas fa-list"></i> All</button>
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
                        "s.name as applicant_name, s.email as applicant_email, " +
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
                    <tr><th>Student</th><th>Project</th><th>Applied Date</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            hasRequests = true;
                            String status = rs.getString("status");
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
                            <span class="status-badge status-<%= status %>">
                                <i class="fas fa-<%= status.equals("pending") ? "clock" : status.equals("approved") ? "check" : "times" %>"></i>
                                <%= status %>
                            </span>
                        </td>
                        <td class="action-cell">
                            <div class="action-buttons">
                                <% if (status.equals("pending")) { %>
                                    <a href="viewRequests.jsp?action=approve&request_id=<%= rs.getInt("application_id") %>&filter=<%= filter %>" 
                                       class="action-btn btn-approve" 
                                       onclick="return confirm('Approve this request? Student will be added and notified.')">
                                        <i class="fas fa-check"></i> Approve
                                    </a>
                                    <a href="viewRequests.jsp?action=reject&request_id=<%= rs.getInt("application_id") %>&filter=<%= filter %>" 
                                       class="action-btn btn-reject"
                                       onclick="return confirm('Reject this request?')">
                                        <i class="fas fa-times"></i> Reject
                                    </a>
                                <% } else { %>
                                    <span class="action-btn btn-completed"><i class="fas fa-check-double"></i> Processed</span>
                                <% } %>
                                <a href="viewApplication.jsp?app_id=<%= rs.getInt("application_id") %>" class="action-btn btn-view">
                                    <i class="fas fa-eye"></i> View Details
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                        if (!hasRequests) {
                    %>
                    <tr><td colspan="5">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fas fa-inbox"></i></div>
                            <h3 class="empty-title">No Requests Found</h3>
                            <p class="empty-text">No <%= filter %> requests at the moment.</p>
                        </div>
                    </td></tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                } catch (Exception e) {
                    out.print("<div class='empty-state'><p>Error: " + e.getMessage() + "</p></div>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (con != null) con.close(); } catch (Exception e) {}
                }
            %>
        </div>

        <!-- Back Button -->
        <div class="back-section">
            <a href="dashboard.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        </div>
    </main>

    <script>
        function filterRequests(status) {
            window.location.href = 'viewRequests.jsp?filter=' + status;
        }
    </script>
</body>
</html>