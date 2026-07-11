import 'package:dio/dio.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../Api_Models/top_category_model.dart';
import '../ulitity/NetworkManager.dart';



class TopCategoryService {
  final Dio _dio = Dio();

  final String baseUrl =
      "${NetworkManager().baseUrl}categories/top";

  Future<TopCategoryResponse?> getTopCategories({String? period}) async {
    try {
      final token = await SharedPreferenceMethods().getToken();

      print("Token: $token");

      final response = await _dio.get(
        baseUrl,
        queryParameters: period != null ? {"period": period} : null,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      print(response.requestOptions.headers);
      print(response.data);

      if (response.statusCode == 200) {
        return TopCategoryResponse.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}















// import 'package:dio/dio.dart';
//
// import '../Api_Models/top_category_model.dart';
// import '../ulitity/NetworkManager.dart';
//
// class TopCategoryService {
//   final Dio _dio = Dio();
//
//   final String baseUrl =
//       "${NetworkManager().baseUrl}categories/top";
//
//
//   Future<TopCategoryResponse?> getTopCategories({String? period}) async {
//     try {
//       print("kkkkkkkkkkkk Base URL: $baseUrl");
//       print("kkkkkkkkkkkk Period: $period");
//
//       final response = await _dio.get(
//         baseUrl,
//         queryParameters: period != null ? {"period": period} : null,
//       );
//
//       print("kkkkkkkkkkkk Status Code: ${response.statusCode}");
//       print("kkkkkkkkkkkk Response: ${response.data}");
//       print("kkkkkkkkkkkk Headers: ${response.requestOptions.headers}");
//       if (response.statusCode == 200) {
//         return TopCategoryResponse.fromJson(response.data);
//       }
//
//       return null;
//     } on DioException catch (e) {
//       print("eeekkkkkkkkkkkk Dio Error: ${e.message}");
//       print("eeekkkkkkkkkkkk Status: ${e.response?.statusCode}");
//       print("eeeekkkkkkkkkkkk Data: ${e.response?.data}");
//       return null;
//     } catch (e, s) {
//       print(e);
//       print(s);
//       return null;
//     }
//   }
//
//
//
//
//   // Future<TopCategoryResponse?> getTopCategories({String? period}) async {
//   //   try {
//   //     Response response;
//   //
//   //     if (period != null && period.isNotEmpty) {
//   //       response = await _dio.get(
//   //         baseUrl,
//   //         queryParameters: {
//   //           "period": period,
//   //         },
//   //       );
//   //     } else {
//   //       response = await _dio.get(baseUrl);
//   //       print("cccccccccccc ${response.data}");
//   //     }
//   //
//   //     if (response.statusCode == 200) {
//   //       return TopCategoryResponse.fromJson(response.data);
//   //     }
//   //
//   //     return null;
//   //   } on DioException catch (e) {
//   //     print("❌ cccccc Dio Error: ${e.message}");
//   //     return null;
//   //   } catch (e) {
//   //     print("❌ cccccc Error: $e");
//   //     return null;
//   //   }
//   // }
//
//
//
// }
//

