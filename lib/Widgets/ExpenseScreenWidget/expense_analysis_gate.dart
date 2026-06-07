import 'package:flutter/material.dart';
import '../../Screens/expense_analysis_screen.dart';
import '../../shared_prefrence/SharedPrefrenceMethods.dart';
import 'guest_expense_analysis_screen.dart';


class ExpenseAnalysisGate extends StatefulWidget {
  final bool active;
  const ExpenseAnalysisGate({super.key, this.active = false});

  @override
  State<ExpenseAnalysisGate> createState() => _ExpenseAnalysisGateState();
}

class _ExpenseAnalysisGateState extends State<ExpenseAnalysisGate> {
  bool _loading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final pref = SharedPreferenceMethods();
    final token = await pref.getToken();
    final userId = await pref.getUserId();

    _isLoggedIn =
        token != null && token.isNotEmpty && userId != null && userId.isNotEmpty;

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _isLoggedIn
        ? ExpenseAnalysisScreen(active: widget.active)
        : const GuestExpenseAnalysisScreen();
  }
}
