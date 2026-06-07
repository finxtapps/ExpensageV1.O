

import 'dart:async';
import 'package:provider/provider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Api_Services/getBudgetStream.dart';
import '../../Api_Services/transaction_history_services.dart';
import '../../shared_prefrence/SharedPrefrenceMethods.dart';
import '../../providerListner/currency_notifier.dart';

class BalanceCard extends StatefulWidget {
  final BudgetStreamService budgetStreamService;

  const BalanceCard({
    super.key,
    required this.budgetStreamService,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final TransactionHistoryService _service = TransactionHistoryService();

  StreamSubscription<int>? _budgetSubscription;
  int? _manualBudget;
  bool _hasShownNegativeAlert = false;

  String? _token;
  String? _userId;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _listenBudget();
    _loadUserData();
  }

  void _listenBudget() async {
    _budgetSubscription =
        widget.budgetStreamService.budgetStream.listen((budget) {
          setState(() {
            _manualBudget = budget;
            _hasShownNegativeAlert = false;
          });
        });

    await widget.budgetStreamService.loadFromLocal();
    await widget.budgetStreamService.fetchBudget();
  }
  Future<void> _loadUserData() async {
    final prefs = SharedPreferenceMethods();
    _token = await prefs.getToken();
    _userId = await prefs.getUserId();

    setState(() {
      _isLoading = false;
    });
  }
  @override
  void dispose() {
    _budgetSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
SharedPreferenceMethods pref=SharedPreferenceMethods();
    if (_isLoading || _userId == null || _token == null) {
      return const SizedBox(); // ya CircularProgressIndicator()
    }


    return StreamBuilder(
      stream: _service.getIncomeExpenseStream(
        userId: _userId!,
        token: _token!,
      ),
      builder: (context, snapshot) {
        final income = snapshot.data?["income"] ?? 0;
        final expense = snapshot.data?["expense"] ?? 0;
final monthlyBudget = (_manualBudget ?? 0) - expense;
       // final monthlyBudget = _manualBudget ?? (income - expense);

        if (monthlyBudget < 0 && !_hasShownNegativeAlert) {
          _hasShownNegativeAlert = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Alert"),
                content: const Text(
                    "Your Monthly Budget is Overflow! Please review your expenses."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child:  Text("OK",style: TextStyle(color:isDarkMode? Colors.white:
                    Theme.of(context).colorScheme.primary
                    ),),
                  ),
                ],
              ),
            );
          });
        }

        /// 🔥 UI SAME AS BEFORE (NO CHANGE)
        return Container(
          height: 195.h,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode
                  ? const Color(0xFFD44D5C)
                  : Colors.white.withOpacity(0.9),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'monthly_budget'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 20.sp),
                    ],
                  ),
                  Icon(Icons.more_horiz,
                      color: Colors.white, size: 24.sp),
                ],
              ),
              SizedBox(height: 10),
              Consumer<CurrencyNotifier>(
                builder: (_, currencyProvider, __) {
                  return Text(
                    '${currencyProvider.currency} $monthlyBudget',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),

              SizedBox(height: 18.h),
              Row(
                children: [
                  _buildTile(
                      icon: Icons.arrow_downward,
                      title: 'income'.tr(),
                      amount: income,
                      isDarkMode: isDarkMode),
                  SizedBox(width: 15.w),
                  _buildTile(
                      icon: Icons.arrow_upward,
                      title: 'expenses'.tr(),
                      amount: expense,
                      isDarkMode: isDarkMode),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required double amount,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFFD44D5C)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 16.5.sp),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.3.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),

              Consumer<CurrencyNotifier>(
                builder: (_, currencyProvider, __) {
                  return Text(
                    '${currencyProvider.currency} $amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}


