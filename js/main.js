// Library Management System - Main Logic
// Handles Theme Toggle, Navigation, and Mock Data

document.addEventListener('DOMContentLoaded', () => {
    initTheme();
    initMobileNav();
    // Add more initializers as needed
});

/**
 * Theme Management
 */
function initTheme() {
    const savedTheme = localStorage.getItem('theme') || 
                      (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    
    document.documentElement.setAttribute('data-theme', savedTheme);
    updateThemeIcon(savedTheme);

    // Create theme toggle button if it doesn't exist
    if (!document.querySelector('.theme-toggle')) {
        const toggleBtn = document.createElement('button');
        toggleBtn.className = 'theme-toggle btn';
        toggleBtn.innerHTML = '<i class="fas fa-moon"></i>';
        toggleBtn.onclick = toggleTheme;
        document.body.appendChild(toggleBtn);
        updateThemeIcon(savedTheme);
    }
}

function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    updateThemeIcon(newTheme);
}

function updateThemeIcon(theme) {
    const icon = document.querySelector('.theme-toggle i');
    if (icon) {
        icon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
    }
}

/**
 * Navigation & Mobile Sidebar
 */
function initMobileNav() {
    // Logic for showing/hiding sidebar on mobile
}

/**
 * Mock Data for Frontend Preview
 */
const MOCK_BOOKS = [
    {
        id: 1,
        title: "The Great Gatsby",
        author: "F. Scott Fitzgerald",
        category: "Classic",
        status: "Available",
        cover: "https://images.unsplash.com/photo-1543005814-14b24e1f786d?q=80&w=300&h=450&auto=format&fit=crop"
    },
    {
        id: 2,
        title: "To Kill a Mockingbird",
        author: "Harper Lee",
        category: "Fiction",
        status: "Borrowed",
        cover: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=300&h=450&auto=format&fit=crop"
    },
    {
        id: 3,
        title: "1984",
        author: "George Orwell",
        category: "Dystopian",
        status: "Available",
        cover: "https://images.unsplash.com/photo-1541963463532-d68292c34b19?q=80&w=300&h=450&auto=format&fit=crop"
    }
];

// Export for other scripts
window.LMS = {
    books: MOCK_BOOKS,
    toggleTheme,
    updateThemeIcon
};
