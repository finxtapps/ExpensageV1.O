import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Api_Services/transaction_history_services.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, this.budgetNotifier});

  final ValueNotifier<int>? budgetNotifier;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final TransactionHistoryService _service = TransactionHistoryService();
  bool _hasShownNegativeAlert = false; // केवल एक बार show करने के लिए
  String? _token;
  String? _userId;
  bool _isLoading = true;

  int? _manualBudget;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    widget.budgetNotifier?.addListener(() {
      setState(() {
        _manualBudget = widget.budgetNotifier?.value;
      });
    });
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
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🔥 Jab tak data load na ho loading dikhao
    if (_isLoading || _token == null || _userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: _service.getIncomeExpenseStream(
        userId: _userId!,
        token: _token!
      ),
      builder: (context, snapshot) {
        final income = snapshot.data?["income"] ?? 0;
        final expense = snapshot.data?["expense"] ?? 0;

        final monthlyBudget = _manualBudget ?? (income - expense);

        // Negative check → popup alert
        if (monthlyBudget < 0 && !_hasShownNegativeAlert) {
          _hasShownNegativeAlert = true; // ताकि बार-बार show न हो
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text("alert".tr()),
                  content: Text("budget_negative_msg".tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text("ok".tr()),
                    ),
                  ],
                );
              },
            );
          });
        }

        return Container(
          height: 195.h,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode ? const Color(0xFFD44D5C) : Colors.white.withOpacity(0.9),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- Header ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Monthly Budget',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ],
              ),

              SizedBox(height: 10),

              // ---------------- Total Balance (Monthly Budget - Expense) ----------------
              Text(
                '\$ $monthlyBudget',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 18.h),

              // ---------------- Income & Expense Row ----------------
              Row(
                children: [
                  // ------------ Income ------------
                  Expanded(
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
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 16.5.sp,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Income',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.3.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '\$ $income',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 15.w),

                  // ------------ Expense ------------
                  Expanded(
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
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 16.5.sp,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expenses',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.3.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '\$ $expense',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
