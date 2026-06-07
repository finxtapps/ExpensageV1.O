import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Widgets/ExpenseScreenWidget/ExpenseAnalysisHeader.dart';
import '../Widgets/ExpenseScreenWidget/bar_chart.dart';
import '../Widgets/ExpenseScreenWidget/guest_bar_graph.dart';
import '../Widgets/ExpenseScreenWidget/pieChatWithService.dart';
import '../Widgets/ExpenseScreenWidget/pie_chart.dart';
import '../component/transaction_list.dart';
import '../providerListner/DashboardProvider.dart';
import '../providerListner/addTransactionProvider.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';

class ExpenseAnalysisScreen extends StatefulWidget {
  final bool active;

  const ExpenseAnalysisScreen({Key? key, this.active = false})
    : super(key: key);

  @override
  State<ExpenseAnalysisScreen> createState() => _ExpenseAnalysisScreenState();
}

class _ExpenseAnalysisScreenState extends State<ExpenseAnalysisScreen> {
  final GlobalKey _filterIconKey = GlobalKey();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initScreens();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      context
          .read<DashboardProvider>()
          .refreshAll();

    });
  }



  // @override
  // void initState() {
  //   super.initState();
  //
  //   Future.microtask(() async {
  //     final prefs = SharedPreferenceMethods();
  //     final token = await prefs.getToken();
  //     final userId = await prefs.getUserId();
  //
  //     if (token != null && userId != null) {
  //       if (mounted) {
  //         context.read<TransactionProvider>()
  //             .fetchTransactions(userId, token);
  //       }
  //     }
  //   });
  // }




  Future<void> _initScreens() async {
    final prefs = SharedPreferenceMethods();
    final token = await prefs.getToken();
    final userId = await prefs.getUserId();

    final loggedIn =
        token != null &&
        token.isNotEmpty &&
        userId != null &&
        userId.isNotEmpty;

    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  String selectedFilter = "Lifetime";

  void _showFilterDrawer() {
    final options = ['Lifetime', 'Weekly', 'Monthly', 'Yearly'];

    final RenderBox renderBox =
    _filterIconKey.currentContext!.findRenderObject() as RenderBox;

    final Offset position = renderBox.localToGlobal(Offset.zero);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filter",
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned(
              top: position.dy + renderBox.size.height + 8,
              right: 16, // right align with icon feel
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((option) {
                      return _buildFilterOption(option);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final mediaHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: isDarkMode?Theme.of(context).colorScheme.primary
            :Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            /// HEADER SECTION
            Column(
              children: [
                SizedBox(
                  height: mediaHeight * 0.12,
                  child: ExpenseanalysisHeader(),
                ),
              ],
            ),

            /// SCROLLABLE CONTENT
            Padding(
              padding: EdgeInsets.only(top: mediaHeight * 0.125),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// BAR CHART
                    _isLoggedIn
                        ? const BarChartWidget()
                        : const GuestBarChartWidget(),

                    SizedBox(height: 10.h),

                    /// PIE / RADIAL CHART
                    _isLoggedIn
                        ? PieServiceChartWidget(active: widget.active)
                        : RadialChartWidget(active: widget.active),

                    SizedBox(height: 10.h),

                    /// TRANSACTION LIST
                    Padding(
                      padding: EdgeInsets.only(top: mediaHeight * 0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'transaction_history'.tr(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final prefs = SharedPreferenceMethods();
                                        final token = await prefs.getToken();
                                        final userId = await prefs.getUserId();

                                        if (token != null && userId != null) {
                                          context
                                              .read<TransactionProvider>()
                                              .fetchTransactions(userId, token);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: Text(
                                          "refresh".tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      key: _filterIconKey,
                                      onTap: _showFilterDrawer,
                                      child: const Icon(Icons.filter_alt),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),


                            Container(

                              color: isDarkMode
                                  ? Color(0xFFD44D5C)
                                  :Theme.of(context).scaffoldBackgroundColor,
                              child: TransactionList(
                                scrolling: true,
                                selectedFilter: selectedFilter,
                                onFilterChanged: (value) {
                                  setState(() {
                                    selectedFilter = value;
                                  });
                                },
                              ),
                            ),



                            // Container(
                            //   color: isDarkMode
                            //       ? Theme.of(context).scaffoldBackgroundColor
                            //       : Colors.white,
                            //   child:TransactionList(
                            //     selectedFilter: selectedFilter,
                            //     onFilterChanged: (value) {
                            //       setState(() {
                            //         selectedFilter = value;
                            //       });
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildFilterOption(String option) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final isSelected = selectedFilter == option;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = option;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 20,
              color:isDarkMode? Color(0xFFD44D5C): Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Text(option),
          ],
        ),
      ),
    );
  }


}
