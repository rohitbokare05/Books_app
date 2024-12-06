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
  @override
  void initState() {
    super.initState();
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
        title: Padding(
          padding: const EdgeInsets.only(left: 90.0),
          child: Text(
            "Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        backgroundColor: Color(0xFF6A1B9A),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  title.length > 30 ? title.substring(0, 30) + "..." : title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Author(s): $authors',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF6A1B9A),
              ),
            ),
            SizedBox(height: 16),
            imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(
                      color: Color(0xFF6A1B9A),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Color(0xFF6A1B9A),
                    ),
                    height: 450,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/placeholder.jpg',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            if (widget.book['volumeInfo']['publishedDate'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Published: ${widget.book['volumeInfo']['publishedDate']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),
            if (widget.book['volumeInfo']['categories'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Categories: ${widget.book['volumeInfo']['categories'].join(', ')}',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
