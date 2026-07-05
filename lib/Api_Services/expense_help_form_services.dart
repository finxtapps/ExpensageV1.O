import 'dart:io';
import 'package:dio/dio.dart';

import '../Api_Models/expenseHelpFormModel.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../ulitity/NetworkManager.dart';

class ManageExpenseService {
  final SharedPreferenceMethods pref = SharedPreferenceMethods();
  final Dio _dio = Dio();

  final String baseUrl =
      "${NetworkManager().baseUrl}manage-expense";

  Future<ExpenseHelpFormModel?> submitExpense({
    required String fullName,
    required String email,
    required String phone,
    required int annualExpense,
    File? expenseProofFile,  // optional
  }) async {
    try {
      String? token = await pref.getToken();

      String? proofString;

      if (expenseProofFile != null) {
        // File allowed नहीं है backend me – only string expected
        proofString = expenseProofFile.path.split('/').last;
      }

      // 👉 Normal JSON body (NO multipart)
      final body = {
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "annualExpense": annualExpense.toString(),
        "expenseProof": proofString,  // null allowed
      };

      final response = await _dio.post(
        baseUrl,
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return ExpenseHelpFormModel.fromJson(response.data);
    } catch (e) {
      print("Error submitting expense: $e");
      return null;
    }
  }
}












// import 'dart:io';
// import 'package:dio/dio.dart';
//
// import '../Api_Models/expenseHelpFormModel.dart';
// import '../shared_prefrence/SharedPrefrenceMethods.dart';
//
// class ManageExpenseService {
//   final SharedPreferenceMethods pref = SharedPreferenceMethods();
//   final Dio _dio = Dio();
//
//   final String baseUrl =
//       "https://expense-tracker-backend-48vm.onrender.com/api/manage-expense";
//
//   Future<ExpenseHelpFormModel?> submitExpense({
//     required String fullName,
//     required String email,
//     required String phone,
//     required int annualExpense,
//     required File expenseProofFile,
//   }) async {
//     try {
//       String? token = await pref.getToken();
//
//       String fileName = expenseProofFile.path.split('/').last;
//
//       // 🔥 Multipart FormData
//       FormData formData = FormData.fromMap({
//         "fullName": fullName,
//         "email": email,
//         "phone": phone,
//         "annualExpense": annualExpense,
//         "expenseProof": await MultipartFile.fromFile(
//           expenseProofFile.path,
//           filename: fileName,
//         ),
//       });
//
//       final response = await _dio.post(
//         baseUrl,
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );
//
//       return ExpenseHelpFormModel.fromJson(response.data);
//     } catch (e) {
//       print("Error submitting expense: $e");
//       return null;
//     }
//   }
// }
