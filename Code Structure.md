**Code Structure**

This project is organized to ensure modularity, clarity, and easy maintenance. Below is an overview of the directory and file structure of the project.

**Lib**

This directory contains all the Dart files responsible for the app's logic, UI, and functionality.

- **book\_list\_screen.dart**:
  - This is the main screen of the app where a list of books is displayed.
  - It includes search functionality, category filtering, and the ability to fetch more books as the user scrolls.
  - It also handles managing and displaying the user's favorite books.
  - Uses ApiService to fetch books from the Google Books API and updates the UI accordingly.
- **api\_service.dart**:
  - This file contains the ApiService class, which is responsible for making HTTP requests to the Google Books API.
  - The fetchBooks method retrieves books based on search queries and pagination parameters.
- **book\_detail\_screen.dart**:
  - This screen shows detailed information about a selected book, including its title, authors, description, and image.
  - It receives the book's data from the book\_list\_screen.dart when a book is tapped and displays the details.
- **favorite\_books\_screen.dart**:
  - This screen displays a list of the user’s favorite books. It is shown when the user clicks on the favorite icon in the BookListScreen.

**assets/**

This folder contains static assets such as images used in the app.

- **placeholder.jpg**: 
  - This is a placeholder image shown when a book doesn't have an image URL.

**Widgets**

- If you create reusable components like custom buttons, icons, or layout sections, this folder would hold the widget files.

**test**

- This folder contains tests to ensure the app’s features work as expected. You might include unit tests, widget tests, or integration tests here.
-----
**Code Flow**

1. **App Initialization**:
   1. The app is initialized in main.dart (not provided in the snippet), where the entry point is set.
   1. The BookListScreen is displayed first, showing a list of books fetched from the Google Books API.
1. **Fetching Data**:
   1. When the user scrolls to the bottom of the BookListScreen, the app triggers the fetchBooks function to fetch more books, based on the current page number (currentPage).
   1. The ApiService class fetches books by making an HTTP request to the Google Books API. The books are then displayed in a grid layout on the BookListScreen.
1. **Searching and Filtering**:
   1. The search functionality is handled by the TextField widget in the BookListScreen. When the user submits a query, the app clears the current list of books and fetches new ones based on the entered query.
   1. The categories are shown as horizontal buttons, and when a category is selected, it updates the search query and fetches books from that category.
1. **Favorites**:
   1. Each book card includes a favorite button. When clicked, the book is either added or removed from the favoriteBooks list.
   1. The favorites are stored in memory during the session, and the user can view their favorite books in the FavoritesScreen.
1. **Book Details**:
   1. When a book is tapped in the BookListScreen, the app navigates to the BookDetailScreen, passing the book data to display more detailed information such as description, authors, categories, and a larger image.
-----
**File Breakdown**

- **BookListScreen**:
  - Handles displaying the list of books, search functionality, category selection, and pagination.
  - Integrates with ApiService to fetch data from the Google Books API and handles user interaction, including adding/removing books from favorites.
- **ApiService**:
  - Makes HTTP requests to the Google Books API to retrieve books based on specific search queries and categories.
  - Handles pagination to load books in chunks.
- **BookDetailScreen**:
  - Displays detailed information about a selected book, including its image, description, authors, publication date, and categories.
- **FavoriteBooksScreen**:
  - Displays a list of the user’s favorite books, which can be accessed via the heart icon in the app bar of BookListScreen.
