<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lms.DBConnection" %>
<%
    // Ensure the user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    int userId = (Integer) userSession.getAttribute("userId");
    String userName = (String) userSession.getAttribute("userName");
    
    int borrowedCount = 0;
    int historyCount = 0;
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - LibCore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="dashboard-container">
    <aside class="sidebar">
        <div style="font-family: 'Outfit'; font-weight: 700; font-size: 1.75rem; color: var(--primary); margin-bottom: 2rem;">
            <i class="fas fa-book-reader"></i> LibCore
        </div>
        
        <nav style="display: flex; flex-direction: column; gap: 0.5rem;">
            <a href="home.jsp" class="nav-link"><i class="fas fa-search"></i> Library Catalog</a>
            <a href="student-dashboard.jsp" class="nav-link active"><i class="fas fa-user-graduate"></i> My Shelf</a>
        </nav>

        <div style="margin-top: auto;">
            <a href="LogoutServlet" class="nav-link" style="color: var(--error);"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </aside>

    <main class="main-dash">
        <header style="margin-bottom: 3rem;">
            <h1 style="font-size: 2.5rem; margin-bottom: 0.5rem;">Student Dashboard</h1>
            <p style="color: var(--text-muted);">Welcome back, <%= userName %>. Here is an overview of your activity.</p>
        </header>

        <%
            try (Connection conn = DBConnection.getConnection()) {
                // Count borrowed books
                String countSql = "SELECT COUNT(*) FROM transactions WHERE user_id = ? AND status != 'returned'";
                PreparedStatement pstCount = conn.prepareStatement(countSql);
                pstCount.setInt(1, userId);
                ResultSet rsCount = pstCount.executeQuery();
                if (rsCount.next()) borrowedCount = rsCount.getInt(1);
        %>

        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; margin-bottom: 3rem;">
            <div class="stat-item glass">
                <i class="fas fa-book-open" style="font-size: 2rem; color: var(--primary); margin-bottom: 1rem;"></i>
                <h3 style="font-size: 2.5rem;"><%= borrowedCount %></h3>
                <p style="color: var(--text-muted);">Current Loans</p>
            </div>
            <!-- More stats can be added dynamically -->
        </div>

        <section class="glass" style="padding: 2rem; border-radius: 1.5rem;">
            <h3 style="font-size: 1.5rem; margin-bottom: 1.5rem;">My Books</h3>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Book Title</th>
                        <th>Borrowed Date</th>
                        <th>Due Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String transSql = "SELECT t.*, b.title, b.author, b.cover_url FROM transactions t JOIN books b ON t.book_id = b.id WHERE t.user_id = ? ORDER BY t.issue_date DESC";
                        PreparedStatement pstTrans = conn.prepareStatement(transSql);
                        pstTrans.setInt(1, userId);
                        ResultSet rsTrans = pstTrans.executeQuery();
                        while (rsTrans.next()) {
                            String bTitle = rsTrans.getString("title");
                            String bCover = rsTrans.getString("cover_url");
                            String bAuthor = rsTrans.getString("author");
                            String iDate = rsTrans.getString("issue_date");
                            String dDate = rsTrans.getString("due_date");
                            String bStatus = rsTrans.getString("status");
                    %>
                        <tr>
                            <td>
                                <div style="display: flex; align-items: center; gap: 1rem;">
                                    <img src="<%= bCover %>" style="width: 40px; height: 60px; object-fit: cover; border-radius: 0.25rem;" onerror="this.src='https://images.unsplash.com/photo-1543005814-14b24e1f786d?w=40&h=60&fit=crop'">
                                    <div>
                                        <p style="font-weight: 600;"><%= bTitle %></p>
                                        <p style="font-size: 0.75rem; color: var(--text-muted);"><%= bAuthor %></p>
                                    </div>
                                </div>
                            </td>
                            <td><%= iDate %></td>
                            <td><%= dDate %></td>
                            <td><span class="badge <%= bStatus.equals("active") ? "badge-success" : (bStatus.equals("overdue") ? "badge-warning" : "") %>"><%= bStatus %></span></td>
                        </tr>
                    <%
                        }
                    } catch (Exception e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    }
                    %>
                </tbody>
            </table>
        </section>
    </main>
</div>

<script src="js/main.js"></script>
</body>
</html>
