<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Project Portal | View Projects</title>

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
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
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
        
        .projects-container {
            padding: 30px 40px;
        }
        
        .projects-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }
        
        .project-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            border: 1px solid #e9ecef;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
        }
        
        .project-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            border-color: #2C2C2C;
        }
        
        .project-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .project-title {
            font-size: 18px;
            font-weight: 600;
            color: #2C2C2C;
            margin-bottom: 5px;
        }
        
        .project-type {
            background: #f8f9fa;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            color: #FF6B35;
            font-weight: 500;
        }
        
        .status-badge {
            background: #FFF5F0;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            color: #FF6B35;
        }
        
        .project-description {
            color: #6c757d;
            margin-bottom: 15px;
            line-height: 1.5;
            font-size: 14px;
        }
        
        .project-host {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
            padding: 8px 12px;
            background: #f8f9fa;
            border-radius: 8px;
            font-size: 13px;
            color: #2C2C2C;
        }
        
        .project-host i {
            color: #FF6B35;
            font-size: 14px;
        }
        
        .project-host span {
            font-weight: 600;
            color: #FF6B35;
        }
        
        .project-skills {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }
        
        .skill-tag {
            background: #f8f9fa;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            color: #2C2C2C;
        }
        
        .project-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .action-btn {
            flex: 1;
            padding: 8px;
            border: none;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-block;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
        }
        
        .view-btn {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
        }
        
        .view-btn:hover {
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
        }
        
        .join-btn {
            background: linear-gradient(135deg, #FF8C5A, #FF6B35);
        }
        
        .join-btn:hover {
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
        }
        
        .no-projects {
            text-align: center;
            padding: 60px;
            color: #6c757d;
            font-size: 16px;
        }
        
        @media (max-width: 768px) {
            .projects-container {
                padding: 20px;
            }
            
            .nav-links {
                padding: 15px 20px;
                overflow-x: auto;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="header">
            <h1>Browse Projects</h1>
            <p>Discover and join interesting projects from fellow students</p>
        </div>

        <div class="nav-links">
            <a href="Dashboard.jsp">Dashboard</a>
            <a href="#" class="active">View Projects</a>
            <a href="addProject.jsp">Add Project</a>
            <a href="profile.jsp">Profile</a>
        </div>

        <div class="projects-container">
            <div class="projects-grid">
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/student_portal",
                            "root",
                            "pranav@123"
                        );

                        // Updated query to get project host/creator name
                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery(
                            "SELECT p.*, s.name as host_name " +
                            "FROM projects p " +
                            "JOIN students s ON p.created_by = s.student_id " +
                            "ORDER BY p.created_at DESC"
                        );

                        boolean hasData = false;

                        while (rs.next()) {
                            hasData = true;
                %>
                            <div class="project-card">
                                <div class="project-header">
                                    <div>
                                        <h3 class="project-title"><%= rs.getString("title") %></h3>
                                        <span class="project-type"><%= rs.getString("type") %></span>
                                    </div>
                                    <span class="status-badge"><%= rs.getString("status") %></span>
                                </div>

                                <p class="project-description">
                                    <%= rs.getString("description") %>
                                </p>

                                <!-- Project Host/Creator Name -->
                                <div class="project-host">
                                    <i class="fas fa-user-circle"></i>
                                    Hosted by: <span><%= rs.getString("host_name") %></span>
                                </div>

                                <div class="project-skills">
                                    <%
                                        String skills = rs.getString("skills");
                                        if (skills != null && !skills.isEmpty()) {
                                            String[] skillArr = skills.split(",");
                                            for (String s : skillArr) {
                                    %>
                                        <span class="skill-tag"><%= s.trim() %></span>
                                    <%
                                            }
                                        } else {
                                    %>
                                        <span class="skill-tag">No skills listed</span>
                                    <%
                                        }
                                    %>
                                </div>

                                <div class="project-actions">
                                    <button class="action-btn view-btn">View Details</button>
                                    <a href="joinProject.jsp?project_id=<%= rs.getInt("project_id") %>" class="action-btn join-btn">Join Project</a>
                                </div>
                            </div>
                <%
                        }

                        if (!hasData) {
                %>
                            <div class="no-projects">
                                <p>No projects found. Be the first to add a project!</p>
                            </div>
                <%
                        }

                        con.close();
                    } catch (Exception e) {
                        out.print("<div class='no-projects'><p>Error loading projects: " + e.getMessage() + "</p></div>");
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>