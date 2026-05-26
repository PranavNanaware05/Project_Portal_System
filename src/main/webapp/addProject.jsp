<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session check - redirect to login if not logged in
    if (session == null || session.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Project Portal | Add Project</title>
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
            max-width: 800px;
            margin: 30px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #FF6B35 0%, #E55A2B 100%);
            color: white;
            padding: 25px 40px;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-text h1 {
            font-size: 28px;
            margin-bottom: 8px;
        }
        
        .header-text p {
            opacity: 0.9;
            font-size: 16px;
        }
        
        .header-action a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }
        
        .header-action a:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
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
            background: linear-gradient(135deg, #FF6B35 0%, #E55A2B 100%);
            color: white;
        }
        
        .form-container {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #495057;
            font-weight: 500;
            font-size: 15px;
        }
        
        .form-group label.required::after {
            content: " *";
            color: #e63946;
        }
        
        .input-field, .textarea-field, .select-field {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s;
            background-color: #f8f9fa;
        }
        
        .textarea-field {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }
        
        .input-field:focus, .textarea-field:focus, .select-field:focus {
            border-color: #FF6B35;
            outline: none;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.1);
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #e9ecef;
        }
        
        .submit-btn {
            flex: 1;
            padding: 16px;
            background: linear-gradient(135deg, #FF6B35 0%, #E55A2B 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 107, 53, 0.3);
        }
        
        .cancel-btn {
            padding: 16px 30px;
            background-color: white;
            color: #6c757d;
            border: 2px solid #dee2e6;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .cancel-btn:hover {
            background-color: #f8f9fa;
            border-color: #FF6B35;
            color: #FF6B35;
        }
        
        .hint-text {
            font-size: 13px;
            color: #6c757d;
            margin-top: 5px;
            display: block;
        }
        
        /* Alert Messages */
        .alert-error {
            background-color: #FEF3F2;
            color: #DC2626;
            padding: 12px 20px;
            margin: 0 40px 20px 40px;
            border-radius: 10px;
            border-left: 4px solid #DC2626;
        }
        
        .alert-success {
            background-color: #D4EDDA;
            color: #155724;
            padding: 12px 20px;
            margin: 0 40px 20px 40px;
            border-radius: 10px;
            border-left: 4px solid #28A745;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 15px;
            }
            
            .header, .nav-links, .form-container {
                padding: 20px;
            }
            
            .header-content {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .button-group {
                flex-direction: column;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <div class="header-content">
                <div class="header-text">
                    <h1>Add New Project</h1>
                    <p>Create a project to collaborate with other students</p>
                </div>
                <div class="header-action">
                    <a href="viewProject.jsp">
                        <i class="fas fa-project-diagram"></i> View All Projects
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Navigation -->
        <div class="nav-links">
            <a href="Dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
            <a href="viewProject.jsp"><i class="fas fa-project-diagram"></i> View Projects</a>
            <a href="addProject.jsp" class="active"><i class="fas fa-plus-circle"></i> Add Project</a>
            <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
        </div>
        
        <!-- Error/Success Messages -->
        <% if(error != null && !error.isEmpty()) { %>
        <div class="alert-error">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } %>
        
        <% if(success != null && !success.isEmpty()) { %>
        <div class="alert-success">
            <i class="fas fa-check-circle"></i> <%= success %>
        </div>
        <% } %>
        
        <!-- Project Form -->
        <div class="form-container">
            <form action="AddProjectServlet" method="POST">
                <!-- Project Title -->
                <div class="form-group">
                    <label for="title" class="required">Project Title</label>
                    <input type="text" id="title" name="title" class="input-field" 
                           placeholder="Enter project title" required maxlength="200">
                    <span class="hint-text">Give a clear, descriptive title for your project</span>
                </div>
                
                <!-- Project Description -->
                <div class="form-group">
                    <label for="description" class="required">Project Description</label>
                    <textarea id="description" name="description" class="textarea-field" 
                              placeholder="Describe your project goals, objectives, and what you aim to achieve..." 
                              required maxlength="500"></textarea>
                    <span class="hint-text">Maximum 500 characters</span>
                </div>
                
                <!-- Project Type & Status -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="type" class="required">Project Type</label>
                        <select id="type" name="type" class="select-field" required>
                            <option value="" selected disabled>Select type</option>
                            <option value="web">Web Development</option>
                            <option value="mobile">Mobile App</option>
                            <option value="ai">AI/ML Project</option>
                            <option value="hardware">Hardware</option>
                            <option value="research">Research</option>
                            <option value="design">Design</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="status" class="required">Current Status</label>
                        <select id="status" name="status" class="select-field" required>
                            <option value="" selected disabled>Select status</option>
                            <option value="planning">Planning</option>
                            <option value="in_progress">In Progress</option>
                            <option value="testing">Testing</option>
                            <option value="completed">Completed</option>
                        </select>
                    </div>
                </div>
                
                <!-- Skills & Technologies -->
                <div class="form-group">
                    <label for="skills">Required Skills</label>
                    <input type="text" id="skills" name="skills" class="input-field" 
                           placeholder="e.g., Java, HTML/CSS, React, Python">
                    <span class="hint-text">Separate skills with commas (optional)</span>
                </div>
                
                <!-- Buttons -->
                <div class="button-group">
                    <a href="viewProject.jsp" class="cancel-btn">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-plus-circle"></i> Create Project
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>