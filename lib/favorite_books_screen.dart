import 'package:books_app/book_detail_screen.dart';
// import 'package:books_app/bookdetails.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteBooks;

  // Constructor to accept favoriteBooks as a parameter
  FavoritesScreen({required this.favoriteBooks});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    // Use the passed favoriteBooks
    final favoriteBooks = widget.favoriteBooks;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Books"),
      ),
      body: favoriteBooks.isEmpty
          ? Center(child: Text('No favorite books yet.'))
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return ListTile(
                  title: Text(book['volumeInfo']['title']),
                  subtitle: Text(book['volumeInfo']['authors']?.join(', ') ??
                      'Unknown Author'),
                  onTap: () {
                    // Navigate to Book Detail Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(book: book),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
