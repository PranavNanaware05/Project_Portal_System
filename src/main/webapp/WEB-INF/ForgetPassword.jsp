<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - Student Project Portal</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .forgot-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            width: 400px;
        }
        
        .forgot-container h2 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
        }
        
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }
        
        .message {
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
        }
        
        .success {
            background: #d4edda;
            color: #155724;
        }
    </style>
</head>
<body>
    <div class="forgot-container">
        <h2>🔐 Forgot Password?</h2>
        <p class="subtitle">Enter your email to receive reset link</p>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="message error">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="message success">
                ✅ Reset link sent! Check your email.
            </div>
        <% } %>
        
        <form action="forgot-password" method="post">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" required placeholder="Enter your registered email">
            </div>
            
            <button type="submit">Send Reset Link</button>
        </form>
        
        <div class="back-link">
            <a href="login.jsp">← Back to Login</a>
        </div>
    </div>
</body>
</html>