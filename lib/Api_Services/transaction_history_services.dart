import 'package:dio/dio.dart';
import '../Api_Models/transaction_History_model.dart';


class TransactionHistoryService {
  final Dio _dio = Dio();

  final String apiUrl =
      "https://expense-tracker-2k3t.onrender.com/api/transaction-history";

  Future<TransactionHistoryModel?> getTransactionHistory(
      String userId, String token) async {
    try {
      Response response = await _dio.get(
        "$apiUrl/$userId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return TransactionHistoryModel.fromJson(response.data);
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }

  /// Income + Expense Calculate Stream

  Stream<Map<String, double>> getIncomeExpenseStream({
    required String userId,
    required String token,
  }) async* {
    while (true) {
      final data = await getTransactionHistory(userId, token);

      double income = 0;
      double expense = 0;

      final now = DateTime.now();

      data?.data?.forEach((transaction) {
        if (transaction.date != null) {
          DateTime transactionDate = DateTime.parse(transaction.date!);

          // ✅ Check current month & year
          if (transactionDate.month == now.month &&
              transactionDate.year == now.year) {

            if (transaction.type == "income") {
              income += transaction.amount ?? 0;
            } else {
              expense += transaction.amount ?? 0;
            }
          }
        }
      });

      yield {
        "income": income,
        "expense": expense,
      };

      await Future.delayed(const Duration(seconds: 3));
    }
  }



  Future<List<MapEntry<String, double>>> getTop5ExpenseCategories({
    required String userId,
    required String token,
  }) async {
    final data = await getTransactionHistory(userId, token);

    Map<String, double> categoryTotals = {};

    if (data?.data != null) {
      for (var transaction in data!.data!) {
        // ✅ Sirf expense type lo
        if (transaction.type == "expense") {
          String category = transaction.category ?? "Other";
          num amount = transaction.amount ?? 0;

          categoryTotals[category] =
              (categoryTotals[category] ?? 0) + amount;
        }
      }
    }

    // ✅ Sort descending
    var sorted = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // ✅ Top 5 return karo
    return sorted.take(5).toList();
  }


}

