<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Project Collaboration Portal | Register</title>
    <style>
        /* Internal CSS Styling */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', 'Segoe UI', sans-serif;
        }
        
        :root {
            --primary-color: #FF6B35;
            --secondary-color: #E55A2B;
            --accent-color: #FF8C5A;
            --light-color: #f8f9fa;
            --dark-color: #2C2C2C;
            --gradient: linear-gradient(135deg, #FF6B35 0%, #E55A2B 100%);
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        body {
            background: linear-gradient(135deg, #2C2C2C 0%, #1A1A1A 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            display: flex;
            width: 95%;
            max-width: 1000px;
            min-height: 650px;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
        }
        
        /* Left Panel - Branding with Image Background */
        .brand-section {
            flex: 1;
            background: linear-gradient(135deg, rgba(44,44,44,0.85) 0%, rgba(26,26,26,0.9) 100%), 
                        url('https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=600&h=800&fit=crop');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            text-align: center;
        }
        
        .logo-container {
            margin-bottom: 40px;
        }
        
        .logo-icon {
            width: 70px;
            height: 70px;
            background: white;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .logo-icon i {
            color: var(--primary-color);
            font-size: 32px;
        }
        
        .logo-text h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .logo-text p {
            font-size: 15px;
            opacity: 0.9;
            font-weight: 300;
        }
        
        .motivation-text {
            margin: 30px 0;
            padding: 25px;
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            border-left: 4px solid #FF8C5A;
        }
        
        .motivation-text h3 {
            font-size: 22px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .motivation-text p {
            font-size: 15px;
            opacity: 0.95;
            line-height: 1.5;
        }
        
        .benefits {
            margin-top: 20px;
        }
        
        .benefit-item {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            font-size: 14px;
        }
        
        .benefit-item i {
            margin-right: 10px;
            color: #FF8C5A;
        }
        
        /* Right Panel - Registration Form */
        .register-section {
            flex: 1.2;
            background: white;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 35px;
        }
        
        .register-header h2 {
            font-size: 28px;
            color: var(--dark-color);
            margin-bottom: 10px;
        }
        
        .register-header p {
            color: #6c757d;
            font-size: 15px;
        }
        
        .register-form {
            width: 100%;
        }
        
        .form-group {
            margin-bottom: 22px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #495057;
            font-weight: 500;
            font-size: 14px;
        }
        
        .form-group label.required::after {
            content: " *";
            color: #e63946;
        }
        
        .input-field {
            width: 100%;
            padding: 15px 18px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s;
            background-color: #f8f9fa;
        }
        
        .input-field:focus {
            border-color: var(--primary-color);
            outline: none;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.1);
        }
        
        select.input-field {
            appearance: none;
            cursor: pointer;
            padding-right: 45px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236c757d' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 18px center;
            background-size: 16px;
        }
        
        .input-hint {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
            display: block;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .terms-checkbox {
            display: flex;
            align-items: center;
            margin: 25px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 10px;
        }
        
        .terms-checkbox input {
            margin-right: 12px;
            accent-color: var(--primary-color);
        }
        
        .terms-checkbox label {
            color: #495057;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .terms-checkbox a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        
        .terms-checkbox a:hover {
            text-decoration: underline;
        }
        
        .form-buttons {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }
        
        .register-btn {
            flex: 1;
            padding: 16px;
            background: var(--gradient);
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
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.25);
        }
        
        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(255, 107, 53, 0.3);
        }
        
        .back-btn {
            padding: 16px 25px;
            background-color: white;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
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
        
        .back-btn:hover {
            background-color: #f8f9fa;
            transform: translateY(-2px);
        }
        
        .login-prompt {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #e9ecef;
            color: #6c757d;
            font-size: 15px;
        }
        
        .login-prompt a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }
        
        .login-prompt a:hover {
            text-decoration: underline;
        }
        
        /* Responsive Design */
        @media (max-width: 850px) {
            .container {
                flex-direction: column;
                max-width: 500px;
            }
            
            .brand-section, .register-section {
                padding: 40px 30px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
        
        @media (max-width: 480px) {
            .brand-section, .register-section {
                padding: 30px 20px;
            }
            
            .logo-text h1 {
                font-size: 24px;
            }
            
            .register-header h2 {
                font-size: 24px;
            }
            
            .form-buttons {
                flex-direction: column;
            }
            
            .motivation-text h3 {
                font-size: 20px;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <!-- Left Panel: Branding & Motivation with Image -->
        <div class="brand-section">
            <div class="logo-container">
                <div class="logo-icon">
                    <i class="fas fa-users-cog"></i>
                </div>
                <div class="logo-text">
                    <h1>CollabProject</h1>
                    <p>Student Collaboration Portal</p>
                </div>
            </div>
            
            <div class="motivation-text">
                <h3>Join the Collaboration</h3>
                <p>Connect with fellow students, work on exciting projects together, and build your portfolio while learning valuable teamwork skills.</p>
            </div>
            
            <div class="benefits">
                <div class="benefit-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Connect with classmates</span>
                </div>
                <div class="benefit-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Work on group projects</span>
                </div>
                <div class="benefit-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Build your skills portfolio</span>
                </div>
            </div>
        </div>
        
        <!-- Right Panel: Registration Form -->
        <div class="register-section">
            <div class="register-header">
                <h2>Create Student Account</h2>
                <p>Fill in your details to join our collaboration platform</p>
            </div>
            
            <form class="register-form" action="RegisterServlet" method="POST">

                <!-- Student Name -->
                <div class="form-group">
                    <label for="name" class="required">Full Name</label>
                    <input type="text" id="name" name="name" class="input-field" placeholder="Enter your full name" required>
                </div>
                
                <!-- Email -->
                <div class="form-group">
                    <label for="email" class="required">Email Address</label>
                    <input type="email" id="email" name="email" class="input-field" placeholder="Enter your university email" required>
                    <span class="input-hint">This will be your login username</span>
                </div>
                
                <!-- Password -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="password" class="required">Password</label>
                        <input type="password" id="password" name="password" class="input-field" placeholder="Create password" required maxlength="50">
                        <span class="input-hint">Max 50 characters</span>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirm_password" class="required">Confirm Password</label>
                        <input type="password" id="confirm_password" name="confirm_password" class="input-field" placeholder="Confirm password" required maxlength="50">
                    </div>
                </div>
                
                <!-- Department & Year -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="department" class="required">Department</label>
                        <select id="department" name="department" class="input-field" required>
                            <option value="" selected disabled>Select department</option>
                            <option value="Computer Science">Computer Science</option>
                            <option value="Information Technology">Information Technology</option>
                            <option value="Electronics">Electronics & Communication</option>
                            <option value="Mechanical">Mechanical Engineering</option>
                            <option value="Civil">Civil Engineering</option>
                            <option value="Electrical">Electrical Engineering</option>
                            <option value="Business">Business Administration</option>
                            <option value="Science">Science</option>
                            <option value="Arts">Arts</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="year" class="required">Year of Study</label>
                        <select id="year" name="year" class="input-field" required>
                            <option value="" selected disabled>Select year</option>
                            <option value="First Year">First Year</option>
                            <option value="Second Year">Second Year</option>
                            <option value="Third Year">Third Year</option>
                            <option value="Fourth Year">Fourth Year</option>
                            <option value="Fifth Year">Fifth Year</option>
                            <option value="Postgraduate">Postgraduate</option>
                        </select>
                    </div>
                </div>
                
                <!-- Terms & Conditions -->
                <div class="terms-checkbox">
                    <input type="checkbox" id="terms" name="terms" required>
                    <label for="terms">
                        I agree to the <a href="#">Terms of Service</a> and confirm that all information provided is accurate.
                    </label>
                </div>
                
                <!-- Buttons -->
                <div class="form-buttons">
                    <a href="login.jsp" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Back to Login
                    </a>
                    <button type="submit" class="register-btn">
                        <i class="fas fa-user-plus"></i> Register
                    </button>
                </div>
            </form>
            
            <div class="login-prompt">
                Already have an account? <a href="login.jsp">Sign in here</a>
            </div>
        </div>
    </div>
</body>
</html>