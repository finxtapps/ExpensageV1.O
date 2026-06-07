import 'dart:async';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import 'monthlyBudgetServices.dart';

class BudgetStreamService {
  final BudgetService _budgetService;
  final SharedPreferenceMethods _prefs = SharedPreferenceMethods();
  final String userId;

  BudgetStreamService({
    required String token,
    required this.userId,
  }) : _budgetService = BudgetService(token: token);

  final StreamController<int> _controller = StreamController<int>.broadcast();

  Stream<int> get budgetStream => _controller.stream;


  /// 🔥 Instant UI update (without API call)
  void updateLocalBudget(int budget) {
    _prefs.saveUserMonthlyBudget(budget.toString());
    _controller.add(budget);

    print("vvvvvvvvvv updateLocalBudget pushed: $budget");
  }




  /// 🔹 Load saved budget from SharedPreferences first
  Future<void> loadFromLocal() async {
    try {
      final savedBudget = await _prefs.getUserMonthlyBudget();
      if (savedBudget != null) {
        _controller.add(int.parse(savedBudget));
        print("Loaded budget from local: $savedBudget");
      }
    } catch (e) {
      print("Error loading budget from local: $e");
    }
  }

  /// 🔹 Fetch latest budget from API
  Future<void> fetchBudget() async {
    try {
      print("vvvvvvvvvv fetchBudget() called");

      final budget = await _budgetService.getBudget(userId);

      print("vvvvvvvvvv Budget object: $budget");

      if (budget != null) {
        final int totalBudget = budget.totalBudget;

        print("vvvvvvvvvv totalBudget from model: $totalBudget");

        await _prefs.saveUserMonthlyBudget(totalBudget.toString());
        print("vvvvvvvvvv Saved to SharedPreferences");

        _controller.add(totalBudget);
        print("vvvvvvvvvv Added to stream");
      } else {
        print("vvvvvvvvvv Budget is NULL from API");
      }
    } catch (e) {
      print("vvvvvvvvvv Exception in fetchBudget: $e");
    }
  }


  void dispose() {
    _controller.close();
  }
}
