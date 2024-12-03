import 'package:dio/dio.dart';

// Base URL of Jikan API
const String baseUrl = 'https://api.jikan.moe/v4';

class AnimeService {
  final Dio _dio = Dio();

  // Function to fetch popular anime
  Future<List<dynamic>> fetchPopularAnime() async {
    try {
      final response = await _dio.get('$baseUrl/top/anime');
      return response.data['data']; // Return the list of anime
    } catch (e) {
      print('Error fetching anime: $e');
      return [];
    }
  }
}
