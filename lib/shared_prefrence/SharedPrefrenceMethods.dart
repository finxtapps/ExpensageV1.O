import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceMethods {

  // 🔐 KEYS

  //
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userMobileNoKey = 'user_mobile';
  static const String _userMonthlyBudgetKey = 'user_monthly_budgets';
  static const String _userGenderKey = 'user_gender';
  static const String _currencyKey = 'user_currency';
  static const String _isLoginKey = 'is_logged_in';

  // ⭐ NEW KEY FOR IMAGE
  static const String _userImageKey = 'user_image';

  // -------------------------------
  // 🔵 SAVE METHODS
  // -------------------------------
  // Future<void> saveUserCurrency(String currency) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_currencyKey, currency);
  // }
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('Token saved: $token');
  }

  Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> saveUserMobileNo(String contact) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userMobileNoKey, contact);
  }
  Future<void> saveUserMonthlyBudget(String monthlyBudget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userMonthlyBudgetKey, monthlyBudget);
  }

  Future<void> saveUserGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userGenderKey, gender);
  }

  Future<void> saveUserCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  Future<void> saveIsUserLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoginKey, value);
  }

  // ⭐ NEW — SAVE IMAGE (Base64)
  Future<void> saveUserImage(Uint8List imgBytes) async {
    final prefs = await SharedPreferences.getInstance();
    String base64String = base64Encode(imgBytes);
    prefs.setString("userImage", base64String);
  }
  Future<void> saveUserImageFilename(String? filename) async {
    if (filename == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userProfileImageFilename", filename);
  }


  // -------------------------------
  // 🟢 GET METHODS
  // -------------------------------


  Future<String?> getUserImageFilename() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userProfileImageFilename");
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<String?> getUserMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userMobileNoKey);
  }
  Future<String?> getUserMonthlyBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userMonthlyBudgetKey);
  }

  Future<String?> getUserGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userGenderKey);
  }

  Future<String?> getUserCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey);
  }

  Future<bool> getUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoginKey) ?? false;
  }

  // ⭐ NEW — GET IMAGE (Uint8List)
  Future<String?> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userImage");
  }

  // -------------------------------
  // 🔴 CLEAR ALL
  // -------------------------------

  Future<void> clearAllPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

