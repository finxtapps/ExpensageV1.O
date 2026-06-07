import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../Api_Models/SignUp_Model.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import 'notification_service.dart';

class SignUpAuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://expense-tracker-2k3t.onrender.com/api/auth",
      connectTimeout: const Duration(seconds: 350),
      receiveTimeout: const Duration(seconds: 350),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  final SharedPreferenceMethods _prefs = SharedPreferenceMethods();

  /// ✅ Returns true if signup succeeds, false otherwise
  Future<bool> signupWithSaveAndNavigate(
      SignupRequest request,
      BuildContext context,
      ) async {
    try {
      print("📤 Sending Signup Request: ${jsonEncode(request.toJson())}");

      final response = await _dio.post("/signup", data: request.toJson());
      dynamic data = response.data;

      print("📥 API Response: $data"); // 🔹 Print entire API response
      print("📥 Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        SignupResponse signupResponse = SignupResponse.fromJson(data);
        print("🔹 Parsed SignupResponse: $signupResponse");

        if (signupResponse.success) {
          final user = signupResponse.user;
          final token = signupResponse.token;

          print("🔐 TOKEN RECEIVED: $token");
          print("👤 USER RECEIVED: $user");

          if (token == null || token.isEmpty) {
            print("❌ FAILURE: TOKEN EMPTY");
            return false;
          }

          if (user == null || user["id"] == null) {
            print("❌ FAILURE: USER ID MISSING");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User ID missing in response")),
            );
            return false;
          }

          final String userId = user["id"].toString();
          print("👤 USER ID RECEIVED: $userId");

          // SAVE VALUES
          await _prefs.saveUserId(userId);
          await _prefs.saveToken(token);
          await _prefs.saveUserName(request.name);
          await _prefs.saveUserEmail(request.email);
          await _prefs.saveUserMobileNo(request.phone);
          await _prefs.saveUserGender(request.gender);
          await _prefs.saveUserCurrency(request.currency);
          await _prefs.saveIsUserLogin(true);
          await NotificationService.registerFCMToken();

          print("✅ FCM Token registered successfully!");
          // NAVIGATE
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);

          return true;
        } else {
          print("❌ FAILURE: API returned success=false");
          print("🔹 Message from API: ${signupResponse.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Something went wrong: ${signupResponse.message}")),
          );
          return false;
        }
      } else {
        print("❌ FAILURE: Status Code Not 200/201");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: Please try again later")),
        );
        return false;
      }
    }  on DioException catch (e) {

  print("ERROR TYPE => ${e.type}");
  print("ERROR DATA => ${e.response?.data}");
  print("ERROR STATUS => ${e.response?.statusCode}");
  print("ERROR MESSAGE => ${e.message}");

  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
  content: Text(
  e.response?.data?["message"] ??
  e.message ??
  "Request Failed",
  ),
  ),
  );

  return false;
  }
  }
}
