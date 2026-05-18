import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class ApiService {
  static const String baseUrl = 'https://zenquotes.io/api';
  
  // For dummyjson.com as backup (more reliable)
  static const String backupUrl = 'https://dummyjson.com/quotes';

  // READ - Fetch quotes from API
  Future<List<Quote>> fetchRandomQuotes({int count = 10}) async {
    try {
      // Using DummyJSON API (more reliable than ZenQuotes)
      final response = await http.get(
        Uri.parse('$backupUrl?limit=$count'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> quotesJson = data['quotes'];
        
        return quotesJson.map((json) {
          return Quote(
            id: json['id'].toString(),
            text: json['quote'],
            author: json['author'],
            savedDate: DateTime.now(),
          );
        }).toList();
      } else {
        throw Exception('Failed to load quotes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Alternative: Fetch single random quote
  Future<Quote> fetchSingleQuote() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/random'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        final quoteData = data[0];
        
        return Quote(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: quoteData['q'],
          author: quoteData['a'],
          savedDate: DateTime.now(),
        );
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
