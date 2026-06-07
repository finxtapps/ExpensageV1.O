import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyNotifier extends ChangeNotifier {
  String _currency = "₹";
  String get currency => _currency;

  CurrencyNotifier(); // ✅ EMPTY

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('user_currency');

    if (saved != null && saved.isNotEmpty) {
      _currency = saved;
      notifyListeners();
    }
  }

  Future<void> updateCurrency(String newCurrency) async {
    if (_currency == newCurrency) return;

    _currency = newCurrency;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_currency', newCurrency);
  }
}



