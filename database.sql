-- Library Management System Database Schema
-- Run this in MySQL Workbench

CREATE DATABASE IF NOT EXISTS lib_db;
USE lib_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'admin') DEFAULT 'student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Books Table
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    cover_url VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('active', 'returned', 'overdue') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- 4. Initial Sample Data
-- Sample Users
INSERT INTO users (name, email, password, role) VALUES 
('LMS Administrator', 'admin@library.com', 'admin123', 'admin'),
('John Doe Student', 'student@library.com', 'student123', 'student');

-- Sample Books
INSERT INTO books (title, author, category, total_copies, available_copies, cover_url, description) VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 5, 5, 'https://images.unsplash.com/photo-1543005814-14b24e1f786d?q=80&w=300&h=450&auto=format&fit=crop', 'The Great Gatsby is a 1925 novel by American writer F. Scott Fitzgerald.'),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 3, 2, 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=300&h=450&auto=format&fit=crop', 'The novel depicts first-person narrator Nick Carraways interactions.'),
('1984', 'George Orwell', 'Dystopian', 10, 10, 'https://images.unsplash.com/photo-1541963463532-d68292c34b19?q=80&w=300&h=450&auto=format&fit=crop', '1984 is a dystopian social science fiction novel and cautionary tale.');

-- Sample Transactions
-- Book #2 is borrowed by student
INSERT INTO transactions (user_id, book_id, issue_date, due_date, status) VALUES 
(2, 2, '2023-10-15', '2023-10-29', 'active');
