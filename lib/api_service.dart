import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<Map<String, dynamic>> fetchBooks(
      {int page = 1,
      String query = 'literature',
      required int maxResults}) async {
    final int startIndex = (page - 1) * 10;
    final String apiKey = 'AIzaSyBIqXVopyFklhBS0PLLlCt87jLUFHj0mMk';
    final url = Uri.parse(
        '$baseUrl?q=$query&startIndex=$startIndex&maxResults=$maxResults&key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load books');
    }
  }
}
