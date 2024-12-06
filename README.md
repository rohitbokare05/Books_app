# 📚 Books App

**Books App** is a Flutter application that provides users with a seamless way to discover, search, and save their favorite books. The app connects to a books API to fetch dynamic data, offering an immersive and user-friendly interface.

---

## 🌟 Features

1. **Book Discovery**: Explore a dynamic collection of books fetched via an API.
2. **Search Functionality**: Find books quickly by entering a keyword, author name, or title.
3. **Popular Categories**:
   - Browse through books by selecting from popular genres displayed as buttons below the search bar. Available categories:
     - Literature
     - Romance
     - Thriller
     - Drama
     - Murder Mystery
     - Science Fiction
     - Self-help
     - Adventure
     - Biography
     - Fantasy
4. **Favorites List**:
   - Save books to a dedicated list for easy access.
5. **Book Details**:
   - View book-specific details such as title, author, and cover image.
6. **Infinite Scrolling**:
   - Continuously load more books as you scroll.
7. **Clean and Modern UI**:
   - Responsive grid layout.
   - Rounded cards for book previews.
   - Intuitive search and filter options.

---

## 📂 Project Structure

- **Screens**:
  - `BookListScreen`: Displays the book grid with search and category options.
  - `BookDetailScreen`: Provides detailed information about a selected book.
  - `FavoriteBooksScreen`: Lists books added to the favorites collection.

- **API Integration**:
  - Uses `ApiService` for fetching data dynamically from the API.

- **State Management**:
  - Manages the list of books, search queries, and favorites using stateful widgets.

---

## 🎨 User Interface Highlights

- **Search Bar**:
  - Clean design with a prefix search icon.
  - Dynamically updates results based on user input.
- **Category Buttons**:
  - Interactive buttons for filtering by popular genres.
  - Positioned below the search bar for easy access.
- **Book Cards**:
  - Beautifully styled with rounded corners and subtle shadows.
  - Includes book title and truncated author name.

---

