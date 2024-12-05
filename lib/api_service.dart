import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Google Books API URL
  final String baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  // Fetch books by query (title, author, etc.)
  Future<Map<String, dynamic>> fetchBooks(
      {int page = 1,
      String query = 'literature',
      required int maxResults}) async {
    final int startIndex = (page - 1) * 10; // 10 books per page
    // final url =
    //     Uri.parse('$baseUrl?q=$query&startIndex=$startIndex&maxResults=10');
    // final url = Uri.parse(
    //     '$baseUrl?q=$query&startIndex=$startIndex&maxResults=${maxResults.clamp(1, 40)}');
    final String apiKey =
        'AIzaSyBIqXVopyFklhBS0PLLlCt87jLUFHj0mMk'; // Replace with your key
    final url = Uri.parse(
        '$baseUrl?q=$query&startIndex=$startIndex&maxResults=$maxResults&key=$apiKey');

    final response = await http.get(url);

    // if (response.statusCode == 200) {
    //   return json.decode(response.body); // Returns a map of book data
    // } else {
    //   throw Exception('Failed to load books');
    // }
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load books');
    }
  }
}
