package com.lms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;

@WebServlet("/TransactionServlet")
public class TransactionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String type = request.getParameter("type");
        String studentEmail = request.getParameter("studentEmail");
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        try (Connection conn = DBConnection.getConnection()) {
            if ("issue".equals(type)) {
                int durationWeeks = Integer.parseInt(request.getParameter("duration"));
                LocalDate issueDate = LocalDate.now();
                LocalDate dueDate = issueDate.plusWeeks(durationWeeks);

                // 1. Get user ID from email
                String userSql = "SELECT id FROM users WHERE email = ?";
                PreparedStatement pstUser = conn.prepareStatement(userSql);
                pstUser.setString(1, studentEmail);
                var rsUser = pstUser.executeQuery();
                
                if (rsUser.next()) {
                    int userId = rsUser.getInt("id");

                    // 2. Create transaction
                    String transSql = "INSERT INTO transactions (user_id, book_id, issue_date, due_date, status) VALUES (?, ?, ?, ?, 'active')";
                    PreparedStatement pstTrans = conn.prepareStatement(transSql);
                    pstTrans.setInt(1, userId);
                    pstTrans.setInt(2, bookId);
                    pstTrans.setObject(3, issueDate);
                    pstTrans.setObject(4, dueDate);
                    pstTrans.executeUpdate();

                    // 3. Update book availability
                    String bookSql = "UPDATE books SET available_copies = available_copies - 1 WHERE id = ?";
                    PreparedStatement pstBook = conn.prepareStatement(bookSql);
                    pstBook.setInt(1, bookId);
                    pstBook.executeUpdate();

                    response.sendRedirect("admin-issue.jsp?success=issued");
                } else {
                    response.sendRedirect("admin-issue.jsp?error=usernotfound");
                }
            } else if ("return".equals(type)) {
                // Return logic
                String returnSql = "UPDATE transactions SET return_date = ?, status = 'returned' WHERE user_id = (SELECT id FROM users WHERE email = ?) AND book_id = ? AND status != 'returned'";
                PreparedStatement pstReturn = conn.prepareStatement(returnSql);
                pstReturn.setObject(1, LocalDate.now());
                pstReturn.setString(2, studentEmail);
                pstReturn.setInt(3, bookId);
                int count = pstReturn.executeUpdate();

                if (count > 0) {
                    String bookSql = "UPDATE books SET available_copies = available_copies + 1 WHERE id = ?";
                    PreparedStatement pstBook = conn.prepareStatement(bookSql);
                    pstBook.setInt(1, bookId);
                    pstBook.executeUpdate();
                    response.sendRedirect("admin-issue.jsp?success=returned");
                } else {
                    response.sendRedirect("admin-issue.jsp?error=notrans");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-issue.jsp?error=db");
        }
    }
}
