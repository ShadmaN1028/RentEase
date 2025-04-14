import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl =
      // Android Emulator Localhost
      "http://10.0.2.2:8000/api/v1/";

  final Dio _dio = Dio();
  Dio get dio => _dio;

  Future<Response> postRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      Response response = await _dio.post(
        "${baseUrl}${endpoint}",
        data: data,
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      return response;
    } catch (e) {
      throw Exception("API Request Failed: $e");
    }
  }
}
