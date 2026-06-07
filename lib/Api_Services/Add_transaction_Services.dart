import 'dart:io';
import 'package:dio/dio.dart';

class TransactionService{
final Dio dio = Dio(
  BaseOptions(
    baseUrl: "https://expense-tracker-2k3t.onrender.com/api",
    //baseUrl: "https://expense-tracker-backend-48vm.onrender.com/api",
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ),
);

Future<bool> createTransaction({
  required String token,
  required String userId,
  required String item,
  required String type,
  required String icon,
  required String category,
  required int amount,
  required File? invoiceFile,
}) async {
  try {
    Response response;

    /// ---------------- NO IMAGE → SEND JSON ----------------
    if (invoiceFile == null) {
      final body = {
        "userId": userId,
        "title": item,
        "type": type,
        "icon": icon,
        "category": category,
        "amount": amount,
      };

      response = await dio.post(
        "/transactions",
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
    }

    /// ---------------- IMAGE EXISTS → SEND MULTIPART ----------------
    else {
      FormData formData = FormData.fromMap({
        "userId": userId,
        "title": item,
        "type": type,
        "icon": icon,
        "category": category,
        "amount": amount,
        "invoice": await MultipartFile.fromFile(
          invoiceFile.path,
          filename: invoiceFile.path.split('/').last,
        ),
      });

      response = await dio.post(
        "/transactions",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    }

    print("ttttttttt RESPONSE ---> ${response.data}");
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    if (e is DioException) {
      print("ERROR STATUS ---> ${e.response?.statusCode}");
      print("ERROR DATA ---> ${e.response?.data}");
    } else {
      print("ttttttttt ERROR ---> $e");
    }
    return false;
  }
}

}



















// import 'dart:io';
// import 'package:dio/dio.dart';
//
// class TransactionService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: "https://expense-tracker-backend-48vm.onrender.com/api",
//     ),
//   );
//
//   Future<bool> createTransaction({
//     required String token,
//     required String userId,
//     required String item,
//     required String type,
//     required String icon,
//     required String category,
//     required int amount,
//     required File? invoiceFile,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "userId": userId,
//         "title": item,
//         "type": type,
//         "icon": icon,
//         "category": category,
//         "amount": amount,
//         if (invoiceFile != null)
//           "invoice": await MultipartFile.fromFile(
//             invoiceFile.path,
//             filename: invoiceFile.path.split('/').last,
//           ),
//       });
//
//       final response = await _dio.post(
//         "/transactions",
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );
//
//       print("TOKEN ---> $token");
//       print("USER ID ---> $userId");
//       print("ttttttttt RESPONSE ---> ${response.data}");
//
//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       print("TOKEN ---> $token");
//       print("USER ID ---> $userId");
//       print("ttttttttt ERROR ---> $e");
//       return false;
//     }
//   }
// }






class a{}
















// import 'dart:io';
// import 'package:dio/dio.dart';
//
// class TransactionService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: "https://expense-tracker-backend-48vm.onrender.com/api",
//     ),
//   );
//
//   // ✅ Updated return type to Future<bool>
//   Future<bool> createTransaction({
//     required String token,
//     required String userId,
//     required String item,
//     required String type,
//     required String icon,
//     required String category,
//     required int amount,
//     required File? invoiceFile,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "userId": userId,
//         "item": item,
//         "type": type,
//         "icon": icon,
//         "category": category,
//         "amount": amount,
//         if (invoiceFile != null)
//           "invoice": await MultipartFile.fromFile(
//             invoiceFile.path,
//             filename: invoiceFile.path.split('/').last,
//           ),
//       });
//
//       final response = await _dio.post(
//         "/transactions",
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );
//
//       print("TOKEN ---> $token");
//       print("USER ID ---> $userId");
//       print("SUCCESS: ${response.data}");
//
//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       print("TOKEN ---> $token");
//       print("USER ID ---> $userId");
//       print("🔥 ERROR: $e");
//       return false; // 🔹 Error return
//     }
//   }
// }


















// import 'dart:io';
// import 'package:dio/dio.dart';
//
// class TransactionService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: "https://expense-tracker-backend-48vm.onrender.com/api",
//     ),
//   );
//
//   Future<void> createTransaction({
//     required String token,
//     required String userId,
//     required String item,
//     required int amount,
//     required File? invoiceFile,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "userId": userId,
//         "item": item,
//         "amount": amount,
//         if (invoiceFile != null)
//           "invoice": await MultipartFile.fromFile(
//             invoiceFile.path,
//             filename: invoiceFile.path.split('/').last,
//           ),
//       });
//
//       final response = await _dio.post(
//         "/transactions",
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );
//       print("TOKEN ---> $token");
//       print("USER ID ---> $userId");
//       print("SUCCESS pppppp : ${response.data}");
//     } catch (e) {
//       print("TOKEN ---> $token");
//       print("USER ID ---> $userId");
//       print("🔥 ERROR pppp : $e");
//     }
//   }
// }
