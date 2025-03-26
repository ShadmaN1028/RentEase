import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rentease/models/user_model.dart';
import 'package:rentease/services/api_services.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final Dio _dio = Dio();

  Future<Response> signup(UserModel user, bool isOwner) async {
    String endpoint = isOwner ? "/owner/signup" : "/tenant/signup";

    try {
      final userData = user.toJson(isOwner);
      log(endpoint);
      log(
        "User data to be sent: $userData",
      ); // Logging the user.toJson(isOwner)

      Response response = await _apiService.postRequest(endpoint, userData);
      return response;
    } catch (e) {
      throw Exception("Signup failed: $e");
    }
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password,
    bool isOwner,
  ) async {
    String endpoint = isOwner ? "/owner/login" : "/tenant/login";

    try {
      log(ApiService.baseUrl);
      log(endpoint);
      log("Email: $email, Password: $password");
      Response response = await _dio.post(
        "${ApiService.baseUrl}${endpoint}",
        data:
            isOwner
                ? {"owner_email": email, "owner_password": password}
                : {"user_email": email, "user_password": password},
      );
      log("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": response.data["data"],
          "message": response.data["message"],
        };
      } else {
        return {"success": false, "message": response.data["message"]};
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong. Please try again later.",
      };
    }
  }
}
