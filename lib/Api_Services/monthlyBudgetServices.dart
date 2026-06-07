import 'package:dio/dio.dart';
import '../Api_Models/monthlyBudgetModel.dart';

class BudgetService {
  static const String baseUrl =
      "https://expense-tracker-2k3t.onrender.com/api/budgets";

  final Dio _dio;

  /// 🔐 Bearer Token
  BudgetService({required String token})
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// ==========================
  /// 📥 GET Budget (by userId)
  /// ==========================
  Future<BudgetModel> getBudget(String userId) async {
    try {
      print("GET Budget called for userId: $userId");

      final response = await _dio.get(
        '',
        queryParameters: {"userId": userId},
      );

      print("Response status: ${response.statusCode}");
      print("Raw response data: ${response.data}");

      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['data'] != null) {

        final List budgets = response.data['data'];

        /// ❗ If no budget found
        if (budgets.isEmpty) {
          return BudgetModel(
            id: '',
            totalBudget: 0,
            currency: '₹',
            notes: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(), userId: userId,
          );
        }

        final latestBudgetJson = budgets.last;
        final model = BudgetModel.fromJson(latestBudgetJson);

        /// 🔍 Check if budget belongs to current month
        final now = DateTime.now();
        final budgetDate = model.createdAt;

        if (budgetDate.month != now.month || budgetDate.year != now.year) {
          print("Budget is NOT for current month → returning 0");

          return BudgetModel(
            id: model.id,
            totalBudget: 0,
            currency: model.currency,
            notes: model.notes,
            createdAt: now,
            updatedAt: now,
            userId: userId,
          );
        }

        print("Budget is current month → ${model.totalBudget}");
        return model;
      }

      /// fallback
      return BudgetModel(
        id: '',
        totalBudget: 0,
        currency: '₹',
        notes: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: userId,
      );
    } on DioException catch (e) {
      print("DioException: ${e.response?.data}");

      throw Exception(
        e.response?.data['message'] ?? "Failed to fetch budget",
      );
    }
  }

  /// ==========================
  /// 📤 POST / UPDATE Budget
  /// ==========================
  Future<BudgetModel> updateBudget({
    required String userId,
    required int totalBudget,
  }) async {
    try {
      final response = await _dio.post(
        '',
        data: {
          "userId": userId,
          "totalBudget": totalBudget,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {

        return BudgetModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to update budget",
      );
    }
  }
}


























// import 'package:dio/dio.dart';
// import '../Api_Models/monthlyBudgetModel.dart';
//
// class BudgetService {
//   static const String baseUrl =
//       "https://expense-tracker-backend-48vm.onrender.com/api/budgets";
//
//   final Dio _dio;
//
//   /// 🔐 Bearer Token
//   BudgetService({required String token})
//       : _dio = Dio(
//     BaseOptions(
//       baseUrl: baseUrl,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//     ),
//   );
//
//   /// ==========================
//   /// 📥 GET Budget (by userId)
//   /// ==========================
//
//   Future<BudgetModel?> getBudget(String userId) async {
//     try {
//       print("vvvvvvvvvv GET Budget called for userId: $userId");
//
//       final response = await _dio.get(
//         '',
//         queryParameters: {"userId": userId},
//       );
//
//       print("vvvvvvvvvv Response status: ${response.statusCode}");
//       print("vvvvvvvvvv Raw response data: ${response.data}");
//
//       if (response.statusCode == 200 &&
//           response.data['success'] == true &&
//           response.data['data'] != null) {
//
//         final List budgets = response.data['data'];
//
//         if (budgets.isEmpty) {
//           return BudgetModel(
//           //  userId: userId,
//             totalBudget: 0,
//             createdAt: DateTime.now(), id: '', currency: '', notes: '', updatedAt: null,
//           );
//         }
//
//         final latestBudgetJson = budgets.last;
//         final model = BudgetModel.fromJson(latestBudgetJson);
//
//         /// 🔍 Check month
//         final now = DateTime.now();
//         final budgetDate = model.createdAt;
//
//         if (budgetDate.month != now.month || budgetDate.year != now.year) {
//           print("vvvvvvvvvv Budget is NOT for current month → returning 0");
//
//           return BudgetModel(
//             userId: userId,
//             totalBudget: 0,
//             createdAt: now,
//           );
//         }
//
//         print("vvvvvvvvvv Budget is current month → ${model.totalBudget}");
//         return model;
//       }
//
//       return BudgetModel(
//         userId: userId,
//         totalBudget: 0,
//         createdAt: DateTime.now(),
//       );
//     } on DioException catch (e) {
//       print("vvvvvvvvvv DioException: ${e.response?.data}");
//       throw Exception(
//         e.response?.data['message'] ?? "Failed to fetch budget",
//       );
//     }
//   }
//
//
//
//
//
//
//   // Future<BudgetModel?> getBudget(String userId) async {
//   //   try {
//   //     print("vvvvvvvvvv GET Budget called for userId: $userId");
//   //
//   //     final response = await _dio.get(
//   //       '',
//   //       queryParameters: {"userId": userId},
//   //     );
//   //
//   //     print("vvvvvvvvvv Response status: ${response.statusCode}");
//   //     print("vvvvvvvvvv Raw response data: ${response.data}");
//   //
//   //     if (response.statusCode == 200 &&
//   //         response.data['success'] == true &&
//   //         response.data['data'] != null) {
//   //
//   //       final List budgets = response.data['data'];
//   //       print("vvvvvvvvvv Budgets list length: ${budgets.length}");
//   //
//   //       if (budgets.isEmpty) {
//   //         print("vvvvvvvvvv Budgets list is EMPTY");
//   //         return null;
//   //       }
//   //
//   //       final latestBudgetJson = budgets.last;
//   //       print("vvvvvvvvvv Latest budget JSON: $latestBudgetJson");
//   //
//   //       final model = BudgetModel.fromJson(latestBudgetJson);
//   //       print("vvvvvvvvvv Parsed totalBudget: ${model.totalBudget}");
//   //
//   //       return model;
//   //     }
//   //
//   //     print("vvvvvvvvvv Condition failed, returning null");
//   //     return null;
//   //   } on DioException catch (e) {
//   //     print("vvvvvvvvvv DioException: ${e.response?.data}");
//   //     throw Exception(
//   //       e.response?.data['message'] ?? "Failed to fetch budget",
//   //     );
//   //   }
//   // }
//
//
//
//   /// ==========================
//   /// 📤 POST / UPDATE Budget
//   /// ==========================
//   Future<BudgetModel> updateBudget({
//     required String userId,
//     required int totalBudget,
//   }) async {
//     try {
//       final response = await _dio.post(
//         '',
//         data: {
//           "userId": userId,
//           "totalBudget": totalBudget,
//         },
//       );
//
//       if ((response.statusCode == 200 || response.statusCode == 201) &&
//           response.data['success'] == true) {
//         return BudgetModel.fromJson(response.data['data']);
//       } else {
//         throw Exception(response.data['message']);
//       }
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data['message'] ?? "Failed to update budget",
//       );
//     }
//   }
// }
