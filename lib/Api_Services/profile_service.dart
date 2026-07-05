import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../ulitity/NetworkManager.dart';

class ProfileService {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${NetworkManager().baseUrl}",
    ),
  );

  final SharedPreferenceMethods _prefs = SharedPreferenceMethods();

  /// --------------------------------------------------------
  /// UPDATE PROFILE
  /// --------------------------------------------------------
  Future<bool> submitProfile({
    required String userId,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? currency,
    File? profilePic,
  }) async {
    try {

      FormData formData = FormData.fromMap({

        if (name != null && name.isNotEmpty)
          "name": name,

        if (email != null && email.isNotEmpty)
          "email": email,

        if (phone != null && phone.isNotEmpty)
          "phone": phone,

        if (gender != null && gender.isNotEmpty)
          "gender": gender.toLowerCase(),

        if (currency != null && currency.isNotEmpty)
          "currency": currency,

        if (profilePic != null)
          "profilePicture": await MultipartFile.fromFile(
            profilePic.path,
            filename: basename(profilePic.path),
          ),
      });

      final response = await _dio.put(
        "/profiles/user/$userId",
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

      if (response.statusCode == 200 &&
          response.data["success"] == true) {

        final data = response.data["data"];
        final profile = data["profile"];
        final user = data["user"];

        String? image =
            user?["profilePicture"] ?? profile?["profilePicture"];

        if (image != null && image.isNotEmpty) {
          image =
          "${NetworkManager().baseUrl}$image";
        }

        await _prefs.saveUserName(profile?["name"] ?? "");
        await _prefs.saveUserEmail(profile?["email"] ?? "");
        await _prefs.saveUserMobileNo(profile?["phone"] ?? "");
        await _prefs.saveUserGender(profile?["gender"] ?? "");
        await _prefs.saveUserCurrency(profile?["currency"] ?? "");

        if (image != null && image.isNotEmpty) {
          await _prefs.saveUserImageFilename(image);
        }

        return true;
      }

      return false;

    } catch (e) {

      if (e is DioException) {
        debugPrint("STATUS CODE: ${e.response?.statusCode}");
        debugPrint("RESPONSE DATA: ${e.response?.data}");
      }

      return false;
    }
  }
}
