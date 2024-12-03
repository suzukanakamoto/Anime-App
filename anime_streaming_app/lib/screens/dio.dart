import 'package:dio/dio.dart';

class AnimeService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchAnimeList() async {
    final response =
        await _dio.get('https://api.ryzendesu.vip/api/misc/server-info');
    return response.data;
  }

  Future<dynamic> fetchAnimeDetail(String id) async {
    final response =
        await _dio.get('https://api.ryzendesu.vip/api/misc/server-info');
    return response.data;
  }
}
