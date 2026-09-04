import 'package:dio/dio.dart';
import 'package:untitled/core/utils/token.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl = 'http://127.0.0.1:8000/api/';

  ApiService({required Dio dio}) : _dio = dio;

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    final token = await Token().gettoken();
    final response = await _dio.post(
      '$baseUrl$endpoint',
      data: data,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
    return response;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await Token().gettoken();
    final headers = token != null ? {'Authorization': 'Bearer $token'} : null;
    final response = await _dio.get(
      '$baseUrl$endpoint',
      options: Options(headers: headers),
    );
    return response.data;
  }
}
