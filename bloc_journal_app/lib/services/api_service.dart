import 'package:dio/dio.dart';
import '../models/quote.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  Future<List<Quote>> fetchQuotes({int limit = 15}) async {
    try {
      final response = await _dio.get('/quotes?limit=$limit');
      
      if (response.statusCode == 200) {
        final List<dynamic> quotesJson = response.data['quotes'];
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
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}