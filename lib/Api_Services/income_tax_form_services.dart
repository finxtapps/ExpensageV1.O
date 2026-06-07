import 'dart:io';
import 'package:dio/dio.dart';
import '../Api_Models/Income_tax_help_form_model.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';

class IncomeTaxHelpService {
  final Dio _dio = Dio();
  final SharedPreferenceMethods pref = SharedPreferenceMethods();

  final String apiUrl =
      "https://expense-tracker-2k3t.onrender.com/api/income-tax-help";

  Future<dynamic> submitIncomeTaxHelp({
    required IncomeTaxHelpModel model,
    File? incomeStatementFile, // optional file
  }) async {
    try {
      String? token = await pref.getToken();

      if (token == null) {
        throw Exception("Token not found!");
      }

      dynamic data;

      // 👉 If file exists → send as Multipart
      if (incomeStatementFile != null) {
        String fileName = incomeStatementFile.path.split('/').last;

        data = FormData.fromMap({
          "fullName": model.fullName,
          "email": model.email,
          "phone": model.phone,
          "annualIncome": model.annualIncome,
          "incomeStatement": await MultipartFile.fromFile(
            incomeStatementFile.path,
            filename: fileName,
          ),
        });
      } else {
        // 👉 No file → send JSON
        data = model.toJson();
      }

      final response = await _dio.post(
        apiUrl,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // ✅ FIXED
            "Content-Type": incomeStatementFile != null
                ? "multipart/form-data"
                : "application/json",
          },
        ),
      );

      return response.data;
    } catch (e) {
      print("INCOME TAX HELP ERROR: $e");
      return null;
    }
  }
}
