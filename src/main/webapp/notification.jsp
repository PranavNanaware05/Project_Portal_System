<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
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
    <title>Notifications | CollabPortal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        
        body {
            background: linear-gradient(135deg, #2C2C2C 0%, #1A1A1A 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 30px auto;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .header {
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
            color: white;
            padding: 25px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 { font-size: 24px; display: flex; align-items: center; gap: 10px; }
        .nav-links { background: #f8f9fa; padding: 15px 30px; display: flex; gap: 20px; border-bottom: 1px solid #e9ecef; }
        .nav-links a { color: #495057; text-decoration: none; padding: 8px 16px; border-radius: 8px; }
        .nav-links a:hover { background: #e9ecef; color: #FF6B35; }
        .nav-links a.active { background: linear-gradient(135deg, #FF6B35, #E55A2B); color: white; }
        
        .content { padding: 30px; }
        .notification-list { list-style: none; }
        .notification-item {
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 12px;
            display: flex;
            gap: 15px;
            transition: all 0.3s;
            border-left: 4px solid #FF6B35;
            background: #f8f9fa;
        }
        .notification-item:hover { transform: translateX(5px); background: #e9ecef; }
        .notification-icon { font-size: 24px; color: #FF6B35; }
        .notification-content { flex: 1; }
        .notification-message { color: #2C2C2C; margin-bottom: 5px; }
        .notification-date { font-size: 12px; color: #6c757d; }
        .notification-read { background: white; border-left-color: #dee2e6; }
        .empty-state { text-align: center; padding: 60px; color: #6c757d; }
        
        @media (max-width: 600px) {
            .content { padding: 20px; }
            .nav-links { overflow-x: auto; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1><i class="fas fa-bell"></i> Notifications</h1>
        <a href="myProjects.jsp" style="color: white; text-decoration: none;">
            <i class="fas fa-folder-open"></i> My Projects
        </a>
    </div>
    
    <div class="nav-links">
        <a href="Dashboard.jsp">Dashboard</a>
        <a href="viewProject.jsp">Browse Projects</a>
        <a href="myProjects.jsp">My Projects</a>
        <a href="notifications.jsp" class="active">Notifications</a>
        <a href="profile.jsp">Profile</a>
        <a href="logout.jsp">Logout</a>
    </div>
    
    <div class="content">
        <h3 style="margin-bottom: 20px; color: #2C2C2C;">
            <i class="fas fa-bell"></i> Latest Updates
        </h3>
        
        <ul class="notification-list">
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                boolean hasNotifications = false;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_portal",
                        "root",
                        "pranav@123"
                    );
                    
                    // Get notifications for this student
                    String sql = "SELECT n.*, p.title as project_title " +
                                 "FROM notifications n " +
                                 "JOIN projects p ON n.project_id = p.project_id " +
                                 "WHERE n.student_id = ? " +
                                 "ORDER BY n.created_at DESC";
                    
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, studentId);
                    rs = ps.executeQuery();
                    
                    while (rs.next()) {
                        hasNotifications = true;
                        String message = rs.getString("message");
                        String createdAt = rs.getString("created_at");
                        boolean isRead = rs.getBoolean("is_read");
                        
                        // Mark as read
                        if (!isRead) {
                            PreparedStatement psUpdate = con.prepareStatement(
                                "UPDATE notifications SET is_read = TRUE WHERE notification_id = ?"
                            );
                            psUpdate.setInt(1, rs.getInt("notification_id"));
                            psUpdate.executeUpdate();
                            psUpdate.close();
                        }
            %>
                        <li class="notification-item <%= isRead ? "notification-read" : "" %>">
                            <div class="notification-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="notification-content">
                                <p class="notification-message"><%= message %></p>
                                <p class="notification-date"><i class="far fa-clock"></i> <%= createdAt %></p>
                            </div>
                            <a href="myProjects.jsp" style="color: #FF6B35; text-decoration: none;">
                                View Project <i class="fas fa-arrow-right"></i>
                            </a>
                        </li>
            <%
                    }
                    
                    if (!hasNotifications) {
            %>
                        <div class="empty-state">
                            <i class="fas fa-bell-slash" style="font-size: 50px; margin-bottom: 15px;"></i>
                            <h3>No Notifications</h3>
                            <p>When your join requests are approved, you'll see them here.</p>
                            <a href="viewProject.jsp" style="display: inline-block; margin-top: 20px; background: #FF6B35; color: white; padding: 10px 25px; border-radius: 8px; text-decoration: none;">
                                Browse Projects
                            </a>
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
        </ul>
    </div>
</div>

</body>
</html>