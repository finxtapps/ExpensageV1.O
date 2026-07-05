import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Api_Models/SignIn_model.dart';
import '../providerListner/profile_notifier.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../ulitity/NetworkManager.dart';
import 'notification_service.dart';

class LoginAuthService {
  static final String _baseUrl =
      "${NetworkManager().baseUrl}auth";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final SharedPreferenceMethods _prefs = SharedPreferenceMethods();

  /// 🔐 LOGIN FUNCTION
  Future<LoginResponse?> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      print('🛰️ Full Login Response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final loginResponse = LoginResponse.fromJson(response.data);

        if (loginResponse.success) {
          final user = loginResponse.data.user;
          final token = loginResponse.data.token;

          print("👤 User ID: ${user.id}");
          print("🔐 Token: $token");

          // 🌟 Save User Details
          await _prefs.saveUserName(user.name);
          await _prefs.saveUserEmail(user.email);
          await _prefs.saveUserMobileNo(user.phone ?? "");
          await _prefs.saveUserGender(user.gender ?? "");
          await _prefs.saveUserCurrency(user.currency ?? "");
          await _prefs.saveUserId(user.id);
          await _prefs.saveIsUserLogin(true);


          final imagePath = user.profilePicture;

          if (imagePath != null && imagePath.isNotEmpty) {

            String fullImageUrl =
                "https://expense-tracker-2k3t.onrender.com$imagePath";

            await _prefs.saveUserImageFilename(fullImageUrl);

            context.read<ProfileNotifier>().updateProfileImageFromApi(fullImageUrl);

          }


          // Save token
          if (token.isNotEmpty) {
            await _prefs.saveToken(token);

            print("✅ Token saved successfully!");

            await NotificationService.registerFCMToken();

            print("✅ FCM Token registered successfully!");
          }
          // For debugging
          await checkToken();

          // Navigate
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
                (route) => false,
          );

          return loginResponse;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loginResponse.message)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text('Server Error: ${response.statusCode ?? "Unknown"}'),
          ),
        );
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? "Something went wrong";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ $msg")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Unexpected Error: $e")),
      );
    }

    return null;
  }

  /// 🔎 TOKEN CHECK
  Future<void> checkToken() async {
    final token = await _prefs.getToken();
    debugPrint("🔑 Saved Token: $token");
  }
}






