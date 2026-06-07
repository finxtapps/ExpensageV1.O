import 'package:flutter/material.dart';
import '../Api_Services/transaction_history_services.dart';
import '../Api_Models/transaction_History_model.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionHistoryService _service =
  TransactionHistoryService();

  List<TransactionData> _transactions = [];
  List<TransactionData> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchTransactions(
      String userId,
      String token,
      ) async {

    _isLoading = true;
    notifyListeners();

    final response =
    await _service.getTransactionHistory(userId, token);

    if (response != null && response.data != null) {
      // 🔥 DIRECT MODEL STORE
      _transactions = response.data!;
    } else {
      _transactions = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}


