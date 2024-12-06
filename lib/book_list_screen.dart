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
  String query = 'literature';
  int currentPage = 1;
  bool isLoading = false;

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
          page: currentPage, query: query, maxResults: 8);
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
        favoriteBooks.remove(book);
      } else {
        favoriteBooks.add(book);
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

  void changeCategory(String category) {
    setState(() {
      books.clear();
      currentPage = 1;
      query = category.toLowerCase();
    });
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A1B9A),
        title: Row(
          children: [
            Spacer(),
            Text("Books", style: TextStyle(fontSize: 32, color: Colors.white)),
            Spacer(),
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onSubmitted: searchBooks,
              decoration: InputDecoration(
                hintText: 'Search books...',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Color(0xFF6A1B9A)),
                filled: true,
                fillColor: Color(0xFFF1E6FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Color(0xFF6A1B9A), width: 2),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () => changeCategory(category),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 230, 215, 248),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(color: Color(0xFF6A1B9A)),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 8,
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
                      color: Color.fromARGB(255, 237, 227, 250),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.black.withOpacity(0.3),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book['volumeInfo']['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6A1B9A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          authorName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 221, 162, 247),
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
                                              : Color(0xFF6A1B9A),
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
