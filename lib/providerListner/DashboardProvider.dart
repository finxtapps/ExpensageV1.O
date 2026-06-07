import 'package:flutter/material.dart';
import '../Api_Models/Bar_graph_model.dart';
import '../Api_Services/Bar_graph_services.dart';

class DashboardProvider extends ChangeNotifier {

  bool isLoading = false;

  // Bar Graph
  BarGraphResponse? barGraphResponse;

  Future<void> refreshAll() async {

    isLoading = true;
    notifyListeners();

    try {

      await Future.wait([
        fetchBarGraph(),

        // fetchPieChart(),
        // fetchTransactions(),
        // fetchBalance(),
        // fetchAnalytics(),
      ]);

    } catch (e) {
      debugPrint("Dashboard Error => $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBarGraph() async {

    try {

      final service = BarGraphService();

      barGraphResponse =
      await service.getBarGraphData();

    } catch (e) {

      debugPrint(
        "Bar Graph Error => $e",
      );
    }

    notifyListeners();
  }
}