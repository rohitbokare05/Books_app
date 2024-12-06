import 'package:books_app/book_detail_screen.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteBooks;

  FavoritesScreen({required this.favoriteBooks});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteBooks = widget.favoriteBooks;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Text(
            "Favorite Books",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        backgroundColor: Color(0xFF6A1B9A),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 253, 253, 253)),
      ),
      body: favoriteBooks.isEmpty
          ? Center(
              child: Text(
                'No favorite books yet.',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6A1B9A),
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Color(0xFFF1E6FF),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(
                      Icons.book,
                      size: 40,
                      color: Color(0xFF6A1B9A),
                    ),
                    title: Text(
                      book['volumeInfo']['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A1B9A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        book['volumeInfo']['authors']?.join(', ') ??
                            'Unknown Author',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFB388EB),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Color(0xFF6A1B9A),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(book: book),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
