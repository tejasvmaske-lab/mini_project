<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lms.DBConnection" %>
<%
    // Ensure the user is logged in as admin
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || !"admin".equals(adminSession.getAttribute("userRole"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue/Return Portal - LibCore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="dashboard-container">
    <aside class="sidebar">
        <div style="font-family: 'Outfit'; font-weight: 700; font-size: 1.75rem; color: var(--primary); margin-bottom: 2.5rem;">
            <i class="fas fa-shield-alt"></i> LibAdmin
        </div>
        
        <nav style="display: flex; flex-direction: column; gap: 0.5rem;">
            <a href="admin-inventory.jsp" class="nav-link"><i class="fas fa-box"></i> Inventory Manager</a>
            <a href="admin-issue.jsp" class="nav-link active"><i class="fas fa-exchange-alt"></i> Issue/Return Portal</a>
        </nav>

        <div style="margin-top: auto;">
            <a href="LogoutServlet" class="nav-link" style="color: #ef4444;"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </aside>

    <main class="main-content" style="padding: 3rem;">
        <header style="margin-bottom: 3rem; text-align: center;">
            <h1 style="font-size: 2.5rem; margin-bottom: 0.5rem;">Issue & Return Portal</h1>
            <p style="color: var(--text-muted);">Process transactions and keep the database updated.</p>
        </header>

        <div style="max-width: 600px; margin: 0 auto; padding: 3rem; border-radius: 2rem;" class="glass">
            
            <div style="display: flex; background: var(--bg-main); padding: 0.4rem; border-radius: 1rem; margin-bottom: 3rem;">
                <button id="type-issue" class="btn" style="flex: 1; border-radius: 0.75rem; background: var(--primary); color: white;">Issue Book</button>
                <button id="type-return" class="btn" style="flex: 1; border-radius: 0.75rem; color: var(--text-muted); background: transparent;">Return Book</button>
            </div>

            <!-- Transaction Form -->
            <form action="TransactionServlet" method="POST">
                <input type="hidden" name="type" id="trans-type" value="issue">
                
                <div style="margin-bottom: 2rem;">
                    <h3 style="margin-bottom: 1rem; font-size: 1rem;">Student & Book Details</h3>
                    <div style="margin-bottom: 1.25rem;">
                        <label style="display: block; font-size: 0.8rem; margin-bottom: 0.5rem;">Student Email</label>
                        <input type="email" name="studentEmail" class="input-field" placeholder="student@library.com" required>
                    </div>
                    <div style="margin-bottom: 1.25rem;">
                        <label style="display: block; font-size: 0.8rem; margin-bottom: 0.5rem;">Book ID</label>
                        <input type="number" name="bookId" class="input-field" placeholder="e.g. 1" required>
                    </div>
                </div>

                <div id="issue-fields">
                    <div style="margin-bottom: 2rem;">
                        <label style="display: block; font-size: 0.8rem; margin-bottom: 0.5rem;">Duration (Weeks)</label>
                        <select name="duration" class="input-field">
                            <option value="1">1 Week</option>
                            <option value="2" selected>2 Weeks</option>
                            <option value="4">4 Weeks</option>
                        </select>
                    </div>
                </div>

                <button type="submit" id="submit-btn" class="btn btn-primary" style="width: 100%; padding: 1.25rem;">
                    Confirm Book Issue
                </button>
            </form>
        </div>
    </main>
</div>

<script src="js/main.js"></script>
<script>
    const typeIssue = document.getElementById('type-issue');
    const typeReturn = document.getElementById('type-return');
    const transTypeInput = document.getElementById('trans-type');
    const issueFields = document.getElementById('issue-fields');
    const submitBtn = document.getElementById('submit-btn');

    typeIssue.addEventListener('click', () => setType('issue'));
    typeReturn.addEventListener('click', () => setType('return'));

    function setType(type) {
        transTypeInput.value = type;
        if (type === 'issue') {
            typeIssue.style.background = 'var(--primary)';
            typeIssue.style.color = 'white';
            typeReturn.style.background = 'transparent';
            typeReturn.style.color = 'var(--text-muted)';
            issueFields.style.display = 'block';
            submitBtn.innerText = 'Confirm Book Issue';
        } else {
            typeReturn.style.background = 'var(--primary)';
            typeReturn.style.color = 'white';
            typeIssue.style.background = 'transparent';
            typeIssue.style.color = 'var(--text-muted)';
            issueFields.style.display = 'none';
            submitBtn.innerText = 'Confirm Book Return';
        }
    }
</script>
</body>
</html>
