import 'package:flutter/material.dart';

import '../Api_Models/top_category_model.dart';
import '../Api_Services/top_category_service.dart';

class TopCategoryProvider extends ChangeNotifier {
  final TopCategoryService _service = TopCategoryService();

  TopCategoryResponse? _response;
  bool _isLoading = false;

  TopCategoryResponse? get response => _response;
  bool get isLoading => _isLoading;

  /// Current selected filter
  String selectedFilter = "Yearly";

  Future<void> fetchTopCategories({String? period}) async {
    _isLoading = true;
    notifyListeners();

    _response = await _service.getTopCategories(period: period);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeFilter(String filter) async {
    selectedFilter = filter;

    String? period;

    switch (filter) {
      case "Weekly":
        period = "weekly";
        break;

      case "Monthly":
        period = "monthly";
        break;

      case "Yearly":
        period = "yearly";
        break;

      case "Lifetime":
        period = null;
        break;
    }

    await fetchTopCategories(period: period);
  }

  Future<void> refresh() async {
    await changeFilter(selectedFilter);
  }
}