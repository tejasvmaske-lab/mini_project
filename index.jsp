<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Library Management System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .auth-wrapper {
            background: linear-gradient(135deg, hsl(var(--primary-hue), 70%, 95%), hsl(var(--primary-hue), 40%, 85%));
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        [data-theme="dark"] .auth-wrapper {
            background: radial-gradient(circle at top left, hsl(var(--primary-hue), 30%, 15%), #0f172a);
        }
    </style>
</head>
<body>

<%
    // Check for error messages from Servlet
    String error = request.getParameter("error");
%>

<div class="auth-wrapper">
    <div class="auth-card glass">
        <div style="text-align: center; margin-bottom: 2rem;">
            <div style="font-size: 3rem; color: var(--primary); margin-bottom: 1rem;">
                <i class="fas fa-book-reader"></i>
            </div>
            <h1 style="font-size: 1.75rem;">Welcome Back</h1>
            <p style="color: var(--text-muted); font-size: 0.9rem;">Access your library portfolio</p>
        </div>

        <% if(error != null) { %>
            <div style="background: rgba(239, 68, 68, 0.1); color: var(--error); padding: 1rem; border-radius: 0.75rem; margin-bottom: 1.5rem; text-align: center; font-size: 0.85rem;">
                <i class="fas fa-exclamation-circle"></i> Invalid credentials. Please try again.
            </div>
        <% } %>

        <!-- Role Toggle (Student/Admin) -->
        <div style="display: flex; background: var(--bg-main); padding: 0.25rem; border-radius: 0.75rem; margin-bottom: 2rem;">
            <button id="student-toggle" class="btn" style="flex: 1; border-radius: 0.5rem; background: var(--primary); color: white;">Student</button>
            <button id="admin-toggle" class="btn" style="flex: 1; border-radius: 0.5rem; color: var(--text-muted);">Admin</button>
        </div>

        <!-- Update form action to AuthServlet -->
        <form id="login-form" action="AuthServlet" method="POST">
            <input type="hidden" name="role" id="role-input" value="student">
            
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-size: 0.85rem; font-weight: 500; margin-bottom: 0.5rem;">Library ID / Email</label>
                <input type="text" name="email" id="user-id" class="input-field" placeholder="LMS-12345" required>
            </div>
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-size: 0.85rem; font-weight: 500; margin-bottom: 0.5rem;">Password</label>
                <input type="password" name="password" id="password" class="input-field" placeholder="••••••••" required>
            </div>
            
            <button type="submit" id="login-btn" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">
                Log In
            </button>
        </form>

        <div style="text-align: center; margin-top: 2rem;">
            <p style="font-size: 0.85rem; color: var(--text-muted);">
                Don't have an account? <a href="#" style="color: var(--primary); font-weight: 600; text-decoration: none;">Sign Up</a>
            </p>
        </div>
    </div>
</div>

<script src="js/main.js"></script>
<script>
    const studentToggle = document.getElementById('student-toggle');
    const adminToggle = document.getElementById('admin-toggle');
    const userIdInput = document.getElementById('user-id');
    const roleInput = document.getElementById('role-input');

    studentToggle.addEventListener('click', () => setRole('student'));
    adminToggle.addEventListener('click', () => setRole('admin'));

    function setRole(role) {
        roleInput.value = role;
        if (role === 'student') {
            studentToggle.style.background = 'var(--primary)';
            studentToggle.style.color = 'white';
            adminToggle.style.background = 'transparent';
            adminToggle.style.color = 'var(--text-muted)';
            userIdInput.placeholder = 'student@library.com';
        } else {
            adminToggle.style.background = 'var(--primary)';
            adminToggle.style.color = 'white';
            studentToggle.style.background = 'transparent';
            studentToggle.style.color = 'var(--text-muted)';
            userIdInput.placeholder = 'admin@library.com';
        }
    }
</script>
</body>
</html>
