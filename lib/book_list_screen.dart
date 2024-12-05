import 'package:books_app/favorite_books_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api_service.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> books = [];
  List<Map<String, dynamic>> favoriteBooks = [];
  String query = 'literature'; // Default query for initial category
  int currentPage = 1;
  bool isLoading = false;

  // Categories list
  List<String> categories = [
    'Adventure',
    'Self-Help',
    'Young Adult (YA)',
    'Children\'s Books',
    'Classics',
    'Poetry',
    'Art',
    'Cooking',
    'Health & Wellness',
    'Fantasy',
    'Romance',
    'Thriller',
    'Drama',
    'Mystery',
    'Science Fiction',
    'Historical Fiction',
    'Horror',
    'Biography',
    'True Crime',
    'Literary Fiction',
  ];

  @override
  void initState() {
    super.initState();
    fetchBooks();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchBooks();
      }
    });
  }

  Future<void> fetchBooks() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await apiService.fetchBooks(
          page: currentPage, query: query, maxResults: 5);
      setState(() {
        books.addAll(data['items']);
        currentPage++;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleFavorite(Map<String, dynamic> book) {
    setState(() {
      if (favoriteBooks.contains(book)) {
        favoriteBooks.remove(book); // Remove from favorites if already added
      } else {
        favoriteBooks.add(book); // Add to favorites
      }
    });
  }

  void searchBooks(String newQuery) {
    setState(() {
      books.clear();
      currentPage = 1;
      query = newQuery.isEmpty ? 'literature' : newQuery;
    });
    fetchBooks();
  }

  // New method to handle category button press
  void changeCategory(String category) {
    setState(() {
      books.clear();
      currentPage = 1;
      query = category.toLowerCase(); // Set the query to selected category
    });
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 140),
                Text("Books", style: TextStyle(fontSize: 32)),
                SizedBox(width: 120),
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FavoritesScreen(favoriteBooks: favoriteBooks),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextField(
              onSubmitted: searchBooks, // Trigger search when user submits
              decoration: InputDecoration(
                hintText: 'Search books...',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Category Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 40.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => changeCategory(category),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    ),
                    child: Text(category),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 8),

          // Book Grid
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.6,
              ),
              itemCount: books.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < books.length) {
                  final book = books[index];
                  final imageUrl =
                      book['volumeInfo']['imageLinks']?['thumbnail'];
                  String authorName =
                      book['volumeInfo']['authors']?.join(', ') ?? 'Unknown';
                  authorName = authorName.length > 10
                      ? authorName.substring(0, 10)
                      : authorName;
                  bool isFavorite = favoriteBooks.contains(book);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(book: book),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white30,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      shadowColor:
                          Colors.black.withOpacity(0.5), // Subtle shadow color
                      margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16), // Margin around the card
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            15), // Rounded corners for the content as well
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Book Cover Image
                            CachedNetworkImage(
                              imageUrl: imageUrl ?? '',
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              width: double.infinity,
                              height: 240,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  12.0), // Increased padding for better spacing
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Book Title
                                  Text(
                                    book['volumeInfo']['title'],
                                    style: TextStyle(
                                      fontSize:
                                          18, // Slightly larger font for the title
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                      height:
                                          8), // Increased spacing between title and author
                                  // Author Name
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          authorName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[
                                                700], // Slightly darker grey for better readability
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: () => toggleFavorite(book),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
