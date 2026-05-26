<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudentPortal | Login</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        
        :root {
            --charcoal: #2C2C2C;
            --charcoal-light: #3A3A3A;
            --charcoal-dark: #1A1A1A;
            --orange: #FF6B35;
            --orange-light: #FF8C5A;
            --orange-dark: #E55A2B;
            --gray: #6C6C6C;
            --light-gray: #F5F5F5;
            --white: #FFFFFF;
        }
        
        body {
            background: linear-gradient(135deg, var(--charcoal) 0%, var(--charcoal-dark) 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .login-container {
            display: flex;
            width: 90%;
            max-width: 1100px;
            background: var(--white);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0,0,0,0.25);
            animation: fadeIn 0.5s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Left Panel - Charcoal with Image Background */
        .login-left {
            flex: 1;
            background: linear-gradient(135deg, rgba(44,44,44,0.9) 0%, rgba(26,26,26,0.95) 100%), 
                        url('https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600&h=800&fit=crop');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .login-left h1 {
            font-size: 2.5rem;
            margin-bottom: 15px;
            font-weight: 700;
        }
        
        .login-left h1 span {
            color: var(--orange);
        }
        
        .login-left h2 {
            font-size: 1.3rem;
            font-weight: 400;
            margin-bottom: 25px;
            opacity: 0.9;
            line-height: 1.4;
        }
        
        .login-left p {
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 25px;
            opacity: 0.85;
        }
        
        .features {
            list-style: none;
            margin: 20px 0;
        }
        
        .features li {
            padding: 12px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            align-items: center;
            font-size: 0.95rem;
        }
        
        .features li:before {
            content: "→";
            margin-right: 12px;
            font-weight: bold;
            color: var(--orange);
        }
        
        .quote {
            margin-top: 30px;
            padding: 20px;
            background: rgba(255, 107, 53, 0.15);
            border-left: 3px solid var(--orange);
            border-radius: 8px;
            backdrop-filter: blur(5px);
        }
        
        .quote p {
            font-style: italic;
            margin-bottom: 8px;
            opacity: 0.9;
        }
        
        .quote-author {
            font-size: 0.8rem;
            opacity: 0.7;
        }
        
        /* Right Panel - White */
        .login-right {
            flex: 1;
            padding: 55px 50px;
            background: var(--white);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 35px;
        }
        
        .login-header h3 {
            font-size: 2rem;
            color: var(--charcoal);
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .login-header p {
            color: var(--gray);
            font-size: 0.95rem;
        }
        
        /* Form Elements */
        .login-form {
            width: 100%;
        }
        
        .input-group {
            margin-bottom: 22px;
        }
        
        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--charcoal);
            font-weight: 500;
            font-size: 0.85rem;
        }
        
        .input-group input {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #E8E8E8;
            border-radius: 12px;
            font-size: 0.95rem;
            transition: all 0.3s;
            background: var(--light-gray);
        }
        
        .input-group input:focus {
            border-color: var(--orange);
            outline: none;
            background: var(--white);
            box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.1);
        }
        
        /* Options */
        .options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            font-size: 0.85rem;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--gray);
        }
        
        .remember-me input {
            width: 16px;
            height: 16px;
            accent-color: var(--orange);
        }
        
        .forgot-password {
            color: var(--orange);
            text-decoration: none;
            font-weight: 500;
        }
        
        .forgot-password:hover {
            color: var(--orange-dark);
            text-decoration: underline;
        }
        
        /* Login Button */
        .login-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--orange) 0%, var(--orange-dark) 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 107, 53, 0.3);
        }
        
        .login-btn:active {
            transform: translateY(0);
        }
        
        /* Register Link */
        .register-link {
            text-align: center;
            margin-top: 28px;
            color: var(--gray);
            font-size: 0.85rem;
        }
        
        .register-link a {
            color: var(--orange);
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-link a:hover {
            color: var(--orange-dark);
            text-decoration: underline;
        }
        
        /* Alert */
        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 0.85rem;
            display: none;
        }
        
        .alert-error {
            background-color: #FEF3F2;
            color: #DC2626;
            border-left: 4px solid #DC2626;
        }
        
        .alert-success {
            background-color: #D4EDDA;
            color: #155724;
            border-left: 4px solid #28A745;
        }
        
        /* Responsive */
        @media (max-width: 900px) {
            .login-container {
                flex-direction: column;
            }
            
            .login-left, .login-right {
                padding: 35px 30px;
            }
            
            .login-left {
                text-align: center;
            }
        }
        
        @media (max-width: 500px) {
            .login-left h1 {
                font-size: 2rem;
            }
            
            .login-header h3 {
                font-size: 1.6rem;
            }
            
            .options {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%
        if(session != null && session.getAttribute("student_id") != null) {
            response.sendRedirect("profile.jsp");
            return;
        }
        
        String logoutMsg = request.getParameter("logout");
        String error = request.getParameter("error");
        String errorMessage = "";
        
        if(error != null && error.equals("invalid")) {
            errorMessage = "Invalid email or password. Please try again.";
        }
    %>
    
    <% if(logoutMsg != null && logoutMsg.equals("success")) { %>
    <div class="alert alert-success" style="display: block; position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 1000; width: auto; min-width: 300px;">
        <i class="fas fa-check-circle"></i> You have been logged out successfully!
    </div>
    <script>
        setTimeout(function() {
            var msg = document.querySelector('.alert-success');
            if(msg) msg.style.display = 'none';
        }, 3000);
    </script>
    <% } %>
    
    <div class="login-container">
        <!-- Left Panel - Charcoal with Image -->
        <div class="login-left">
            <h1>Collab<span>Portal</span></h1>
            <h2>Where Ideas Meet Execution</h2>
            <p>Connect with talented students, work on exciting projects, and build something amazing together.</p>
            
            <ul class="features">
                <li>Find your perfect team</li>
                <li>Track project milestones</li>
                <li>Showcase your portfolio</li>
                <li>Get real-time feedback</li>
            </ul>
            
            <div class="quote">
                <p>"Alone we can do so little; together we can do so much."</p>
                <div class="quote-author">— Helen Keller</div>
            </div>
        </div>
        
        <!-- Right Panel - White -->
        <div class="login-right">
            <div class="login-header">
                <h3>Welcome Back</h3>
                <p>Sign in to your account</p>
            </div>
            
            <% if(errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-error" style="display: block;">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
            <% } %>
            
            <form class="login-form" action="login" method="POST">
                <div class="input-group">
                    <label><i class="fas fa-envelope"></i> Email Address</label>
                    <input type="email" name="email" placeholder="student@university.edu" required>
                </div>
                
                <div class="input-group">
                    <label><i class="fas fa-lock"></i> Password</label>
                    <input type="password" name="password" placeholder="Enter your password" required>
                </div>
                
                <div class="options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="forgotPassword.jsp" class="forgot-password">Forgot password?</a>
                </div>
                
                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </button>
            </form>
            
            <div class="register-link">
                Don't have an account? <a href="register.jsp">Create account</a>
            </div>
        </div>
    </div>
</body>
</html>