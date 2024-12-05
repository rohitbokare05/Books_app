import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookDetailScreen extends StatefulWidget {
  final dynamic book;
  BookDetailScreen({required this.book});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite(); // Check if the current book is a favorite on initial load
  }

  // Check if the current book is in the favorites list
  Future<void> checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteBooks = prefs.getStringList('favorites') ?? [];
    final bookId = widget.book['id'];

    setState(() {
      isFavorite = favoriteBooks.contains(bookId);
    });
  }

  // Function to toggle the favorite status
  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteBooks = prefs.getStringList('favorites') ?? [];
    final bookId = widget.book['id'];

    setState(() {
      if (isFavorite) {
        favoriteBooks.remove(bookId);
      } else {
        favoriteBooks.add(bookId);
      }
      isFavorite = !isFavorite;
    });

    // Save the updated favorite list
    await prefs.setStringList('favorites', favoriteBooks);
    print(favoriteBooks); // Optional: Log the list for debugging
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.book['volumeInfo']['title'] ?? 'No Title Available';
    final authors =
        widget.book['volumeInfo']['authors']?.join(', ') ?? 'Unknown Author';
    final description =
        widget.book['volumeInfo']['description'] ?? 'No description available.';
    final imageUrl = widget.book['volumeInfo']['imageLinks']?['thumbnail'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        // actions: [
        //   // Favorite Button (Heart Icon)
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16.0, top: 10),
        //     child: IconButton(
        //       icon: Icon(
        //         isFavorite ? Icons.favorite : Icons.favorite_border,
        //         color: isFavorite ? Colors.red : Colors.black,
        //       ),
        //       onPressed: toggleFavorite, // Toggle the favorite status
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 1.0, right: 16, left: 16, bottom: 16),
        child: ListView(
          children: [
            // Title
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Author(s)
            Text(
              'Author(s): $authors',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            // Book Cover Image
            imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 450,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/placeholder.jpg', // Fallback image if no image URL
                    height: 300,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 16),

            // Description
            Text(
              'Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),

            // Additional Information (e.g., publication year, categories)
            if (widget.book['volumeInfo']['publishedDate'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Published: ${widget.book['volumeInfo']['publishedDate']}',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            if (widget.book['volumeInfo']['categories'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Categories: ${widget.book['volumeInfo']['categories'].join(', ')}',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
