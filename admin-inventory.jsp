<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*, com.lms.DBConnection" %>
        <% // Ensure the user is logged in as admin HttpSession adminSession=request.getSession(false); if
            (adminSession==null || !"admin".equals(adminSession.getAttribute("userRole"))) {
            response.sendRedirect("index.jsp"); return; } %>
            <!DOCTYPE html>
            <html lang="en" data-theme="light">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin Inventory - LibCore</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="css/style.css">
            </head>

            <body>

                <div class="dashboard-container">
                    <aside class="sidebar">
                        <div
                            style="font-family: 'Outfit'; font-weight: 700; font-size: 1.75rem; color: var(--primary); margin-bottom: 2.5rem;">
                            <i class="fas fa-shield-alt"></i> LibAdmin
                        </div>

                        <nav style="display: flex; flex-direction: column; gap: 0.5rem;">
                            <a href="admin-inventory.jsp" class="nav-link active"><i class="fas fa-box"></i> Inventory
                                Manager</a>
                            <a href="admin-issue.jsp" class="nav-link"><i class="fas fa-exchange-alt"></i> Issue/Return
                                Portal</a>
                        </nav>

                        <div style="margin-top: auto;">
                            <a href="LogoutServlet" class="nav-link" style="color: #ef4444;"><i
                                    class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </aside>

                    <main class="main-content" style="padding: 3rem;">
                        <header
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 3rem;">
                            <div>
                                <h1 style="font-size: 2.5rem; margin-bottom: 0.5rem;">Inventory Manager</h1>
                                <p style="color: var(--text-muted);">Manage your library's collection from the database.
                                </p>
                            </div>
                            <button class="btn btn-primary"
                                onclick="alert('In a real app, this would open the Add Book form!')"><i
                                    class="fas fa-plus"></i> Add New Book</button>
                        </header>

                        <div class="glass" style="padding: 2rem; border-radius: 1.5rem;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Book ID</th>
                                        <th>Preview</th>
                                        <th>Title & Author</th>
                                        <th>Category</th>
                                        <th>Stock</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% try (Connection conn=DBConnection.getConnection()) { String
                                        sql="SELECT * FROM books" ; Statement stmt=conn.createStatement(); ResultSet
                                        rs=stmt.executeQuery(sql); while (rs.next()) { int id=rs.getInt("id"); String
                                        title=rs.getString("title"); String author=rs.getString("author"); String
                                        category=rs.getString("category"); int avail=rs.getInt("available_copies"); int
                                        total=rs.getInt("total_copies"); %>
                                        <tr>
                                            <td><strong>#LIB-<%= String.format("%04d", id) %></strong></td>
                                            <td><img src="<%= rs.getString(" cover_url") %>" style="width: 40px; height:
                                                60px; object-fit: cover; border-radius: 4px;"
                                                onerror="this.src='https://images.unsplash.com/photo-1543005814-14b24e1f786d?w=40&h=60&fit=crop'">
                                            </td>
                                            <td>
                                                <div style="font-weight: 600;">
                                                    <%= title %>
                                                </div>
                                                <div style="font-size: 0.75rem; color: var(--text-muted);">
                                                    <%= author %>
                                                </div>
                                            </td>
                                            <td>
                                                <%= category %>
                                            </td>
                                            <td><span style="font-weight: 500;">
                                                    <%= avail %> / <%= total %>
                                                </span></td>
                                            <td>
                                                <div style="display: flex; gap: 1rem;">
                                                    <button class="btn"
                                                        style="padding: 0.5rem; color: var(--primary); font-size: 1rem;"><i
                                                            class="fas fa-edit"></i></button>
                                                    <button class="btn"
                                                        style="padding: 0.5rem; color: var(--error); font-size: 1rem;"><i
                                                            class="fas fa-trash"></i></button>
                                                </div>
                                            </td>
                                        </tr>
                                        <% } } catch (Exception e) { out.println("Error: " + e.getMessage());
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src=" js/main.js">
</script>
            </body>

            </html>