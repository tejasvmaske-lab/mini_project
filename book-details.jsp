<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lms.DBConnection" %>
<%
    // Ensure the user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int bookId = Integer.parseInt(request.getParameter("id"));
    String title = "", author = "", category = "", description = "", cover = "", status = "";
    int available = 0;

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT * FROM books WHERE id = ?";
        PreparedStatement pst = conn.prepareStatement(sql);
        pst.setInt(1, bookId);
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            author = rs.getString("author");
            category = rs.getString("category");
            description = rs.getString("description");
            cover = rs.getString("cover_url");
            available = rs.getInt("available_copies");
            status = available > 0 ? "Available" : "Borrowed";
        } else {
            response.sendRedirect("home.jsp");
            return;
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %> - LibCore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .details-container { display: grid; grid-template-columns: 350px 1fr; gap: 4rem; margin-top: 2rem; }
        .book-img-large { width: 100%; border-radius: 1.5rem; box-shadow: 0 20px 40px rgba(0,0,0,0.2); }
        .stat-card { padding: 1.25rem; border-radius: 1rem; background: var(--bg-surface); border: 1px solid var(--border); text-align: center; }
    </style>
</head>
<body>

<nav class="top-nav glass" style="padding: 1rem 2rem;">
    <a href="home.jsp" style="text-decoration: none; color: var(--text-main); font-weight: 500;">
        <i class="fas fa-arrow-left"></i> Back to Discover
    </a>
</nav>

<main class="main-content">
    <div class="details-container">
        <aside>
            <img src="<%= cover %>" class="book-img-large">
        </aside>

        <section>
            <span class="badge <%= available > 0 ? "badge-success" : "badge-warning" %>" style="font-size: 0.9rem; margin-bottom: 1rem;"><%= status %></span>
            <h1 style="font-size: 3rem; margin-bottom: 0.5rem;"><%= title %></h1>
            <p style="font-size: 1.5rem; color: var(--text-muted); margin-bottom: 2rem;">by <%= author %></p>

            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; margin-bottom: 3rem;">
                <div class="stat-card">
                    <p style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase;">Category</p>
                    <p style="font-weight: 600;"><%= category %></p>
                </div>
                <div class="stat-card">
                    <p style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase;">Rating</p>
                    <p style="font-weight: 600; color: var(--accent);"><i class="fas fa-star"></i> 4.8/5</p>
                </div>
                <div class="stat-card">
                    <p style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase;">Stock</p>
                    <p style="font-weight: 600;"><%= available %> Remaining</p>
                </div>
            </div>

            <div style="margin-bottom: 3rem;">
                <h3 style="margin-bottom: 1rem;">About this Book</h3>
                <p style="color: var(--text-muted); line-height: 1.8;"><%= description %></p>
            </div>

            <% if (available > 0) { %>
                <button class="btn btn-primary" style="padding: 1.25rem 3rem; font-size: 1.1rem; border-radius: 1rem;" onclick="alert('In a real app, this would send an issue request to the admin!')">
                    Borrow this Book <i class="fas fa-chevron-right"></i>
                </button>
            <% } else { %>
                <button class="btn" disabled style="padding: 1.25rem 3rem; font-size: 1.1rem; border-radius: 1rem; opacity: 0.5;">
                    Currently Unavailable
                </button>
            <% } %>
        </section>
    </div>
</main>

<script src="js/main.js"></script>
</body>
</html>
