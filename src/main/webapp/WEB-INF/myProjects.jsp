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
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Projects | CollabPortal</title>
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
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
            color: white;
            padding: 25px 40px;
            text-align: center;
        }

        .header h1 {
            font-size: 28px;
            margin-bottom: 8px;
        }

        .header p {
            opacity: 0.9;
            font-size: 16px;
        }

        .nav-links {
            background: #f8f9fa;
            padding: 15px 40px;
            display: flex;
            gap: 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .nav-links a {
            color: #495057;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .nav-links a:hover {
            background: #e9ecef;
            color: #FF6B35;
        }

        .nav-links a.active {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
            color: white;
        }

        .content {
            padding: 30px 40px;
        }

        .section-title {
            font-size: 24px;
            color: #2C2C2C;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .projects-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .project-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            border: 1px solid #e9ecef;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
        }

        .project-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            border-color: #FF6B35;
        }

        .project-title {
            font-size: 18px;
            font-weight: 600;
            color: #2C2C2C;
            margin-bottom: 10px;
        }

        .project-type {
            display: inline-block;
            background: #f8f9fa;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            color: #FF6B35;
            margin-bottom: 15px;
        }

        .project-description {
            color: #6c757d;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 15px;
        }

        .project-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }

        .project-status {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-active {
            background: #FFF5F0;
            color: #FF6B35;
        }

        .status-completed {
            background: #D4EDDA;
            color: #28A745;
        }

        .view-btn {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
            color: white;
            padding: 8px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s;
        }

        .view-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 60px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 60px;
            margin-bottom: 20px;
            color: #dee2e6;
        }

        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }
            
            .nav-links {
                padding: 15px 20px;
                overflow-x: auto;
            }
            
            .projects-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1><i class="fas fa-folder-open"></i> My Projects</h1>
        <p>Projects you are a member of</p>
    </div>

    <div class="nav-links">
        <a href="Dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
        <a href="viewProject.jsp"><i class="fas fa-search"></i> Browse Projects</a>
        <a href="addProject.jsp"><i class="fas fa-plus-circle"></i> Add Project</a>
        <a href="myProjects.jsp" class="active"><i class="fas fa-folder-open"></i> My Projects</a>
        <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
        <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="content">
        <h2 class="section-title">
            <i class="fas fa-check-circle" style="color: #FF6B35;"></i> 
            Projects You're Added To
        </h2>

        <div class="projects-grid">
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                boolean hasProjects = false;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_portal",
                        "root",
                        "pranav@123"
                    );

                    // Get projects where student is a member (from project_members table)
                    String sql = "SELECT p.project_id, p.title, p.description, p.type, p.status, p.created_by, s.name as creator_name " +
                                 "FROM project_members pm " +
                                 "JOIN projects p ON pm.project_id = p.project_id " +
                                 "JOIN students s ON p.created_by = s.student_id " +
                                 "WHERE pm.student_id = ? " +
                                 "ORDER BY pm.joined_at DESC";

                    ps = con.prepareStatement(sql);
                    ps.setInt(1, studentId);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        hasProjects = true;
                        String status = rs.getString("status");
                        String statusClass = status.equals("completed") ? "status-completed" : "status-active";
                        String statusDisplay = status.substring(0, 1).toUpperCase() + status.substring(1);
            %>
                        <div class="project-card">
                            <h3 class="project-title"><%= rs.getString("title") %></h3>
                            <span class="project-type"><i class="fas fa-tag"></i> <%= rs.getString("type") %></span>
                            <p class="project-description"><%= rs.getString("description") %></p>
                            <div class="project-meta">
                                <span class="project-status <%= statusClass %>">
                                    <i class="fas fa-<%= status.equals("completed") ? "check-circle" : "play-circle" %>"></i> <%= statusDisplay %>
                                </span>
                                <a href="projectDetails.jsp?project_id=<%= rs.getInt("project_id") %>" class="view-btn">
                                    <i class="fas fa-eye"></i> View Project
                                </a>
                            </div>
                            <div style="margin-top: 10px; font-size: 12px; color: #6c757d;">
                                <i class="fas fa-user"></i> Hosted by: <%= rs.getString("creator_name") %>
                            </div>
                        </div>
            <%
                    }

                    if (!hasProjects) {
            %>
                        <div class="empty-state">
                            <i class="fas fa-folder-open"></i>
                            <h3>No Projects Yet</h3>
                            <p>You haven't been added to any projects yet.</p>
                            <p>Browse projects and send join requests to get started!</p>
                            <a href="viewProject.jsp" style="display: inline-block; margin-top: 20px; background: #FF6B35; color: white; padding: 10px 25px; border-radius: 8px; text-decoration: none;">
                                <i class="fas fa-search"></i> Browse Projects
                            </a>
                        </div>
            <%
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='empty-state'><p>Error loading projects: " + e.getMessage() + "</p></div>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (con != null) con.close(); } catch (Exception e) {}
                }
            %>
        </div>
    </div>
</div>

</body>
</html>