<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lms.DBConnection" %>
<%
    // Ensure the user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String userName = (String) userSession.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Library Discovery</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .top-nav { padding: 1.5rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 100; }
        .hero { padding: 4rem 2rem; text-align: center; background: linear-gradient(rgba(var(--primary-hue), 70%, 55%, 0.05), transparent); }
        .search-container { max-width: 600px; margin: 2rem auto 0; position: relative; }
        .search-container i { position: absolute; left: 1.25rem; top: 50%; transform: translateY(-50%); color: var(--text-muted); }
        .search-container .input-field { padding-left: 3rem; height: 3.5rem; font-size: 1.1rem; border-radius: 2rem; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

<nav class="top-nav glass">
    <div style="font-family: 'Outfit'; font-weight: 700; font-size: 1.5rem; color: var(--primary);">
        <i class="fas fa-book-reader"></i> LibCore
    </div>
    <div style="display: flex; gap: 2rem; align-items: center;">
        <a href="home.jsp" class="nav-link active" style="margin: 0;">Discover</a>
        <a href="student-dashboard.jsp" class="nav-link" style="margin: 0;">My Books</a>
        <div style="display: flex; align-items: center; gap: 1rem;">
           <span style="font-weight: 500; font-size: 0.9rem;"><%= userName %></span>
           <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--border); overflow: hidden;">
               <img src="https://ui-avatars.com/api/?name=<%= userName %>&background=6366f1&color=fff" alt="User">
           </div>
        </div>
        <a href="LogoutServlet" style="color: var(--error);"><i class="fas fa-sign-out-alt"></i></a>
    </div>
</nav>

<section class="hero">
    <h1 style="font-size: 3.5rem; margin-bottom: 1rem;">Find Your Next Read</h1>
    <p style="color: var(--text-muted); font-size: 1.25rem;">Search through thousands of library resources.</p>
    <div class="search-container">
        <i class="fas fa-search"></i>
        <input type="text" id="book-search" class="input-field" placeholder="Search by title, author, or category...">
    </div>
</section>

<main class="main-content">
    <div class="books-grid" id="books-grid">
        <%
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT * FROM books";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String title = rs.getString("title");
                    String author = rs.getString("author");
                    String status = rs.getInt("available_copies") > 0 ? "Available" : "Borrowed";
                    String cover = rs.getString("cover_url");
        %>
            <div class="book-card glass" onclick="location.href='book-details.jsp?id=<%= id %>'">
                <img src="<%= cover %>" class="book-img" alt="<%= title %>" onerror="this.src='https://images.unsplash.com/photo-1543005814-14b24e1f786d?w=300&h=450&fit=crop'">
                <div class="book-info">
                    <span class="badge <%= status.equals("Available") ? "badge-success" : "badge-warning" %>"><%= status %></span>
                    <h3 style="margin: 0.5rem 0 0.25rem; font-size: 1.1rem;"><%= title %></h3>
                    <p style="color: var(--text-muted); font-size: 0.85rem;"><%= author %></p>
                </div>
            </div>
        <%
                }
            } catch (Exception e) {
                out.println("<p>Error loading books: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</main>

<script src="js/main.js"></script>
</body>
</html>
