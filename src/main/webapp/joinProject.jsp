<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Session check
    if (session == null || session.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String projectId = request.getParameter("project_id");
    if (projectId == null || projectId.isEmpty()) {
        response.sendRedirect("viewProject.jsp");
        return;
    }
    
    String studentName = (String) session.getAttribute("studentName");
    String studentEmail = (String) session.getAttribute("email");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join Project | CollabPortal</title>
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
            padding: 15px 30px;
            display: flex;
            gap: 20px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .nav-links a {
            color: #495057;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 8px;
        }
        
        .nav-links a:hover {
            background: #e9ecef;
            color: #FF6B35;
        }
        
        .content {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #2C2C2C;
        }
        
        .form-group label.required::after {
            content: " *";
            color: #e63946;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: #FF6B35;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.1);
        }
        
        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #FF6B35, #E55A2B);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 20px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 107, 53, 0.3);
        }
        
        .btn-cancel {
            width: 100%;
            padding: 12px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            margin-top: 10px;
        }
        
        .info-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #FF6B35;
        }
        
        @media (max-width: 600px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            .content {
                padding: 20px;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="container">
    <div class="header">
        <h1><i class="fas fa-handshake"></i> Join Project</h1>
        <p>Fill the form to send join request</p>
    </div>
    
    <div class="nav-links">
        <a href="Dashboard.jsp">Dashboard</a>
        <a href="viewProject.jsp">Browse Projects</a>
        <a href="myProjects.jsp">My Projects</a>
        <a href="profile.jsp">Profile</a>
        <a href="logout.jsp">Logout</a>
    </div>
    
    <div class="content">
        <div class="info-box">
            <i class="fas fa-info-circle"></i> 
            <strong>Note:</strong> Fill in your details. The project host will review your application.
        </div>
        
        <!-- IMPORTANT: Form action must be "joinProject" (servlet URL) -->
        <form action="joinProject" method="POST">
            <input type="hidden" name="project_id" value="<%= projectId %>">
            
            <div class="form-row">
                <div class="form-group">
                    <label class="required">Full Name</label>
                    <input type="text" name="name" class="form-control" value="<%= studentName %>" required>
                </div>
                
                <div class="form-group">
                    <label class="required">Email</label>
                    <input type="email" name="email" class="form-control" value="<%= studentEmail %>" required>
                </div>
            </div>
            
            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" class="form-control" placeholder="Enter your phone number">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="required">Year of Study</label>
                    <select name="year" class="form-control" required>
                        <option value="">Select Year</option>
                        <option value="First Year">First Year</option>
                        <option value="Second Year">Second Year</option>
                        <option value="Third Year">Third Year</option>
                        <option value="Fourth Year">Fourth Year</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="required">Department</label>
                    <input type="text" name="department" class="form-control" placeholder="Your department" required>
                </div>
            </div>
            
            <div class="form-group">
                <label class="required">Your Skills</label>
                <textarea name="skills" class="form-control" placeholder="List your skills (e.g., Java, Python, HTML, Teamwork)" required></textarea>
            </div>
            
            <div class="form-group">
                <label>Previous Experience</label>
                <textarea name="experience" class="form-control" placeholder="Share any relevant experience (optional)"></textarea>
            </div>
            
            <div class="form-group">
                <label class="required">Why do you want to join?</label>
                <textarea name="message" class="form-control" placeholder="Tell us why you're interested in this project" required></textarea>
            </div>
            
            <div class="form-group">
                <label class="required">Weekly Availability</label>
                <select name="availability" class="form-control" required>
                    <option value="">Select hours per week</option>
                    <option value="1-5 hours">1-5 hours</option>
                    <option value="5-10 hours">5-10 hours</option>
                    <option value="10-15 hours">10-15 hours</option>
                    <option value="15-20 hours">15-20 hours</option>
                    <option value="20+ hours">20+ hours</option>
                </select>
            </div>
            
            <button type="submit" class="btn-submit">
                <i class="fas fa-paper-plane"></i> Send Join Request
            </button>
            
            <a href="viewProject.jsp" class="btn-cancel">
                <i class="fas fa-times"></i> Cancel
            </a>
        </form>
    </div>
</div>

</body>
</html>