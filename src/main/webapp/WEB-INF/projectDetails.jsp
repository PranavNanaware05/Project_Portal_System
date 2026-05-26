<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    if (session == null || session.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int studentId = (int) session.getAttribute("student_id");
    String studentName = (String) session.getAttribute("studentName");
    
    String projectId = request.getParameter("project_id");
    if (projectId == null || projectId.isEmpty()) {
        response.sendRedirect("myProjects.jsp");
        return;
    }
    
    String projectTitle = "";
    String projectDesc = "";
    String projectType = "";
    String projectStatus = "";
    String projectSkills = "";
    String creatorName = "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Details | CollabPortal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: linear-gradient(135deg, #2C2C2C 0%, #1A1A1A 100%); min-height: 100vh; padding: 20px; }
        .container { max-width: 800px; margin: 30px auto; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        .header { background: linear-gradient(135deg, #FF6B35, #E55A2B); color: white; padding: 25px 30px; }
        .header h1 { font-size: 24px; display: flex; align-items: center; gap: 10px; }
        .nav-links { background: #f8f9fa; padding: 15px 30px; display: flex; gap: 20px; border-bottom: 1px solid #e9ecef; }
        .nav-links a { color: #495057; text-decoration: none; padding: 8px 16px; border-radius: 8px; }
        .nav-links a:hover { background: #e9ecef; color: #FF6B35; }
        .content { padding: 30px; }
        .project-card { background: #f8f9fa; border-radius: 15px; padding: 25px; margin-bottom: 20px; }
        .project-title { font-size: 24px; color: #2C2C2C; margin-bottom: 10px; }
        .project-meta { display: flex; gap: 15px; margin: 15px 0; flex-wrap: wrap; }
        .meta-tag { background: white; padding: 5px 15px; border-radius: 20px; font-size: 13px; color: #FF6B35; }
        .project-desc { color: #6c757d; line-height: 1.6; margin: 20px 0; }
        .skills-list { display: flex; gap: 10px; flex-wrap: wrap; margin: 20px 0; }
        .skill-tag { background: #e9ecef; padding: 5px 15px; border-radius: 20px; font-size: 13px; }
        .back-btn { display: inline-block; background: #6c757d; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; margin-top: 20px; }
        @media (max-width: 600px) { .content { padding: 20px; } .nav-links { overflow-x: auto; } }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1><i class="fas fa-info-circle"></i> Project Details</h1>
    </div>
    
    <div class="nav-links">
        <a href="Dashboard.jsp">Dashboard</a>
        <a href="viewProject.jsp">Browse Projects</a>
        <a href="myProjects.jsp">My Projects</a>
        <a href="notifications.jsp">Notifications</a>
        <a href="profile.jsp">Profile</a>
        <a href="logout.jsp">Logout</a>
    </div>
    
    <div class="content">
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
                
                String sql = "SELECT p.*, s.name as creator_name FROM projects p " +
                             "JOIN students s ON p.created_by = s.student_id " +
                             "WHERE p.project_id = ?";
                
                ps = con.prepareStatement(sql);
                ps.setString(1, projectId);
                rs = ps.executeQuery();
                
                if (rs.next()) {
                    projectTitle = rs.getString("title");
                    projectDesc = rs.getString("description");
                    projectType = rs.getString("type");
                    projectStatus = rs.getString("status");
                    projectSkills = rs.getString("skills");
                    creatorName = rs.getString("creator_name");
        %>
                    <div class="project-card">
                        <h1 class="project-title"><%= projectTitle %></h1>
                        <div class="project-meta">
                            <span class="meta-tag"><i class="fas fa-tag"></i> <%= projectType %></span>
                            <span class="meta-tag"><i class="fas fa-user"></i> Hosted by: <%= creatorName %></span>
                            <span class="meta-tag"><i class="fas fa-flag-checkered"></i> Status: <%= projectStatus %></span>
                        </div>
                        <h3>Description</h3>
                        <p class="project-desc"><%= projectDesc %></p>
                        
                        <h3>Required Skills</h3>
                        <div class="skills-list">
                            <%
                                if (projectSkills != null && !projectSkills.isEmpty()) {
                                    String[] skills = projectSkills.split(",");
                                    for (String skill : skills) {
                            %>
                                <span class="skill-tag"><%= skill.trim() %></span>
                            <%
                                    }
                                } else {
                            %>
                                <span class="skill-tag">No specific skills listed</span>
                            <%
                                }
                            %>
                        </div>
                    </div>
        <%
                } else {
        %>
                    <div class="empty-state">
                        <p>Project not found.</p>
                    </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}
            }
        %>
        
        <a href="myProjects.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to My Projects</a>
    </div>
</div>

</body>
</html>